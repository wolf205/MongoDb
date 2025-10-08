USE QuanLyThuVien;
GO

/*========================================================
= 1. CÁC BẢNG CƠ BẢN
========================================================*/

-- 1.1 Tài khoản: tìm kiếm hoặc lọc theo tên đăng nhập, loại tài khoản, trạng thái
CREATE INDEX IX_TaiKhoan_TenDangNhap ON TaiKhoan (TenDangNhap);
CREATE INDEX IX_TaiKhoan_LoaiTrangThai ON TaiKhoan (LoaiTaiKhoan, TrangThai);

-- 1.2 Thủ thư: join theo MaTaiKhoan, lọc trạng thái
CREATE INDEX IX_ThuThu_MaTaiKhoan ON ThuThu (MaTaiKhoan);
CREATE INDEX IX_ThuThu_TrangThai ON ThuThu (TrangThai);

-- 1.3 Độc giả: join với tài khoản, tra cứu theo CCCD, lọc trạng thái
CREATE INDEX IX_DocGia_MaTaiKhoan ON DocGia (MaTaiKhoan);
CREATE INDEX IX_DocGia_CCCD ON DocGia (CCCD);
CREATE INDEX IX_DocGia_TrangThai ON DocGia (TrangThai);

-- 1.4 Thẻ: join theo MaDocGia, kiểm tra hiệu lực theo NgayHetHan, TrangThai
CREATE INDEX IX_The_MaDocGia ON The (MaDocGia);
CREATE INDEX IX_The_NgayHetHanTrangThai ON The (NgayHetHan, TrangThai);

-- 1.5 Đầu sách: tìm kiếm theo tên, ISBN, lọc trạng thái
CREATE INDEX IX_DauSach_TenSach ON DauSach (TenSach);
CREATE INDEX IX_DauSach_ISBN ON DauSach (ISBN);
CREATE INDEX IX_DauSach_TrangThai ON DauSach (TrangThai);

-- 1.6 Bản sao: join theo MaDauSach, thống kê theo TinhTrang, tra cứu theo ViTriKe
CREATE INDEX IX_BanSao_MaDauSach ON BanSao (MaDauSach);
CREATE INDEX IX_BanSao_TinhTrang ON BanSao (TinhTrang);
CREATE INDEX IX_BanSao_ViTriKeTinhTrang ON BanSao (TinhTrang, ViTriKe);

-- 1.7 Phiếu mượn: join theo MaDocGia, MaThuThu, lọc theo TrangThai, HanTra
CREATE INDEX IX_PhieuMuon_MaDocGia ON PhieuMuon (MaDocGia);
CREATE INDEX IX_PhieuMuon_MaThuThu ON PhieuMuon (MaThuThu);
CREATE INDEX IX_PhieuMuon_TrangThai ON PhieuMuon (TrangThai);
CREATE INDEX IX_PhieuMuon_HanTra ON PhieuMuon (HanTra);

-- 1.8 Chi tiết mượn: join theo MaPhieuMuon, MaBanSao, lọc theo NgayTraThucTe
CREATE INDEX IX_ChiTietMuon_MaPhieuMuon ON ChiTietMuon (MaPhieuMuon);
CREATE INDEX IX_ChiTietMuon_MaBanSao ON ChiTietMuon (MaBanSao);
CREATE INDEX IX_ChiTietMuon_NgayTraThucTe ON ChiTietMuon (NgayTraThucTe);

-- 1.9 Đặt trước: join theo MaDocGia, MaDauSach, lọc theo TrangThai, NgayHetHan
CREATE INDEX IX_DatTruoc_MaDocGia ON DatTruoc (MaDocGia);
CREATE INDEX IX_DatTruoc_MaDauSach ON DatTruoc (MaDauSach);
CREATE INDEX IX_DatTruoc_TrangThaiNgayHetHan ON DatTruoc (TrangThai, NgayHetHan);
CREATE INDEX IX_DatTruoc_NgayDat ON DatTruoc (NgayDat);

-- 1.10 Phiếu phạt: join theo MaDocGia, MaThuThu, lọc theo TrangThai, NgayLap
CREATE INDEX IX_PhieuPhat_MaDocGia ON PhieuPhat (MaDocGia);
CREATE INDEX IX_PhieuPhat_MaThuThu ON PhieuPhat (MaThuThu);
CREATE INDEX IX_PhieuPhat_TrangThaiNgayLap ON PhieuPhat (TrangThai, NgayLap);

-- 1.11 Chi tiết phạt: join theo MaPhieuPhat, MaChiTietMuon
CREATE INDEX IX_ChiTietPhat_MaPhieuPhat ON ChiTietPhat (MaPhieuPhat);
CREATE INDEX IX_ChiTietPhat_MaChiTietMuon ON ChiTietPhat (MaChiTietMuon);
CREATE INDEX IX_ChiTietPhat_LoaiPhat ON ChiTietPhat (LoaiPhat);

GO
