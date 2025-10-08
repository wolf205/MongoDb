/*========================================================
= 1) HÀM HỖ TRỢ (UDF)
========================================================*/

-- 1.1 Trạng thái thẻ "hữu hiệu": nếu hết hạn thì xem là 'HetHan' dù cột TrangThai đang 'HoatDong'
IF OBJECT_ID('dbo.fn_The_TrangThaiHieuLuc') IS NOT NULL DROP FUNCTION dbo.fn_The_TrangThaiHieuLuc;
GO
CREATE FUNCTION dbo.fn_The_TrangThaiHieuLuc (@MaDocGia INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @TrangThai NVARCHAR(20);
    SELECT TOP(1)
        @TrangThai = CASE 
                        WHEN NgayHetHan < CAST(GETDATE() AS DATE) THEN N'HetHan'
                        ELSE TrangThai
                     END
    FROM The
    WHERE MaDocGia = @MaDocGia;

    RETURN ISNULL(@TrangThai, N'KhongCoThe'); -- độc giả chưa có thẻ
END;
GO

-- 1.2 Số ngày quá hạn của 1 phiếu mượn (tính đến thời điểm trả nếu đã trả trễ, còn chưa trả thì tính đến hôm nay)
IF OBJECT_ID('dbo.fn_PhieuMuon_SoNgayQuaHan') IS NOT NULL DROP FUNCTION dbo.fn_PhieuMuon_SoNgayQuaHan;
GO
CREATE FUNCTION dbo.fn_PhieuMuon_SoNgayQuaHan (@MaPhieuMuon INT)
RETURNS INT
AS
BEGIN
    DECLARE @HanTra DATETIME, @MaxNgayTra DATETIME, @SoNgay INT;

    SELECT @HanTra = HanTra
    FROM PhieuMuon
    WHERE MaPhieuMuon = @MaPhieuMuon;

    -- Nếu có bất kỳ cuốn nào trả, lấy ngày trả trễ max; nếu chưa trả hoặc còn cuốn chưa trả thì tính đến hôm nay
    SELECT @MaxNgayTra = MAX(NgayTraThucTe)
    FROM ChiTietMuon
    WHERE MaPhieuMuon = @MaPhieuMuon;

    IF @MaxNgayTra IS NULL
        SET @SoNgay = DATEDIFF(DAY, @HanTra, GETDATE());
    ELSE
        SET @SoNgay = DATEDIFF(DAY, @HanTra, @MaxNgayTra);

    IF @SoNgay < 0 SET @SoNgay = 0;
    RETURN ISNULL(@SoNgay, 0);
END;
GO

-- 1.3 Tổng tiền 1 phiếu phạt
IF OBJECT_ID('dbo.fn_PhieuPhat_TongTien') IS NOT NULL DROP FUNCTION dbo.fn_PhieuPhat_TongTien;
GO
CREATE FUNCTION dbo.fn_PhieuPhat_TongTien (@MaPhieuPhat INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Tong DECIMAL(18,2);
    SELECT @Tong = SUM(SoTien) 
    FROM ChiTietPhat 
    WHERE MaPhieuPhat = @MaPhieuPhat;

    RETURN ISNULL(@Tong, 0);
END;
GO

-- 1.4 Công nợ (phạt chưa thanh toán) của 1 độc giả
IF OBJECT_ID('dbo.fn_DocGia_CongNo') IS NOT NULL DROP FUNCTION dbo.fn_DocGia_CongNo;
GO
CREATE FUNCTION dbo.fn_DocGia_CongNo (@MaDocGia INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @No DECIMAL(18,2);
    SELECT @No = SUM(ctp.SoTien)
    FROM PhieuPhat pp
    JOIN ChiTietPhat ctp ON ctp.MaPhieuPhat = pp.MaPhieuPhat
    WHERE pp.MaDocGia = @MaDocGia
      AND pp.TrangThai = N'ChuaThanhToan';

    RETURN ISNULL(@No, 0);
END;
GO

