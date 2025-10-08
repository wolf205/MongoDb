-- Tạo database
CREATE DATABASE QuanLyThuVien;
GO

USE QuanLyThuVien;
GO

--1. BẢNG TÀI KHOẢN
CREATE TABLE TaiKhoan (
    MaTaiKhoan INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) NOT NULL UNIQUE,
    MatKhau NVARCHAR(255) NOT NULL,
    LoaiTaiKhoan NVARCHAR(20) NOT NULL 
        CHECK (LoaiTaiKhoan IN (N'DocGia', N'ThuThu', N'Admin')),
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'HoatDong' 
        CHECK (TrangThai IN (N'HoatDong', N'TamKhoa', N'BiXoa')),
    MongoUserId NVARCHAR(50) NULL
);

--2. BẢNG THỦ THƯ
CREATE TABLE ThuThu (
    MaThuThu INT IDENTITY(1,1) PRIMARY KEY,
    MaTaiKhoan INT NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'HoatDong' 
        CHECK (TrangThai IN (N'HoatDong', N'NghiViec')),
    MongoProfileId NVARCHAR(50) NULL,
    FOREIGN KEY (MaTaiKhoan) REFERENCES TaiKhoan(MaTaiKhoan)
);

--3. BẢNG ĐỘC GIẢ
CREATE TABLE DocGia (
    MaDocGia INT IDENTITY(1,1) PRIMARY KEY,
    MaTaiKhoan INT NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    CCCD NVARCHAR(12) UNIQUE,
    NgayDangKy DATE DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'HoatDong' 
        CHECK (TrangThai IN (N'HoatDong', N'BiCam', N'NgungHoatDong')),
    MongoProfileId NVARCHAR(50) NULL,
    FOREIGN KEY (MaTaiKhoan) REFERENCES TaiKhoan(MaTaiKhoan)
);

--4. BẢNG THẺ THƯ VIỆN
CREATE TABLE The (
    MaThe INT IDENTITY(1,1) PRIMARY KEY,
    MaDocGia INT NOT NULL UNIQUE,
    NgayCap DATE DEFAULT GETDATE(),
    NgayHetHan DATE NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'HoatDong' 
        CHECK (TrangThai IN (N'HoatDong', N'TamKhoa', N'HetHan')),
    FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia),
    CONSTRAINT CK_The_Ngay CHECK (NgayHetHan > NgayCap)
);

--5. BẢNG ĐẦU SÁCH
CREATE TABLE DauSach (
    MaDauSach INT IDENTITY(1,1) PRIMARY KEY,
    TenSach NVARCHAR(200) NOT NULL,
    ISBN NVARCHAR(20) UNIQUE,
    NgayThem DATE DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'HoatDong' 
        CHECK (TrangThai IN (N'HoatDong', N'NgungPhatHanh')),
    MongoBookId NVARCHAR(50) NULL
);

--6. BẢNG BẢN SAO SÁCH
CREATE TABLE BanSao (
    MaBanSao INT IDENTITY(1,1) PRIMARY KEY,
    MaDauSach INT NOT NULL,
    TinhTrang NVARCHAR(20) DEFAULT N'CoSan' 
        CHECK (TinhTrang IN (N'CoSan', N'DangMuon', N'Hong', N'Mat', N'BaoTri')),
    ViTriKe NVARCHAR(50),
    NgayNhap DATE DEFAULT GETDATE(),
    FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach)
);

--7. BẢNG PHIẾU MƯỢN
CREATE TABLE PhieuMuon (
    MaPhieuMuon INT IDENTITY(1,1) PRIMARY KEY,
    MaDocGia INT NOT NULL,
    MaThuThu INT NOT NULL,
    NgayMuon DATETIME DEFAULT GETDATE(),
    HanTra DATETIME NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'DangMuon' 
        CHECK (TrangThai IN (N'DangMuon', N'DaTra', N'QuaHan', N'BiHuy')),
    FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia),
    FOREIGN KEY (MaThuThu) REFERENCES ThuThu(MaThuThu),
    CONSTRAINT CK_PhieuMuon_HanTra CHECK (HanTra >= NgayMuon)
);

--8. BẢNG CHI TIẾT MƯỢN
CREATE TABLE ChiTietMuon (
    MaChiTietMuon INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuMuon INT NOT NULL,
    MaBanSao INT NOT NULL,
    TinhTrangTra NVARCHAR(20) 
        CHECK (TinhTrangTra IN (N'Tot', N'Hong', N'Mat')),
    NgayTraThucTe DATETIME NULL,
    FOREIGN KEY (MaPhieuMuon) REFERENCES PhieuMuon(MaPhieuMuon),
    FOREIGN KEY (MaBanSao) REFERENCES BanSao(MaBanSao)
);

--9. BẢNG ĐẶT TRƯỚC
CREATE TABLE DatTruoc (
    MaDatTruoc INT IDENTITY(1,1) PRIMARY KEY,
    MaDocGia INT NOT NULL,
    MaDauSach INT NOT NULL,
    NgayDat DATETIME DEFAULT GETDATE(),
    NgayHetHan DATETIME NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'DangCho' 
        CHECK (TrangThai IN (N'DangCho', N'DaHuy', N'DaThanhCong', N'HetHan')),
    FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia),
    FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach),
    CONSTRAINT CK_DatTruoc_Ngay CHECK (NgayHetHan > NgayDat)
);

--10. BẢNG PHIẾU PHẠT
CREATE TABLE PhieuPhat (
    MaPhieuPhat INT IDENTITY(1,1) PRIMARY KEY,
    MaDocGia INT NOT NULL,
    MaThuThu INT NOT NULL,
    NgayLap DATETIME DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'ChuaThanhToan'
        CHECK (TrangThai IN (N'ChuaThanhToan', N'DaThanhToan', N'Huy')),
    FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia),
    FOREIGN KEY (MaThuThu) REFERENCES ThuThu(MaThuThu)
);

--11. BẢNG CHI TIẾT PHẠT
CREATE TABLE ChiTietPhat (
    MaChiTietPhat INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuPhat INT NOT NULL,
    MaChiTietMuon INT NOT NULL,
    LoaiPhat NVARCHAR(50) NOT NULL 
        CHECK (LoaiPhat IN (N'TraTre', N'Hong', N'Mat', N'Khac')),
    SoTien DECIMAL(10,2) NOT NULL CHECK (SoTien >= 0),
    FOREIGN KEY (MaPhieuPhat) REFERENCES PhieuPhat(MaPhieuPhat),
    FOREIGN KEY (MaChiTietMuon) REFERENCES ChiTietMuon(MaChiTietMuon)
);
