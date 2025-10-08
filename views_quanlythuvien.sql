USE QuanLyThuVien;
GO
-- 2.1 VW_ThongTinChiTietDocGia
IF OBJECT_ID('dbo.VW_ThongTinChiTietDocGia') IS NOT NULL DROP VIEW dbo.VW_ThongTinChiTietDocGia;
GO
CREATE VIEW dbo.VW_ThongTinChiTietDocGia
AS
SELECT 
    dg.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    tk.MaTaiKhoan,
    tk.TenDangNhap,
    tk.LoaiTaiKhoan,
    tk.TrangThai AS TrangThaiTaiKhoan,
    th.MaThe,
    th.NgayCap,
    th.NgayHetHan,
    th.TrangThai AS TrangThaiTheGoc,
    dbo.fn_The_TrangThaiHieuLuc(dg.MaDocGia) AS TrangThaiTheHieuLuc,
    dg.NgayDangKy,
    dg.TrangThai AS TrangThaiDocGia
FROM DocGia dg
JOIN TaiKhoan tk ON tk.MaTaiKhoan = dg.MaTaiKhoan
LEFT JOIN The th ON th.MaDocGia = dg.MaDocGia;
GO

-- 2.2 VW_TimKiemSachToanDien
IF OBJECT_ID('dbo.VW_TimKiemSachToanDien') IS NOT NULL DROP VIEW dbo.VW_TimKiemSachToanDien;
GO
CREATE VIEW dbo.VW_TimKiemSachToanDien
AS
SELECT 
    ds.MaDauSach,
    ds.TenSach,
    ds.ISBN,
    ds.TrangThai AS TrangThaiDauSach,
    -- Thống kê số lượng bản sao theo tình trạng
    SUM(CASE WHEN bs.TinhTrang = N'CoSan'    THEN 1 ELSE 0 END) AS SoBanSao_CoSan,
    SUM(CASE WHEN bs.TinhTrang = N'DangMuon' THEN 1 ELSE 0 END) AS SoBanSao_DangMuon,
    SUM(CASE WHEN bs.TinhTrang = N'Hong'     THEN 1 ELSE 0 END) AS SoBanSao_Hong,
    SUM(CASE WHEN bs.TinhTrang = N'Mat'      THEN 1 ELSE 0 END) AS SoBanSao_Mat,
    SUM(CASE WHEN bs.TinhTrang = N'BaoTri'   THEN 1 ELSE 0 END) AS SoBanSao_BaoTri,
    COUNT(bs.MaBanSao) AS TongBanSao,
    -- Vị trí kệ các bản sao 'Còn sẵn' để tra cứu nhanh
    STRING_AGG(CASE WHEN bs.TinhTrang = N'CoSan' THEN bs.ViTriKe END, N', ') 
        WITHIN GROUP (ORDER BY bs.ViTriKe) AS ViTriKe_CoSan
FROM DauSach ds
LEFT JOIN BanSao bs ON bs.MaDauSach = ds.MaDauSach
GROUP BY ds.MaDauSach, ds.TenSach, ds.ISBN, ds.TrangThai;
GO

-- 2.3 VW_SachCanBaoTri
IF OBJECT_ID('dbo.VW_SachCanBaoTri') IS NOT NULL DROP VIEW dbo.VW_SachCanBaoTri;
GO
CREATE VIEW dbo.VW_SachCanBaoTri
AS
SELECT 
    bs.MaBanSao,
    ds.MaDauSach,
    ds.TenSach,
    bs.TinhTrang,       -- Hong | Mat | BaoTri
    bs.ViTriKe,
    bs.NgayNhap
FROM BanSao bs
JOIN DauSach ds ON ds.MaDauSach = bs.MaDauSach
WHERE bs.TinhTrang IN (N'Hong', N'Mat', N'BaoTri');
GO

-- 2.4 VW_PhieuMuonDangHoatDong (phiếu chưa trả hết)
IF OBJECT_ID('dbo.VW_PhieuMuonDangHoatDong') IS NOT NULL DROP VIEW dbo.VW_PhieuMuonDangHoatDong;
GO
CREATE VIEW dbo.VW_PhieuMuonDangHoatDong
AS
SELECT 
    pm.MaPhieuMuon,
    pm.NgayMuon,
    pm.HanTra,
    pm.TrangThai,
    dg.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    tt.MaThuThu,
    tt.HoTen AS HoTenThuThu,
    -- số đầu sách trong phiếu và số đã trả
    COUNT(ctm.MaChiTietMuon) AS TongSachTrongPhieu,
    SUM(CASE WHEN ctm.NgayTraThucTe IS NOT NULL THEN 1 ELSE 0 END) AS SoSachDaTra,
    SUM(CASE WHEN ctm.NgayTraThucTe IS NULL THEN 1 ELSE 0 END) AS SoSachChuaTra
FROM PhieuMuon pm
JOIN DocGia dg ON dg.MaDocGia = pm.MaDocGia
JOIN ThuThu tt ON tt.MaThuThu = pm.MaThuThu
JOIN ChiTietMuon ctm ON ctm.MaPhieuMuon = pm.MaPhieuMuon
GROUP BY pm.MaPhieuMuon, pm.NgayMuon, pm.HanTra, pm.TrangThai, dg.MaDocGia, dg.HoTen, tt.MaThuThu, tt.HoTen
HAVING SUM(CASE WHEN ctm.NgayTraThucTe IS NULL THEN 1 ELSE 0 END) > 0;  -- còn sách chưa trả
GO

-- 2.5 VW_PhieuMuonQuaHan (đầy đủ thông tin, kèm số ngày quá hạn tính tại thời điểm hiện tại)
IF OBJECT_ID('dbo.VW_PhieuMuonQuaHan') IS NOT NULL DROP VIEW dbo.VW_PhieuMuonQuaHan;
GO
CREATE VIEW dbo.VW_PhieuMuonQuaHan
AS
SELECT 
    pm.MaPhieuMuon,
    pm.NgayMuon,
    pm.HanTra,
    dg.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    tt.MaThuThu,
    tt.HoTen AS HoTenThuThu,
    dbo.fn_PhieuMuon_SoNgayQuaHan(pm.MaPhieuMuon) AS SoNgayQuaHan,
    -- trạng thái phiếu vẫn giữ nguyên để tiện đối chiếu
    pm.TrangThai
FROM PhieuMuon pm
JOIN DocGia dg ON dg.MaDocGia = pm.MaDocGia
JOIN ThuThu tt ON tt.MaThuThu = pm.MaThuThu
WHERE 
    -- quá hạn khi HanTra < hôm nay và còn ít nhất một cuốn chưa trả
    pm.HanTra < GETDATE()
    AND EXISTS (
        SELECT 1 FROM ChiTietMuon x 
        WHERE x.MaPhieuMuon = pm.MaPhieuMuon AND x.NgayTraThucTe IS NULL
    );
GO

-- 2.6 VW_DatTruocDangCho (xếp hàng theo từng đầu sách)
IF OBJECT_ID('dbo.VW_DatTruocDangCho') IS NOT NULL DROP VIEW dbo.VW_DatTruocDangCho;
GO
CREATE VIEW dbo.VW_DatTruocDangCho
AS
SELECT 
    dt.MaDatTruoc,
    dt.MaDauSach,
    ds.TenSach,
    dt.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    dt.NgayDat,
    dt.NgayHetHan,
    dt.TrangThai,
    ROW_NUMBER() OVER (PARTITION BY dt.MaDauSach ORDER BY dt.NgayDat ASC, dt.MaDatTruoc ASC) AS ThuTuHangDoi
FROM DatTruoc dt
JOIN DocGia dg ON dg.MaDocGia = dt.MaDocGia
JOIN DauSach ds ON ds.MaDauSach = dt.MaDauSach
WHERE dt.TrangThai = N'DangCho'
  AND dt.NgayHetHan >= GETDATE();
GO


/*========================================================
= 3) VIEW TÀI CHÍNH & VI PHẠM
========================================================*/

-- 3.1 VW_ChiTietPhieuPhat
IF OBJECT_ID('dbo.VW_ChiTietPhieuPhat') IS NOT NULL DROP VIEW dbo.VW_ChiTietPhieuPhat;
GO
CREATE VIEW dbo.VW_ChiTietPhieuPhat
AS
SELECT 
    pp.MaPhieuPhat,
    pp.NgayLap,
    pp.TrangThai AS TrangThaiPhieuPhat,
    dg.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    tt.MaThuThu,
    tt.HoTen AS HoTenThuThu,
    ctp.MaChiTietPhat,
    ctp.LoaiPhat,
    ctp.SoTien,
    SUM(ctp.SoTien) OVER (PARTITION BY pp.MaPhieuPhat) AS TongTienPhieuPhat
FROM PhieuPhat pp
JOIN DocGia dg ON dg.MaDocGia = pp.MaDocGia
JOIN ThuThu tt ON tt.MaThuThu = pp.MaThuThu
LEFT JOIN ChiTietPhat ctp ON ctp.MaPhieuPhat = pp.MaPhieuPhat;
GO

-- 3.2 VW_TongCongNoDocGia (tổng hợp công nợ chưa thanh toán)
IF OBJECT_ID('dbo.VW_TongCongNoDocGia') IS NOT NULL DROP VIEW dbo.VW_TongCongNoDocGia;
GO
CREATE VIEW dbo.VW_TongCongNoDocGia
AS
SELECT 
    dg.MaDocGia,
    dg.HoTen AS HoTenDocGia,
    SUM(ctp.SoTien) AS TongNoChuaThanhToan
FROM DocGia dg
JOIN PhieuPhat pp ON pp.MaDocGia = dg.MaDocGia AND pp.TrangThai = N'ChuaThanhToan'
JOIN ChiTietPhat ctp ON ctp.MaPhieuPhat = pp.MaPhieuPhat
GROUP BY dg.MaDocGia, dg.HoTen;
GO


/*========================================================
= 4) VIEW THỐNG KÊ & BÁO CÁO
========================================================*/

-- 4.1 VW_DashboardTongQuan (1 dòng)
IF OBJECT_ID('dbo.VW_DashboardTongQuan') IS NOT NULL DROP VIEW dbo.VW_DashboardTongQuan;
GO
CREATE VIEW dbo.VW_DashboardTongQuan
AS
SELECT 
    (SELECT COUNT(*) FROM DauSach) AS TongDauSach,
    (SELECT COUNT(*) FROM DocGia) AS TongDocGia,
    (SELECT COUNT(*) FROM ChiTietMuon WHERE NgayTraThucTe IS NULL) AS SoSachDangMuon,
    (SELECT COUNT(*) FROM DatTruoc WHERE TrangThai = N'DangCho' AND NgayHetHan >= GETDATE()) AS SoDatTruocDangCho,
    (SELECT COUNT(*) FROM BanSao WHERE TinhTrang IN (N'Hong', N'Mat', N'BaoTri')) AS BanSaoCanBaoTri,
    (SELECT SUM(SoTien) 
        FROM ChiTietPhat c JOIN PhieuPhat p ON p.MaPhieuPhat = c.MaPhieuPhat 
        WHERE p.TrangThai = N'DaThanhToan') AS TongDoanhThuPhat_DenHienTai
;
GO

-- 4.2 VW_BaoCaoHoatDongThang (tháng hiện tại)
IF OBJECT_ID('dbo.VW_BaoCaoHoatDongThang') IS NOT NULL DROP VIEW dbo.VW_BaoCaoHoatDongThang;
GO
CREATE VIEW dbo.VW_BaoCaoHoatDongThang
AS
WITH R AS (
    SELECT 
        DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS StartOfMonth,
        EOMONTH(GETDATE()) AS EndOfMonth
)
SELECT
    (SELECT COUNT(*) FROM PhieuMuon pm, R 
     WHERE pm.NgayMuon >= R.StartOfMonth AND pm.NgayMuon < DATEADD(DAY,1,R.EndOfMonth)) AS LuotMuonMoi,
    (SELECT COUNT(*) FROM ChiTietMuon ctm, R 
     WHERE ctm.NgayTraThucTe IS NOT NULL 
       AND ctm.NgayTraThucTe >= R.StartOfMonth AND ctm.NgayTraThucTe < DATEADD(DAY,1,R.EndOfMonth)) AS SoSachDaTra,
    (SELECT COUNT(*) FROM PhieuPhat pp, R 
     WHERE pp.NgayLap >= R.StartOfMonth AND pp.NgayLap < DATEADD(DAY,1,R.EndOfMonth)) AS SoPhieuPhatPhatSinh,
    (SELECT SUM(ctp.SoTien) 
       FROM PhieuPhat pp 
       JOIN ChiTietPhat ctp ON ctp.MaPhieuPhat = pp.MaPhieuPhat, R
       WHERE pp.TrangThai = N'DaThanhToan'
         AND pp.NgayLap >= R.StartOfMonth AND pp.NgayLap < DATEADD(DAY,1,R.EndOfMonth)) AS DoanhThuPhat_Thang
;
GO

-- 4.3 VW_TopSachDuocMuonNhieu (Top 10)
IF OBJECT_ID('dbo.VW_TopSachDuocMuonNhieu') IS NOT NULL DROP VIEW dbo.VW_TopSachDuocMuonNhieu;
GO
CREATE VIEW dbo.VW_TopSachDuocMuonNhieu
AS
WITH C AS (
    SELECT ds.MaDauSach, ds.TenSach, COUNT(*) AS LuotMuon
    FROM ChiTietMuon ctm
    JOIN BanSao bs ON bs.MaBanSao = ctm.MaBanSao
    JOIN DauSach ds ON ds.MaDauSach = bs.MaDauSach
    GROUP BY ds.MaDauSach, ds.TenSach
),
R AS (
    SELECT *, DENSE_RANK() OVER (ORDER BY LuotMuon DESC, TenSach) AS rnk
    FROM C
)
SELECT MaDauSach, TenSach, LuotMuon, rnk
FROM R
WHERE rnk <= 10;
GO

-- 4.4 VW_DoanhThuPhatTheoThoiGian (mặc định theo ngày; kèm cột tháng/năm để tự nhóm)
IF OBJECT_ID('dbo.VW_DoanhThuPhatTheoThoiGian') IS NOT NULL DROP VIEW dbo.VW_DoanhThuPhatTheoThoiGian;
GO
CREATE VIEW dbo.VW_DoanhThuPhatTheoThoiGian
AS
SELECT 
    CAST(pp.NgayLap AS DATE) AS Ngay,
    MONTH(pp.NgayLap) AS Thang,
    YEAR(pp.NgayLap)  AS Nam,
    SUM(ctp.SoTien)   AS DoanhThuPhat
FROM PhieuPhat pp
JOIN ChiTietPhat ctp ON ctp.MaPhieuPhat = pp.MaPhieuPhat
WHERE pp.TrangThai = N'DaThanhToan'
GROUP BY CAST(pp.NgayLap AS DATE), MONTH(pp.NgayLap), YEAR(pp.NgayLap);
GO
