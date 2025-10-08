// ===============================================================================================
// ================================== 1. TẠO COLLECTION ========================================
// ============================================================================================

// --- 1.1 books (Lưu thông tin đầu sách) ---
db.createCollection("books");

// --- 1.2 userProfiles (Hồ sơ người dùng: độc giả, thủ thư) ---
db.createCollection("userProfiles");

// --- 1.3 notifications (Thông báo cho người dùng) ---
db.createCollection("notifications");

// --- 1.4 activityLogs (Lưu vết hoạt động hệ thống) ---
db.createCollection("activityLogs");

// --- 1.5 reviews (Đánh giá sách) ---
db.createCollection("reviews");

// --- 1.6 systemSettings (Cấu hình hệ thống) ---
db.createCollection("systemSettings");

// ===============================================================================================
// =================================== 2. CRUD =============================================
// ===============================================================================================

// ---------------------------------------------------------------------------------------------
// ------------------------------------CREATE--------------------------------------------------------------
// ---------------------------------------------------------------------------------------------

// ----2.1 books------------------------------------
db.books.insertMany([
  {
    MongoBookId: "B_001",
    MaDauSach: 1,
    TenSach: "Lập Trình Java Cơ Bản",
    MoTa: "Cuốn sách cung cấp kiến thức nền tảng vững chắc về ngôn ngữ lập trình Java, từ cú pháp cơ bản đến lập trình hướng đối tượng.",
    TacGia: [
      {
        HoTen: "Nguyễn Văn Lập",
        TieuSu: "Chuyên gia phát triển phần mềm hơn 10 năm kinh nghiệm.",
      },
    ],
    NhaXuatBan: "Nhà Xuất Bản Khoa Học Kỹ Thuật",
    NamXuatBan: 2024,
    Tags: ["Java", "Lập trình", "Cơ bản", "IT"],
    HinhAnh: {
      biaNho: "/images/books/b001_small.jpg",
      biaLon: "/images/books/b001_large.jpg",
    },
    ChiSoDanhGia: {
      avgRating: 4.5,
      reviewCount: 120,
    },
  },
  {
    MongoBookId: "B_007",
    MaDauSach: 7,
    TenSach: "Phân Tích Dữ Liệu với Python",
    MoTa: "Hướng dẫn toàn diện về việc sử dụng thư viện Python (Pandas, NumPy, Matplotlib) để thu thập, làm sạch và trực quan hóa dữ liệu. Phù hợp cho cả người mới bắt đầu và các nhà khoa học dữ liệu (Data Scientists).",
    TacGia: [
      {
        HoTen: "Đỗ Thanh Bình",
        TieuSu:
          "Tiến sĩ ngành Khoa học Máy tính, có nhiều công trình nghiên cứu về Big Data.",
      },
    ],
    NhaXuatBan: "NXB Thống Kê",
    NamXuatBan: 2023,
    NgayCapNhatLanCuoi: new Date("2024-05-15T10:00:00Z"),
    Tags: ["Python", "Data Science", "Phân tích dữ liệu", "Thống kê"],
    YeuCauDocGia: ["Có kiến thức cơ bản về lập trình"],
    HinhAnh: {
      urlBia: "/images/books/b007_python.webp",
      altText: "Bìa sách Phân Tích Dữ Liệu với Python",
    },
    ChiSoDanhGia: {
      avgRating: 4.8,
      reviewCount: 215,
      chiTietRating: {
        "5_sao": 180,
        "4_sao": 25,
        "3_sao": 10,
      },
    },
  },
  {
    MongoBookId: "B_019",
    MaDauSach: 19,
    TenSach: "Nghệ Thuật Lãnh Đạo",
    MoTa: "Phân tích sâu sắc về các phong cách lãnh đạo hiện đại, tập trung vào trí tuệ cảm xúc (EQ) và khả năng tạo động lực cho đội nhóm. Bao gồm các nghiên cứu tình huống thực tế.",
    TacGia: [
      { HoTen: "Lý Quang Hùng", ChucDanh: "Chuyên gia Tư vấn Quản trị" },
      { HoTen: "Trần Mai Chi", ChucDanh: "Giảng viên Quản trị Kinh doanh" },
    ],
    NhaXuatBan: "NXB Trí Thức",
    NamXuatBan: 2020,
    PhienBan: 2,
    LoaiSach: "Sách giấy",
    Tags: ["Lãnh đạo", "Quản lý", "Kỹ năng mềm", "Kinh doanh"],
    TomTatChuong: [
      "Chương 1: Khái niệm Lãnh đạo và Quản lý",
      "Chương 5: Sức mạnh của Trí tuệ Cảm xúc",
      "Chương 10: Xây dựng Văn hóa Tổ chức",
    ],
    ChiSoDanhGia: { avgRating: 4.1, reviewCount: 85 },
  },
  {
    MongoBookId: "B_020",
    MaDauSach: 20,
    TenSach: "Tác Phẩm Văn Học Việt Nam",
    MoTa: "Tuyển tập những tác phẩm văn xuôi và thơ ca kinh điển của Việt Nam trong giai đoạn 1930 - 1975, đi kèm với phân tích chuyên sâu của các nhà phê bình.",
    TacGia: [
      { HoTen: "Nhiều Tác Giả", PhuTrachBienSoan: "Phòng Nghiên cứu Văn học" },
    ],
    NhaXuatBan: "NXB Văn Học",
    NamXuatBan: 2018,
    TheLoai: "Tuyển tập, Văn học",
    GiaiThuong: ["Sách Vàng 2019"],
    Tags: ["Văn học Việt Nam", "Lịch sử", "Thơ ca"],
    NgonNgu: [
      { code: "vi", TenNgonNgu: "Tiếng Việt" },
      { code: "en", TenNgonNgu: "Tiếng Anh (Bản dịch)" },
    ],
    ChiSoDanhGia: { avgRating: 3.9, reviewCount: 45 },
  },
]);

// --- 2.2 userProfiles------------------------------------
db.userProfiles.insertMany([
  {
    MongoProfileId: "P_TT_001",
    MaTaiKhoan: 5,
    HoTen: "Nguyen Van A",
    role: "ThuThu",
    MaThuThu: 1,
    EmailLienHe: "nguyenvana@thuvien.edu.vn",
    ViTriLamViec: "Quầy Mượn/Trả",
    TrinhDo: "Đại học Thư viện học",
    SoDienThoai: "0987111222",
    NgayVaoLam: new Date("2024-03-01T00:00:00Z"),
  },
  {
    MongoProfileId: "P_DG_001",
    MaTaiKhoan: 1,
    HoTen: "Tran Van B",
    role: "DocGia",
    MaDocGia: 1,
    DiaChi: {
      SoNha: "123",
      Duong: "Đường Sách",
      Quan: "Quận 1",
      ThanhPho: "TP Hồ Chí Minh",
    },
    SoDienThoai: "0901234567",
    SoThich: ["Lập trình", "Kinh tế", "Lịch sử"],
    ChiSoHoatDong: {
      TongSoLanMuon: 15,
      TongSoLanPhat: 2,
      DiemUyTin: 95,
    },
  },
  {
    MongoProfileId: "P_DG_005",
    MaTaiKhoan: 8,
    HoTen: "Nguyễn Thị H",
    role: "DocGia",
    MaDocGia: 5,
    NgayDangKy: new Date("2025-09-26T00:00:00Z"),
    TrangThaiThe: "HoatDong",
    ThongTinKhac: "Sinh viên Khoa CNTT",
    SoDienThoai: "0999888777",
    SoThich: ["Thiết kế", "Văn học"],
    ChiSoHoatDong: {
      TongSoLanMuon: 0,
      TongSoLanPhat: 0,
      DiemUyTin: 100,
    },
  },
]);

// --- 2.3 notifications------------------------------------
db.notifications.insertMany([
  {
    MaDocGia: 1,
    messageType: "QuaHan",
    TieuDe: "Cảnh báo: Sách sắp quá hạn",
    NoiDung:
      "Cuốn 'Lập Trình Di Động với React Native' sắp hết hạn mượn vào ngày 2025-10-05.",
    LienKet: "/lichsu-muon?phieu=5",
    timestamp: new Date("2025-10-03T18:00:00Z"),
    isRead: false,
  },
  {
    MaDocGia: 3,
    messageType: "DatTruocThanhCong",
    TieuDe: "Đặt trước thành công!",
    NoiDung:
      "Sách 'Phân Tích Dữ Liệu với Python' đã có bản sao. Vui lòng nhận sách trước ngày 2025-10-03.",
    MaDauSach: 7,
    LienKet: "/dat-truoc/12",
    timestamp: new Date("2025-09-26T12:30:00Z"),
    isRead: true,
  },
  {
    MaDocGia: 4,
    messageType: "PhatMoi",
    TieuDe: "Phiếu phạt mới đã được lập",
    NoiDung:
      "Bạn có một phiếu phạt mới vì làm hỏng sách, tổng số tiền là 75.000 VNĐ. Vui lòng thanh toán.",
    MaPhieuPhat: 8,
    LienKet: "/phieu-phat/8",
    timestamp: new Date("2025-09-24T14:45:00Z"),
    isRead: false,
  },
]);

// --- 2.4 activityLogs------------------------------------
db.activityLogs.insertMany([
  {
    MaTaiKhoan: 5,
    LoaiLog: "ThuThu_CapNhatTrangThai",
    timestamp: new Date("2025-10-01T10:15:00Z"),
    ChiTiet:
      "Cập nhật trạng thái 'DangMuon' sang 'DaTra' cho Phiếu Mượn #17 (DocGia #3).",
    ThongTinChiTiet: {
      MaPhieuMuon: 17,
      MaThuThu: 1,
      ThaoTac: "TraSachThanhCong",
    },
  },
  {
    MaTaiKhoan: 3,
    LoaiLog: "DocGia_DatTruoc",
    timestamp: new Date("2025-09-25T15:45:00Z"),
    ChiTiet:
      "Độc giả đặt trước Đầu Sách 'Lập Trình Java Cơ Bản' (MaDauSach #1).",
    ThongTinChiTiet: {
      MaDatTruoc: 7,
      MaDauSach: 1,
      TrangThaiHienTai: "DangCho",
    },
    Source_IP: "103.27.45.1",
  },
  {
    MaTaiKhoan: 7,
    LoaiLog: "Admin_ThayDoiCauHinh",
    timestamp: new Date("2025-10-04T09:00:00Z"),
    ChiTiet:
      "Cập nhật cấu hình hệ thống: 'SoNgayMuonToiDa' từ 14 ngày thành 21 ngày.",
    ThongTinChiTiet: {
      key: "SoNgayMuonToiDa",
      GiaTriCu: 14,
      GiaTriMoi: 21,
    },
  },
]);

// --- 2.5 reviews------------------------------------
db.reviews.insertMany([
  {
    MaDocGia: 1,
    MaDauSach: 7,
    TenDocGia: "Tran Van B",
    TieuDe: "Cuốn sách nền tảng tuyệt vời về Data Science!",
    NoiDung:
      "Nội dung cực kỳ chi tiết, giải thích Pandas và Matplotlib rõ ràng, có nhiều ví dụ thực tế. Rất hữu ích cho người mới bắt đầu như tôi. Chỉ tiếc là không có thêm chương về Machine Learning cơ bản.",
    Rating: 5,
    NgayDanhGia: new Date("2025-10-01T14:30:00Z"),
    ThongKeTuongTac: {
      LuotThich: 15,
      BaoCaoViPham: 0,
    },
    HinhAnhKemTheo: ["/reviews/601/anh1.jpg"],
  },
  {
    MaDocGia: 2,
    MaDauSach: 1,
    TenDocGia: "Le Thi C",
    TieuDe: "Tài liệu cơ bản tốt, nhưng hơi lỗi thời.",
    NoiDung:
      "Sách bao quát được kiến thức Java căn bản. Tuy nhiên, một số ví dụ sử dụng cú pháp cũ (Java 8), cần được cập nhật sang Java 17+ để phù hợp với thực tế phát triển hiện nay.",
    Rating: 3,
    NgayDanhGia: new Date("2025-09-29T10:00:00Z"),
    ThongKeTuongTac: {
      LuotThich: 5,
      BaoCaoViPham: 1,
    },
  },
  {
    MaDocGia: 4,
    MaDauSach: 19,
    TenDocGia: "Do Thi F",
    TieuDe: "Đáng đọc cho quản lý cấp trung.",
    NoiDung:
      "Tác giả trình bày các case study quản lý nhân sự rất thực tế và dễ áp dụng. Rất khuyến khích.",
    Rating: 4,
    NgayDanhGia: new Date("2025-09-25T09:45:00Z"),
    ThongKeTuongTac: {
      LuotThich: 20,
      BaoCaoViPham: 0,
    },
  },
]);

// --- 1.6 systemSettings------------------------------------
db.systemSettings.insertMany([
  {
    key: "circulationRules",
    description: "Các quy tắc và giới hạn cho việc mượn và trả sách.",
    value: {
      SoNgayMuonToiDa: 14,
      SoSachToiDaChoDocGia: 5,
      SoLanGiaHanToiDa: 1,
      ThoiGianPhatMotNgay: 1000,
      TrangThaiTheHopLe: ["HoatDong"],
    },
    NgayCapNhatCuoi: new Date("2025-09-01T08:00:00Z"),
    NguoiCapNhat: "Admin 1",
  },
  {
    key: "systemLimits",
    description: "Giới hạn các tính năng để bảo vệ tài nguyên hệ thống.",
    value: {
      SoLuongDatTruocToiDa: 3,
      ThoiHanGiuSachDatTruoc_Gio: 72,
      GioiHanGuiEmailHangNgay: 5000,
    },
    NgayCapNhatCuoi: new Date("2025-08-15T15:30:00Z"),
    NguoiCapNhat: "Admin 2",
  },
  {
    key: "externalServices",
    description: "Cấu hình cho các dịch vụ bên ngoài (ví dụ: Thanh toán, SMS).",
    value: {
      PaymentGateway: {
        isEnabled: true,
        provider: "VNPAY",
        apiUrl: "https://api.vnpay.vn/v1/",
        merchantId: "MERCHANT_ABC_XYZ",
      },
      SMSProvider: {
        isEnabled: false,
        provider: "VIETTEL_SMS",
      },
    },
    NgayCapNhatCuoi: new Date("2025-10-02T11:00:00Z"),
    NguoiCapNhat: "Admin 1",
  },
]);

// ===============================================================================================
// =================================== READ (Truy vấn) =============================================
// ===============================================================================================

// --------------------------------3.1.Truy vấn Collection books--------------------------

// --- 3.1.1. Tìm tất cả sách có Tag là 'Lập trình'
db.books.find({ Tags: "Lập trình" });

// --- 3.1.2. Tìm sách được xuất bản trong năm 2024
db.books.find({ NamXuatBan: 2024 });

// --- 3.1.3. Tìm sách có Rating trung bình (avgRating) từ 4.5 trở lên
db.books.find({ "ChiSoDanhGia.avgRating": { $gte: 4.5 } });

// --- 3.1.4. Tìm sách có từ khóa 'Python' trong tên hoặc mô tả (sử dụng $regex)
db.books.find({
  $or: [
    { TenSach: { $regex: "Python", $options: "i" } },
    { MoTa: { $regex: "Python", $options: "i" } },
  ],
});

// --- 3.1.5. Tìm và sắp xếp: Sách về Data Science, sắp xếp theo reviewCount giảm dần (Limit 1)
db.books
  .find({ Tags: "Data Science" })
  .sort({ "ChiSoDanhGia.reviewCount": -1 })
  .limit(1);

// ----------------------3.2.Truy vấn Collection userProfiles--------------------------

// --- 3.2.1. Tìm tất cả hồ sơ có vai trò 'DocGia'
db.userProfiles.find({ role: "DocGia" });

// --- 3.2.2. Tìm thủ thư (role: 'ThuThu')
db.userProfiles.find({ role: "ThuThu" });

// --- 3.2.3. Tìm độc giả có Điểm Uy Tín (DiemUyTin) dưới 100
db.userProfiles.find({
  role: "DocGia",
  "ChiSoHoatDong.DiemUyTin": { $lt: 100 },
});

// --- 3.2.4. Tìm độc giả có sở thích 'Lịch sử' và ở 'TP Hồ Chí Minh'
db.userProfiles.find({
  role: "DocGia",
  SoThich: "Lịch sử",
  "DiaChi.ThanhPho": "TP Hồ Chí Minh",
});

// ----------------------3.3.Truy vấn Collection notifications--------------------------

// --- 3.3.1. Tìm tất cả thông báo chưa đọc (isRead: false)
db.notifications.find({ isRead: false });

// --- 3.3.2. Tìm thông báo có messageType là 'QuaHan' và chưa đọc
db.notifications.find({ messageType: "QuaHan", isRead: false });

// --- 3.3.3. Đếm số lượng thông báo được tạo trong tháng 10 năm 2025
db.notifications.countDocuments({
  timestamp: {
    $gte: new Date("2025-10-01T00:00:00Z"),
    $lt: new Date("2025-11-01T00:00:00Z"),
  },
});

// ----------------------3.4.Truy vấn Collection reviews--------------------------

// --- 3.4.1. Tìm tất cả đánh giá của sách có MaDauSach là 7 ('Phân Tích Dữ Liệu với Python')
db.reviews.find({ MaDauSach: 7 });

// --- 3.4.2. Tìm các đánh giá 5 sao
db.reviews.find({ Rating: 5 });

// --- 3.4.3. Tìm đánh giá có LuotThich (Likes) lớn hơn hoặc bằng 15
db.reviews.find({ "ThongKeTuongTac.LuotThich": { $gte: 15 } });

// ===============================================================================================
// =================================== UPDATE (Cập nhật) =============================================
// ===============================================================================================

// ----------------------4.1.Cập nhật Collection books--------------------------

// --- 4.1.1. Tăng reviewCount của sách 'Lập Trình Java Cơ Bản' (MaDauSach: 1) thêm 5 reviews
db.books.updateOne(
  { MaDauSach: 1 },
  { $inc: { "ChiSoDanhGia.reviewCount": 5 } }
);

// --- 4.1.2. Cập nhật NamXuatBan của 'Nghệ Thuật Lãnh Đạo' (MaDauSach: 19) thành 2021 và thêm một Tag mới
db.books.updateOne(
  { MaDauSach: 19 },
  {
    $set: { NamXuatBan: 2021 },
    $addToSet: { Tags: "Phát triển cá nhân" }, // $addToSet để tránh trùng lặp Tag
  }
);

// --- 4.1.3. Đổi tên trường (field) 'HinhAnh.urlBia' thành 'HinhAnh.biaLon' cho sách B_007 (nếu nó tồn tại)
db.books.updateOne(
  { MongoBookId: "B_007", "HinhAnh.urlBia": { $exists: true } },
  {
    $rename: { "HinhAnh.urlBia": "HinhAnh.biaLon" },
    $unset: { "HinhAnh.altText": "" }, // Xóa trường altText
  }
);

// ----------------------4.2.Cập nhật Collection userProfiles--------------------------

// --- 4.2.1. Độc giả 'Tran Van B' (MaDocGia: 1) vừa mượn thêm 1 cuốn sách: tăng TongSoLanMuon thêm 1
db.userProfiles.updateOne(
  { MaDocGia: 1, role: "DocGia" },
  { $inc: { "ChiSoHoatDong.TongSoLanMuon": 1 } }
);

// --- 4.2.2. Thủ thư 'Nguyen Van A' (MaTaiKhoan: 5) đã được phân công thêm vai trò mới
db.userProfiles.updateOne(
  { MaTaiKhoan: 5, role: "ThuThu" },
  { $set: { ViTriLamViec: "Quản lý kho sách và Quầy Mượn/Trả" } }
);

// ----------------------4.3.Cập nhật Collection notifications--------------------------

// --- 4.3.1. Đánh dấu tất cả thông báo của DocGia 1 là đã đọc
db.notifications.updateMany(
  { MaDocGia: 1, isRead: false },
  { $set: { isRead: true } }
);

// --- 4.3.2. Cập nhật nội dung cho thông báo 'PhatMoi' của MaPhieuPhat 8
db.notifications.updateOne(
  { MaPhieuPhat: 8, messageType: "PhatMoi" },
  {
    $set: {
      NoiDung:
        "Bạn có một phiếu phạt mới vì làm hỏng sách, tổng số tiền đã được giảm còn 70.000 VNĐ. Vui lòng thanh toán.",
    },
  }
);

// ===============================================================================================
// =================================== DELETE (Xóa) =============================================
// ===============================================================================================

// ----------------------5.1. Xóa Collection reviews--------------------------

// --- 5.1.1. Xóa đánh giá của độc giả 'Le Thi C' (MaDocGia: 2) vì vi phạm quy định (đã bị báo cáo)
db.reviews.deleteOne({ MaDocGia: 2, MaDauSach: 1 });

// --- 5.1.2. Xóa tất cả đánh giá 1 sao
db.reviews.deleteMany({ Rating: 1 });

// ----------------------5.2. Xóa Collection userProfiles--------------------------

// --- 5.2.1. Xóa hồ sơ độc giả 'Nguyễn Thị H' (MaDocGia: 5) do thẻ hết hạn
db.userProfiles.deleteOne({ MaDocGia: 5, role: "DocGia" });

// ----------------------5.3. Xóa Collection activityLogs--------------------------

// --- 5.3.1. Xóa tất cả các log hoạt động Admin_ThayDoiCauHinh cũ hơn ngày 01/10/2025
db.activityLogs.deleteMany({
  LoaiLog: "Admin_ThayDoiCauHinh",
  timestamp: { $lt: new Date("2025-10-01T00:00:00Z") },
});

// ===============================================================================================
// =================================== 3. AGGREGATION =============================================
// ===============================================================================================

// ----------------------3.1. Phân Tích Dữ Liệu Sách (books Collection)--------------------------

// --- 3.1.1. Tính Rating Trung Bình và Tổng Review Count theo Năm Xuất Bản
db.books.aggregate([
  {
    $group: {
      _id: "$NamXuatBan", // Nhóm theo Năm Xuất Bản
      SoLuongDauSach: { $sum: 1 }, // Đếm số lượng sách trong nhóm
      RatingTrungBinh: { $avg: "$ChiSoDanhGia.avgRating" }, // Tính trung bình avgRating
      TongSoLuotReview: { $sum: "$ChiSoDanhGia.reviewCount" }, // Tính tổng reviewCount
    },
  },
  {
    $sort: { _id: -1 }, // Sắp xếp giảm dần theo năm (năm gần nhất lên đầu)
  },
]);
// --- 3.1.2. Tìm Top 3 Tags Phổ Biến Nhất
db.books.aggregate([
  { $unwind: "$Tags" }, // Tách mảng Tags thành từng document riêng lẻ
  {
    $group: {
      _id: "$Tags", // Nhóm theo từng Tag
      SoLanSuDung: { $sum: 1 }, // Đếm số lần Tag xuất hiện
    },
  },
  {
    $sort: { SoLanSuDung: -1 }, // Sắp xếp giảm dần
  },
  { $limit: 3 }, // Chỉ lấy 3 Tag đứng đầu
]);

// ----------------------3.2. Phân Tích Hồ Sơ Người Dùng (userProfiles Collection)--------------------------

// --- 3.2.1. Tính Chỉ Số Hoạt Động Trung Bình của Độc Giả theo Thành Phố
db.userProfiles.aggregate([
  { $match: { role: "DocGia", "DiaChi.ThanhPho": { $exists: true } } }, // Lọc hồ sơ độc giả có thông tin thành phố
  {
    $group: {
      _id: "$DiaChi.ThanhPho", // Nhóm theo Thành phố
      AvgMuonSach: { $avg: "$ChiSoHoatDong.TongSoLanMuon" },
      AvgSoLanPhat: { $avg: "$ChiSoHoatDong.TongSoLanPhat" },
      AvgDiemUyTin: { $avg: "$ChiSoHoatDong.DiemUyTin" },
    },
  },
  { $sort: { AvgDiemUyTin: -1 } },
]);

// ----------------------3.3. Phân Tích Thông Báo và Log (notifications và activityLogs Collections)--------------------------

// --- 3.3.1. Đếm Số Lượng Thông Báo theo Loại (notifications Collection)
db.notifications.aggregate([
  {
    $group: {
      _id: "$messageType", // Nhóm theo Loại thông báo
      TongSoThongBao: { $sum: 1 }, // Đếm số lượng
      SoThongBaoChuaDoc: {
        $sum: { $cond: [{ $eq: ["$isRead", false] }, 1, 0] }, // Dùng $cond để đếm có điều kiện
      },
    },
  },
  { $sort: { TongSoThongBao: -1 } },
]);

// --- 3.3.2. Thống Kê Hoạt Động Hệ Thống theo Ngày (activityLogs Collection)
db.activityLogs.aggregate([
  {
    $project: {
      _id: 0,
      NgayHoatDong: {
        $dateToString: { format: "%Y-%m-%d", date: "$timestamp" }, // Trích xuất ngày tháng
      },
      LoaiLog: 1,
    },
  },
  {
    $group: {
      _id: { Ngay: "$NgayHoatDong", Loai: "$LoaiLog" }, // Nhóm theo cặp (Ngày, Loại Log)
      SoLuong: { $sum: 1 },
    },
  },
  {
    $group: {
      _id: "$_id.Ngay", // Nhóm lại theo Ngày
      ChiTiet: {
        $push: { Loai: "$_id.Loai", SoLuong: "$SoLuong" }, // Đẩy chi tiết vào một mảng
      },
      TongHoatDongTrongNgay: { $sum: "$SoLuong" },
    },
  },
  { $sort: { _id: -1 } },
]);
// ===== 4. INDEX =====
// ===== 5. TRANSACTION =====
