USE QuanLyThuVien
GO

-----------------------------------------------------------------------
-- PHẦN I: TEST TRIGGERS BẢNG PHIEUMUON (trg_PhieuMuon_KiemTraDieuKien, trg_PhieuMuon_KiemTraQuaHan)
-----------------------------------------------------------------------

-- LƯU Ý DỮ LIỆU MẪU:
-- Độc giả 1 (MaDocGia=1):
--   - Thẻ: HoatDong, Hạn: 2026-01-10 (OK)
--   - Đang mượn: 3 cuốn (Phiếu 5, 8, 11) (OK, <5)
--   - Phiếu Quá Hạn: 2 phiếu (9, 15)
--   - Phiếu Phạt Chưa TT: 1 phiếu (MaPhieuPhat=5)

-- Độc giả 2 (MaDocGia=2):
--   - Thẻ: HoatDong, Hạn: 2026-02-15 (OK)
--   - Đang mượn: 2 cuốn (Phiếu 2, 6, 12) (OK, <5)
--   - Phiếu Quá Hạn: 0
--   - Phiếu Phạt Chưa TT: 1 phiếu (MaPhieuPhat=3)

-- Độc giả 6 (MaDocGia=6):
--   - Thẻ: HoatDong, Hạn: 2026-09-26 (OK)
--   - Đang mượn: 1 cuốn (Phiếu 20) (OK, <5)
--   - Phiếu Quá Hạn: 0
--   - Phiếu Phạt Chưa TT: 0 (Sẵn sàng mượn)
-----------------------------------------------------------------------

-- 1. TEST: trg_PhieuMuon_KiemTraDieuKien (VI PHẠM ĐIỀU KIỆN)

-- A. VI PHẠM: Độc giả còn Phiếu Phạt Chưa Thanh Toán (DocGia=1)
PRINT N'-- A. TEST: VI PHẠM PHIẾU PHẠT --'
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES
(1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), N'DangMuon');
GO
-- Kết quả: Lỗi RAISERROR 'Độc giả còn phiếu phạt chưa thanh toán!'

-- B. VI PHẠM: Độc giả có Phiếu Mượn Quá Hạn (DocGia=3)
PRINT N'-- B. TEST: VI PHẠM PHIẾU QUÁ HẠN --'
-- Cần cập nhật trạng thái phạt của DG3 để test riêng điều kiện Quá Hạn
UPDATE PhieuPhat SET TrangThai = N'DaThanhToan' WHERE MaDocGia = 3 AND TrangThai = N'ChuaThanhToan';
-- DG3 vẫn có phiếu 3 và 23 trạng thái 'QuaHan'.
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES
(3, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), N'DangMuon');
GO
-- Kết quả: Lỗi RAISERROR 'Độc giả có phiếu mượn quá hạn. Vui lòng trả sách trước!'

-- C. VI PHẠM: Thời gian mượn quá 30 ngày
PRINT N'-- C. TEST: VI PHẠM HẠN TRẢ > 30 NGÀY --'
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES
(6, 3, GETDATE(), DATEADD(DAY, 31, GETDATE()), N'DangMuon');
GO
-- Kết quả: Lỗi RAISERROR 'Thời gian mượn tối đa là 30 ngày!'

-- 2. TEST: trg_PhieuMuon_KiemTraDieuKien (KHÔNG VI PHẠM)
PRINT N'-- 2. TEST: KHÔNG VI PHẠM (Dựa trên DocGia 6) --'
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES
(6, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), N'DangMuon');
GO
-- Kết quả: INSERT thành công. Lấy MaPhieuMuon mới (giả sử là 27)

-- 3. TEST: trg_PhieuMuon_KiemTraQuaHan (AFTER INSERT/UPDATE)
-- Giả sử đã INSERT phiếu mới với MaPhieuMuon = 27 (DocGia=6)
PRINT N'-- 3. TEST: CẬP NHẬT QUA HẠN (SỬ DỤNG UPDATE) --'
DECLARE @MaPhieuMuonMoi INT;
SELECT @MaPhieuMuonMoi = MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 6; -- Lấy MaPhieuMuon=27

-- Cập nhật HanTra về ngày trong quá khứ
UPDATE PhieuMuon
SET HanTra = DATEADD(DAY, -1, GETDATE())
WHERE MaPhieuMuon = @MaPhieuMuonMoi;
GO
-- Kết quả: Sau khi UPDATE, trigger trg_PhieuMuon_KiemTraQuaHan sẽ được kích hoạt, cập nhật TrangThai = 'QuaHan'
SELECT MaPhieuMuon, HanTra, TrangThai FROM PhieuMuon WHERE MaDocGia = 6 AND MaPhieuMuon = (SELECT MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 6);
GO

-- 4. TEST: trg_PhieuMuon_NgamCapNhat (INSTEAD OF UPDATE)
PRINT N'-- 4. TEST: VI PHẠM NGAMCAPNHAT --'
-- Phiếu đã hoàn thành (MaPhieuMuon=1: DaTra)
UPDATE PhieuMuon
SET MaDocGia = 999 -- Cố gắng sửa MaDocGia (vi phạm)
WHERE MaPhieuMuon = 1;
GO
-- Kết quả: Lỗi RAISERROR 'Không thể sửa thông tin phiếu mượn đã hoàn thành!'

-- 5. TEST: trg_PhieuMuon_NgamXoa (INSTEAD OF DELETE)
PRINT N'-- 5. TEST: NGAMXOA (Chuyển sang BiHuy) --'
DECLARE @MaPhieuMuonCanHuy INT;
SELECT @MaPhieuMuonCanHuy = MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 6; -- Lấy MaPhieuMuon=27
DELETE FROM PhieuMuon WHERE MaPhieuMuon = @MaPhieuMuonCanHuy;
GO
-- Kết quả: DELETE bị chặn, thay thế bằng UPDATE TrangThai='BiHuy'
SELECT MaPhieuMuon, TrangThai FROM PhieuMuon WHERE MaPhieuMuon = (SELECT MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 6);
GO

-----------------------------------------------------------------------
-- PHẦN II: TEST TRIGGERS BẢNG CHITIETMUON (Thêm và Trả sách)
-----------------------------------------------------------------------

-- LƯU Ý DỮ LIỆU MẪU:
-- Bản sao 1 (MaBanSao=1): Đang mượn (Phiếu 14)
-- Bản sao 3 (MaBanSao=3): CoSan
-- Phiếu 26: Phiếu Mượn đã tạo thành công ở trên (DG5, ThuThu3).

-- 6. TEST: trg_ChiTietMuon_KiemTraBanSao (INSTEAD OF INSERT) & trg_ChiTietMuon_CapNhatTinhTrangBanSao (AFTER INSERT)

-- A. VI PHẠM: Bản sao đang mượn (Kiểm tra 2)
PRINT N'-- 6A. TEST: VI PHẠM BẢN SAO ĐANG MƯỢN --'
INSERT INTO ChiTietMuon (MaPhieuMuon, MaBanSao, TinhTrangTra, NgayTraThucTe) VALUES
(5, 1, NULL, NULL);
GO
-- Kết quả: Lỗi RAISERROR 'Bản sao #1 đang ở trạng thái: DangMuon. Không thể mượn!'

-- B. KHÔNG VI PHẠM: Mượn thành công (MaPhieuMuon=26, MaBanSao=3)
PRINT N'-- 6B. TEST: INSERT THÀNH CÔNG --'
DECLARE @MaPhieuMuonMoi2 INT;
SELECT @MaPhieuMuonMoi2 = MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 6; -- MaPhieuMuon=27 (Đã hủy)
SELECT @MaPhieuMuonMoi2 = MAX(MaPhieuMuon) FROM PhieuMuon WHERE MaDocGia = 5; -- Lấy MaPhieuMuon=19
-- Cần tạo 1 phiếu mới cho DG5 (MaDocGia=5) để đảm bảo không vi phạm giới hạn 5 cuốn (DG5 đang mượn 1 cuốn BS=21)
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES (5, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), N'DangMuon');
SELECT @MaPhieuMuonMoi2 = SCOPE_IDENTITY(); -- Giả sử là MaPhieuMuon=28

INSERT INTO ChiTietMuon (MaPhieuMuon, MaBanSao, TinhTrangTra, NgayTraThucTe) VALUES
(@MaPhieuMuonMoi2, 3, NULL, NULL); -- Bản sao 3 đang CoSan
GO
-- Kết quả: INSERT thành công.
-- Kiểm tra trg_ChiTietMuon_CapNhatTinhTrangBanSao đã chạy:
SELECT MaBanSao, TinhTrang FROM BanSao WHERE MaBanSao = 3;
GO
-- Kết quả mong đợi: TinhTrang = 'DangMuon'

-- 7. TEST: trg_ChiTietMuon_KiemTraTinhTrangTra (INSTEAD OF UPDATE) & trg_ChiTietMuon_TraSach (AFTER UPDATE) & trg_ChiTietMuon_CapNhatTrangThaiPhieuMuon (AFTER UPDATE) & trg_ChiTietMuon_TaoPhat (AFTER UPDATE)

-- MaChiTietMuon của bản sao 3 vừa mượn.
DECLARE @MaChiTietMuonMoi INT, @HanTraCu DATETIME;
SELECT @MaChiTietMuonMoi = MAX(MaChiTietMuon) FROM ChiTietMuon WHERE MaBanSao = 3;
SELECT @HanTraCu = HanTra FROM PhieuMuon WHERE MaPhieuMuon = (SELECT MaPhieuMuon FROM ChiTietMuon WHERE MaChiTietMuon = @MaChiTietMuonMoi);

-- A. VI PHẠM: Cập nhật TinhTrangTra mà chưa có NgayTraThucTe
PRINT N'-- 7A. TEST: VI PHẠM TRANG THÁI TRẢ --'
UPDATE ChiTietMuon
SET TinhTrangTra = N'Tot'
WHERE MaChiTietMuon = @MaChiTietMuonMoi;
GO
-- Kết quả: Lỗi RAISERROR 'Phải có ngày trả thực tế trước khi đánh giá tình trạng!'

-- B. KHÔNG VI PHẠM: Trả sách TỐT (Không phạt, không quá hạn)
PRINT N'-- 7B. TEST: TRẢ SÁCH TỐT --'
UPDATE ChiTietMuon
SET NgayTraThucTe = DATEADD(DAY, -1, @HanTraCu), -- Trả trước hạn 1 ngày
    TinhTrangTra = N'Tot'
WHERE MaChiTietMuon = @MaChiTietMuonMoi;
GO
-- Kiểm tra: BanSao 3 TinhTrang='CoSan', ChiTietMuon.NgayTraThucTe IS NOT NULL, KHÔNG CÓ PHIẾU PHẠT MỚI.
SELECT MaBanSao, TinhTrang FROM BanSao WHERE MaBanSao = 3;
SELECT * FROM PhieuPhat pp WHERE pp.MaDocGia = 5 AND CAST(pp.NgayLap AS DATE) = CAST(GETDATE() AS DATE);
GO

-- C. KHÔNG VI PHẠM: Trả sách HỎNG (Có phạt hỏng)
PRINT N'-- 7C. TEST: TRẢ SÁCH HỎNG --'
-- Cần mượn thêm 1 cuốn nữa (MaBanSao=9, CoSan). DG5 đang mượn 1 cuốn (BS=21). DG5 đang có 1 phiếu 'DangMuon' PM=19.
-- Tạo Phiếu Mượn mới (MaPhieuMuon=29)
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES (5, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), N'DangMuon');
DECLARE @MaPhieuMuonMoi3 INT, @MaChiTietMuonMoi2 INT;
SELECT @MaPhieuMuonMoi3 = SCOPE_IDENTITY();
INSERT INTO ChiTietMuon (MaPhieuMuon, MaBanSao, TinhTrangTra, NgayTraThucTe) VALUES (@MaPhieuMuonMoi3, 9, NULL, NULL);
SELECT @MaChiTietMuonMoi2 = SCOPE_IDENTITY(); -- MaChiTietMuon của bản sao 9

UPDATE ChiTietMuon
SET NgayTraThucTe = DATEADD(DAY, 1, @HanTraCu), -- Trả trễ 1 ngày (Có phạt trễ)
    TinhTrangTra = N'Hong' -- Có phạt hỏng
WHERE MaChiTietMuon = @MaChiTietMuonMoi2;
GO
-- Kiểm tra: BanSao 9 TinhTrang='Hong', Có PHIẾU PHẠT MỚI (TraTre: 5000, Hong: 50000).
SELECT MaBanSao, TinhTrang FROM BanSao WHERE MaBanSao = 9;
SELECT * FROM PhieuPhat pp 
INNER JOIN ChiTietPhat ctp ON pp.MaPhieuPhat = ctp.MaPhieuPhat
WHERE pp.MaDocGia = 5 AND ctp.MaChiTietMuon = @MaChiTietMuonMoi2;
GO
-- Kết quả mong đợi: 2 dòng ChiTietPhat (LoaiPhat='TraTre' SoTien=5000, LoaiPhat='Hong' SoTien=50000).

-- 8. TEST: trg_ChiTietMuon_NgamXoa (INSTEAD OF DELETE)
PRINT N'-- 8. TEST: NGAMXOA --'
-- A. VI PHẠM: Xóa chi tiết đã trả (MaChiTietMuon của bản sao 3)
DECLARE @MaChiTietMuonDaTra INT;
SELECT @MaChiTietMuonDaTra = MAX(MaChiTietMuon) FROM ChiTietMuon WHERE MaBanSao = 3;
DELETE FROM ChiTietMuon WHERE MaChiTietMuon = @MaChiTietMuonDaTra;
GO
-- Kết quả: Lỗi RAISERROR 'Không thể xóa chi tiết mượn đã trả sách!'

-- B. KHÔNG VI PHẠM: Xóa chi tiết chưa trả (MaChiTietMuon của bản sao 21, Phiếu 19)
DELETE FROM ChiTietMuon WHERE MaPhieuMuon = 19;
GO
-- Kết quả: DELETE thành công, sau đó MaBanSao 21 sẽ phải được UPDATE lại thành 'CoSan' (Đây là LỖI THIẾT KẾ TRIGGER, vì không có trigger nào cập nhật lại trạng thái sách khi chi tiết mượn bị xóa).
SELECT MaBanSao, TinhTrang FROM BanSao WHERE MaBanSao = 21;
GO
-- TinhTrang vẫn là 'DangMuon' (LỖI). Lệnh DELETE vẫn chạy.

-----------------------------------------------------------------------
-- PHẦN III: TEST TRIGGERS BẢNG DATTRUOC
-----------------------------------------------------------------------

-- LƯU Ý DỮ LIỆU MẪU:
-- DocGia 3 (MaDocGia=3) đã đặt sách 4 (MaDauSach=4) với TrangThai='DangCho' (MaDatTruoc=3).
-- DocGia 3 đã đặt sách 1 (MaDauSach=1) với TrangThai='DangCho' (MaDatTruoc=7).

-- 9. TEST: trg_DatTruoc_KiemTraSoLuong (INSTEAD OF INSERT)

-- A. VI PHẠM: Đặt lại sách đã đặt và đang 'DangCho' (DG3, DauSach 4)
PRINT N'-- 9A. TEST: VI PHẠM ĐẶT TRÙNG SÁCH ĐANG CHỜ --'
INSERT INTO DatTruoc (MaDocGia, MaDauSach, NgayDat, NgayHetHan, TrangThai) VALUES
(3, 4, GETDATE(), DATEADD(DAY, 7, GETDATE()), N'DangCho');
GO
-- Kết quả: Lỗi RAISERROR 'Độc giả đã đặt trước đầu sách này rồi!'

-- B. KHÔNG VI PHẠM: Đặt sách mới (DG3, DauSach 2)
PRINT N'-- 9B. TEST: INSERT DAT TRUOC THÀNH CÔNG --'
INSERT INTO DatTruoc (MaDocGia, MaDauSach, NgayDat, NgayHetHan, TrangThai) VALUES
(3, 2, GETDATE(), DATEADD(DAY, 7, GETDATE()), N'DangCho');
GO
-- Kết quả: INSERT thành công. (MaDatTruoc mới)

-- 10. TEST: trg_DatTruoc_KiemTraHetHan (AFTER INSERT/UPDATE)
PRINT N'-- 10. TEST: CẬP NHẬT HẾT HẠN (SỬ DỤNG UPDATE) --'
-- Lấy MaDatTruoc của Phiếu đang 'DangCho' và chưa 'HetHan' (MaDatTruoc=7: DG3, DauSach 1)
UPDATE DatTruoc
SET NgayHetHan = DATEADD(DAY, -1, GETDATE()) -- Sửa Hạn về ngày hôm qua
WHERE MaDatTruoc = 7;
GO
-- Kết quả: Trigger trg_DatTruoc_KiemTraHetHan sẽ chạy và cập nhật TrangThai = 'HetHan'.
SELECT MaDatTruoc, NgayHetHan, TrangThai FROM DatTruoc WHERE MaDatTruoc = 7;
GO
-- Kết quả mong đợi: TrangThai = 'HetHan'

-----------------------------------------------------------------------
-- PHẦN IV: TEST TRIGGERS BẢNG THE
-----------------------------------------------------------------------

-- LƯU Ý DỮ LIỆU MẪU:
-- DocGia 1 (MaDocGia=1) đã có thẻ (MaThe=1) với TrangThai='HoatDong'.
-- DocGia 7 (MaDocGia=7) không tồn tại.

-- 11. TEST: trg_The_KiemTraDuyNhat (INSTEAD OF INSERT)

-- A. VI PHẠM: Độc giả đã có thẻ 'HoatDong' (DocGia=1)
PRINT N'-- 11A. TEST: VI PHẠM ĐÃ CÓ THẺ --'
INSERT INTO The (MaDocGia, NgayCap, NgayHetHan, TrangThai) VALUES
(1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), N'HoatDong');
GO
-- Kết quả: Lỗi RAISERROR 'Độc giả đã có thẻ thư viện!'

-- B. KHÔNG VI PHẠM: Độc giả mới (DocGia=7)
PRINT N'-- 11B. TEST: INSERT THẺ MỚI THÀNH CÔNG --'
-- Cần phải tạo độc giả 7 trước
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan, TrangThai) VALUES (N'docgia7', N'pass123', N'DocGia', N'HoatDong');
DECLARE @MaTaiKhoanMoi INT = SCOPE_IDENTITY();
INSERT INTO DocGia (MaTaiKhoan, HoTen, CCCD, TrangThai, MongoProfileId) VALUES (@MaTaiKhoanMoi, N'Phạm Văn Q', N'777888999000', N'HoatDong', N'P_DG_007');
DECLARE @MaDocGiaMoi INT = SCOPE_IDENTITY(); -- MaDocGia=7

INSERT INTO The (MaDocGia, NgayCap, NgayHetHan, TrangThai) VALUES
(@MaDocGiaMoi, GETDATE(), DATEADD(YEAR, 1, GETDATE()), N'HoatDong');
GO
-- Kết quả: INSERT thành công.
SELECT MaDocGia, NgayHetHan, TrangThai FROM The WHERE MaDocGia = (SELECT MAX(MaDocGia) FROM DocGia);
GO