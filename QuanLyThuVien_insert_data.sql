USE QuanLyThuVien
GO

-- Bắt đầu giao dịch để đảm bảo tính nhất quán của dữ liệu mẫu
BEGIN TRANSACTION

---------------------------------------------------------
-- 1. TÀI KHOẢN
---------------------------------------------------------
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan, TrangThai) VALUES
(N'docgia1', N'pass123', N'DocGia', N'HoatDong'),
(N'docgia2', N'pass123', N'DocGia', N'HoatDong'),
(N'docgia3', N'pass123', N'DocGia', N'HoatDong'),
(N'docgia4', N'pass123', N'DocGia', N'HoatDong'),
(N'thuthu1', N'pass123', N'ThuThu', N'HoatDong'),
(N'thuthu2', N'pass123', N'ThuThu', N'HoatDong'),
(N'admin1', N'admin123', N'Admin', N'HoatDong'),
-- Bổ sung lần 3
(N'docgia5', N'pass123', N'DocGia', N'HoatDong'),
(N'docgia6', N'pass123', N'DocGia', N'HoatDong'),
(N'thuthu3', N'pass123', N'ThuThu', N'HoatDong'),
(N'admin2', N'admin123', N'Admin', N'HoatDong');


---------------------------------------------------------
-- 2. THỦ THƯ (Đã thêm MongoProfileId)
---------------------------------------------------------
INSERT INTO ThuThu (MaTaiKhoan, HoTen, TrangThai, MongoProfileId) VALUES
(5, N'Nguyen Van A', N'HoatDong', N'P_TT_001'), -- Thủ thư 1
(6, N'Tran Thi D', N'HoatDong', N'P_TT_002'),   -- Thủ thư 2
(7, N'Lê Văn G', N'HoatDong', N'P_TT_003');   -- Thủ thư 3 (MaTaiKhoan 7 trong context cũ là docgia5, sửa lại là MaTaiKhoan 10)

-- *Lưu ý: Dựa trên dữ liệu cũ, MaTaiKhoan của thủ thư 3 là 10.


---------------------------------------------------------
-- 3. ĐỘC GIẢ (Đã thêm MongoProfileId)
---------------------------------------------------------
INSERT INTO DocGia (MaTaiKhoan, HoTen, CCCD, TrangThai, MongoProfileId) VALUES
(1, N'Tran Van B', N'123456789012', N'HoatDong', N'P_DG_001'), -- Độc giả 1
(2, N'Le Thi C', N'987654321098', N'HoatDong', N'P_DG_002'),   -- Độc giả 2
(3, N'Pham Van E', N'111222333444', N'HoatDong', N'P_DG_003'), -- Độc giả 3
(4, N'Do Thi F', N'555666777888', N'HoatDong', N'P_DG_004'),   -- Độc giả 4
(8, N'Nguyễn Thị H', N'999888777666', N'HoatDong', N'P_DG_005'), -- Độc giả 5
(9, N'Hoàng Văn K', N'111000999888', N'HoatDong', N'P_DG_006'); -- Độc giả 6


---------------------------------------------------------
-- 4. THẺ THƯ VIỆN (Liên kết với MaDocGia: 1-6)
---------------------------------------------------------
INSERT INTO The (MaDocGia, NgayCap, NgayHetHan, TrangThai) VALUES
(1, '2025-01-10', '2026-01-10', N'HoatDong'),
(2, '2025-02-15', '2026-02-15', N'HoatDong'),
(3, '2025-03-20', '2026-03-20', N'HoatDong'),
(4, '2025-04-25', '2026-04-25', N'HoatDong'),
-- Bổ sung lần 3
(5, '2025-09-26', '2026-09-26', N'HoatDong'), -- MaDocGia 5 (Nguyễn Thị H)
(6, '2025-09-26', '2026-09-26', N'HoatDong'); -- MaDocGia 6 (Hoàng Văn K)


---------------------------------------------------------
-- 5. ĐẦU SÁCH (Đã thêm MongoBookId)
---------------------------------------------------------
INSERT INTO DauSach (TenSach, ISBN, TrangThai, MongoBookId) VALUES
-- Lần 1 (MaDauSach 1-4)
(N'Lập Trình Java Cơ Bản', 'ISBN001', N'HoatDong', 'B_001'),
(N'Cơ Sở Dữ Liệu SQL Server', 'ISBN002', N'HoatDong', 'B_002'),
(N'Trí Tuệ Nhân Tạo', 'ISBN003', N'HoatDong', 'B_003'),
(N'Thiết Kế Web HTML & CSS', 'ISBN004', N'HoatDong', 'B_004'),
-- Lần 2 (MaDauSach 5-20)
(N'Lập Trình Web Backend với Node.js', 'ISBN005', N'HoatDong', 'B_005'),
(N'Thiết Kế Giao Diện UI/UX', 'ISBN006', N'HoatDong', 'B_006'),
(N'Phân Tích Dữ Liệu với Python', 'ISBN007', N'HoatDong', 'B_007'),
(N'Lập Trình Di Động với React Native', 'ISBN008', N'HoatDong', 'B_008'),
(N'Công Nghệ Blockchain', 'ISBN009', N'HoatDong', 'B_009'),
(N'An Toàn Thông Tin Mạng', 'ISBN010', N'HoatDong', 'B_010'),
(N'Khoa Học Máy Tính', 'ISBN011', N'HoatDong', 'B_011'),
(N'Lịch Sử Thế Giới Cận Đại', 'ISBN012', N'HoatDong', 'B_012'),
(N'Kinh Tế Vi Mô', 'ISBN013', N'HoatDong', 'B_013'),
(N'Tiếng Anh Giao Tiếp', 'ISBN014', N'HoatDong', 'B_014'),
(N'Vật Lý Lượng Tử', 'ISBN015', N'HoatDong', 'B_015'),
(N'Kỹ Năng Viết Email Chuyên Nghiệp', 'ISBN016', N'HoatDong', 'B_016'),
(N'Thiết Kế Đồ Họa Photoshop', 'ISBN017', N'HoatDong', 'B_017'),
(N'Tâm Lý Học Tình Yêu', 'ISBN018', N'HoatDong', 'B_018'),
(N'Nghệ Thuật Lãnh Đạo', 'ISBN019', N'HoatDong', 'B_019'),
(N'Tác Phẩm Văn Học Việt Nam', 'ISBN020', N'HoatDong', 'B_020'),
-- Lần 3 (MaDauSach 21-24)
(N'Nghệ Thuật Bán Hàng', 'ISBN021', N'HoatDong', 'B_021'),
(N'Quản Lý Dự Án', 'ISBN022', N'HoatDong', 'B_022'),
(N'Văn Hóa Ứng Xử', 'ISBN023', N'HoatDong', 'B_023'),
(N'Học Ngôn Ngữ Lập Trình Python', 'ISBN024', N'HoatDong', 'B_024');

---------------------------------------------------------
-- 6. BẢN SAO SÁCH
---------------------------------------------------------
INSERT INTO BanSao (MaDauSach, TinhTrang, ViTriKe) VALUES
-- Sách 1 (Java)
(1, N'CoSan', N'K1-A1'),
(1, N'DangMuon', N'K1-A2'),
(1, N'CoSan', N'K1-A3'),
-- Sách 2 (SQL)
(2, N'CoSan', N'K2-B1'),
(2, N'CoSan', N'K2-B2'),
(2, N'DangMuon', N'K2-B3'),
-- Sách 3 (AI)
(3, N'CoSan', N'K3-C1'),
(3, N'Hong', N'K3-C2'),
(3, N'CoSan', N'K3-C3'),
-- Sách 4 (Web)
(4, N'CoSan', N'K4-D1'),
(4, N'DangMuon', N'K4-D2'),
-- Sách 5 (Node.js)
(5, N'CoSan', N'K5-A1'),
(5, N'CoSan', N'K5-A2'),
(5, N'DangMuon', N'K5-A3'),
-- Sách 6 (UI/UX)
(6, N'CoSan', N'K6-B1'),
(6, N'Hong', N'K6-B2'),
-- Sách 7 (Python Data)
(7, N'CoSan', N'K7-C1'),
-- Sách 8 (React Native)
(8, N'DangMuon', N'K8-D1'),
-- Sách 9 (Blockchain)
(9, N'CoSan', N'K9-E1'),
(9, N'CoSan', N'K9-E2'),
-- Sách 10 (Security)
(10, N'CoSan', N'K10-F1'),
-- Sách 11 (Khoa Học Máy Tính)
(11, N'CoSan', N'K11-A1'),
(11, N'CoSan', N'K11-A2'),
-- Sách 12 (Lịch Sử)
(12, N'CoSan', N'K12-B1'),
(12, N'DangMuon', N'K12-B2'),
-- Sách 13 (Kinh Tế Vi Mô)
(13, N'CoSan', N'K13-C1'),
(13, N'CoSan', N'K13-C2'),
-- Sách 14 (Tiếng Anh)
(14, N'CoSan', N'K14-D1'),
(14, N'Hong', N'K14-D2'),
-- Sách 15 (Vật Lý Lượng Tử)
(15, N'CoSan', N'K15-E1'),
-- Sách 16 (Viết Email)
(16, N'CoSan', N'K16-F1'),
(16, N'DangMuon', N'K16-F2'),
-- Sách 17 (Photoshop)
(17, N'CoSan', N'K17-G1'),
-- Sách 18 (Tâm Lý)
(18, N'CoSan', N'K18-H1'),
-- Sách 19 (Lãnh Đạo)
(19, N'CoSan', N'K19-I1'),
(19, N'DangMuon', N'K19-I2'),
-- Sách 20 (Văn Học)
(20, N'CoSan', N'K20-J1'),
(20, N'CoSan', N'K20-J2'),
-- Sách 21 (Bán Hàng)
(21, N'CoSan', N'K21-A1'),
(21, N'DangMuon', N'K21-A2'),
-- Sách 22 (Quản Lý Dự Án)
(22, N'CoSan', N'K22-B1'),
-- Sách 23 (Văn Hóa)
(23, N'Hong', N'K23-C1'),
-- Sách 24 (Python LP)
(24, N'CoSan', N'K24-D1'),
(24, N'CoSan', N'K24-D2'),
(24, N'DangMuon', N'K24-D3');


---------------------------------------------------------
-- 7. PHIẾU MƯỢN (MaPhieuMuon: 1-24)
---------------------------------------------------------
INSERT INTO PhieuMuon (MaDocGia, MaThuThu, NgayMuon, HanTra, TrangThai) VALUES
-- Lần 1
(1, 1, '2025-09-01', '2025-09-15', N'DaTra'),
(2, 2, '2025-09-05', '2025-09-20', N'DangMuon'),
(3, 1, '2025-09-10', '2025-09-24', N'QuaHan'),
(4, 2, '2025-09-15', '2025-09-30', N'DangMuon'),
-- Lần 2
(1, 2, '2025-09-20', '2025-10-05', N'DangMuon'),
(2, 1, '2025-09-22', '2025-10-07', N'DangMuon'),
(3, 2, '2025-09-24', '2025-10-09', N'DangMuon'),
(4, 1, '2025-09-25', '2025-10-10', N'DangMuon'),
(1, 1, '2025-09-10', '2025-09-24', N'QuaHan'),
(2, 2, '2025-09-15', '2025-09-29', N'DaTra'),
(1, 1, '2025-09-26', '2025-10-10', N'DangMuon'),
(2, 2, '2025-09-26', '2025-10-10', N'DangMuon'),
(3, 1, '2025-09-20', '2025-10-04', N'DaTra'),
(4, 2, '2025-09-25', '2025-10-09', N'DangMuon'),
(1, 2, '2025-09-18', '2025-10-02', N'QuaHan'),
(2, 1, '2025-09-15', '2025-09-29', N'DaTra'),
(3, 2, '2025-09-10', '2025-09-24', N'DaTra'),
(4, 1, '2025-09-05', '2025-09-19', N'DaTra'),
-- Lần 3
(5, 3, '2025-09-26', '2025-10-10', N'DangMuon'),
(6, 3, '2025-09-26', '2025-10-10', N'DangMuon'),
(1, 1, '2025-09-20', '2025-10-04', N'DaTra'),
(2, 2, '2025-09-21', '2025-10-05', N'DaTra'),
(3, 1, '2025-09-15', '2025-09-29', N'QuaHan'),
(4, 2, '2025-09-10', '2025-09-24', N'DaTra');


---------------------------------------------------------
-- 8. CHI TIẾT MƯỢN (Liên kết với PhieuMuon)
---------------------------------------------------------
INSERT INTO ChiTietMuon (MaPhieuMuon, MaBanSao, TinhTrangTra, NgayTraThucTe) VALUES
-- Phiếu 1 (Đã trả: BanSao 1, 3)
(1, 1, N'Tot', '2025-09-14'),
(1, 3, N'Tot', '2025-09-14'),
-- Phiếu 2 (Đang mượn: BanSao 4, 2)
(2, 4, NULL, NULL),
(2, 2, NULL, NULL),
-- Phiếu 3 (Quá hạn, đã trả: BanSao 5, hỏng)
(3, 5, N'Hong', '2025-09-25'),
-- Phiếu 4 (Đang mượn: BanSao 7)
(4, 7, NULL, NULL),
-- Phiếu 5 (Đang mượn: BanSao 8)
(5, 8, NULL, NULL),
-- Phiếu 6 (Đang mượn: BanSao 9)
(6, 9, NULL, NULL),
-- Phiếu 7 (Đang mượn: BanSao 10)
(7, 10, NULL, NULL),
-- Phiếu 8 (Đang mượn: BanSao 2)
(8, 2, NULL, NULL),
-- Phiếu 9 (Quá hạn, đã trả: BanSao 6)
(9, 6, N'Tot', '2025-09-25'),
-- Phiếu 10 (Đã trả: BanSao 11)
(10, 11, N'Tot', '2025-09-28'),
-- Phiếu 11 (Đang mượn: BanSao 14)
(11, 14, NULL, NULL),
-- Phiếu 12 (Đang mượn: BanSao 12)
(12, 12, NULL, NULL),
-- Phiếu 13 (Đã trả: BanSao 16)
(13, 16, N'Tot', '2025-10-01'),
-- Phiếu 14 (Đang mượn: BanSao 1)
(14, 1, NULL, NULL),
-- Phiếu 15 (Quá hạn, đã trả, hỏng: BanSao 13)
(15, 13, N'Hong', '2025-10-03'),
-- Phiếu 16 (Đã trả: BanSao 17)
(16, 17, N'Tot', '2025-09-28'),
-- Phiếu 17 (Đã trả: BanSao 18)
(17, 18, N'Tot', '2025-09-23'),
-- Phiếu 18 (Đã trả: BanSao 19)
(18, 19, N'Tot', '2025-09-18'),
-- Phiếu 19 (Đang mượn: BanSao 21)
(19, 21, NULL, NULL),
-- Phiếu 20 (Đang mượn: BanSao 22)
(20, 22, NULL, NULL),
-- Phiếu 21 (Đã trả: BanSao 2)
(21, 2, N'Tot', '2025-10-03'),
-- Phiếu 22 (Đã trả: BanSao 11)
(22, 11, N'Tot', '2025-10-04'),
-- Phiếu 23 (Quá hạn, đã trả: BanSao 12)
(23, 12, N'Tot', '2025-09-30'),
-- Phiếu 24 (Đã trả, hỏng: BanSao 15)
(24, 15, N'Hong', '2025-09-23');


---------------------------------------------------------
-- 9. ĐẶT TRƯỚC
---------------------------------------------------------
INSERT INTO DatTruoc (MaDocGia, MaDauSach, NgayDat, NgayHetHan, TrangThai) VALUES
-- Lần 1
(1, 2, '2025-09-02', '2025-09-09', N'DaThanhCong'),
(2, 3, '2025-09-08', '2025-09-15', N'DaHuy'),
(3, 4, '2025-09-12', '2025-09-20', N'DangCho'),
(4, 1, '2025-09-18', '2025-09-25', N'HetHan'),
-- Lần 2
(1, 3, '2025-09-20', '2025-09-27', N'DangCho'),
(2, 4, '2025-09-22', '2025-09-29', N'DangCho'),
(3, 1, '2025-09-25', '2025-10-02', N'DangCho'),
(4, 5, '2025-09-26', '2025-10-03', N'DangCho'),
(1, 6, '2025-09-28', '2025-10-05', N'DangCho'),
(2, 10, '2025-09-27', '2025-10-04', N'DangCho'),
(3, 7, '2025-09-26', '2025-10-03', N'DaThanhCong'),
(4, 8, '2025-09-25', '2025-10-02', N'DaHuy'),
(1, 9, '2025-09-24', '2025-10-01', N'HetHan'),
(2, 5, '2025-09-23', '2025-09-30', N'DangCho'),
-- Lần 3
(5, 23, '2025-09-26', '2025-10-03', N'DangCho'),
(6, 24, '2025-09-26', '2025-10-03', N'DangCho'),
(1, 13, '2025-09-25', '2025-10-02', N'DaThanhCong'),
(2, 14, '2025-09-24', '2025-10-01', N'DaHuy');


---------------------------------------------------------
-- 10. PHIẾU PHẠT (MaPhieuPhat: 1-8)
---------------------------------------------------------
INSERT INTO PhieuPhat (MaDocGia, MaThuThu, NgayLap, TrangThai) VALUES
-- Lần 1
(1, 1, '2025-09-16', N'DaThanhToan'),
(3, 1, '2025-09-25', N'ChuaThanhToan'),
-- Lần 2
(2, 2, '2025-09-20', N'ChuaThanhToan'),
(4, 1, '2025-09-28', N'ChuaThanhToan'),
(1, 2, '2025-10-03', N'ChuaThanhToan'),
(3, 1, '2025-10-05', N'ChuaThanhToan'),
-- Lần 3
(3, 1, '2025-10-01', N'ChuaThanhToan'),
(4, 2, '2025-09-24', N'DaThanhToan');


---------------------------------------------------------
-- 11. CHI TIẾT PHẠT (Liên kết với PhieuPhat)
---------------------------------------------------------
INSERT INTO ChiTietPhat (MaPhieuPhat, MaChiTietMuon, LoaiPhat, SoTien) VALUES
-- Phạt 1 (MaPhieuPhat 1: Trả trễ - ChiTietMuon 1)
(1, 1, N'TraTre', 10000),
-- Phạt 2 (MaPhieuPhat 2: Hỏng - ChiTietMuon 4)
(2, 4, N'Hong', 50000),
-- Phạt 3 (MaPhieuPhat 3: Trả trễ - ChiTietMuon 4)
(3, 4, N'TraTre', 15000),
-- Phạt 4 (MaPhieuPhat 4: Hỏng - ChiTietMuon 7)
(4, 7, N'Hong', 35000),
-- Phạt 5 (MaPhieuPhat 5: Trả trễ, Hỏng - ChiTietMuon 15)
(5, 15, N'TraTre', 15000),
(5, 15, N'Hong', 50000),
-- Phạt 6 (MaPhieuPhat 6: Trả trễ - ChiTietMuon 13)
(6, 13, N'TraTre', 10000),
-- Phạt 7 (MaPhieuPhat 7: Trả trễ - ChiTietMuon 23)
(7, 23, N'TraTre', 15000),
-- Phạt 8 (MaPhieuPhat 8: Hỏng - ChiTietMuon 24)
(8, 24, N'Hong', 75000);

COMMIT TRANSACTION