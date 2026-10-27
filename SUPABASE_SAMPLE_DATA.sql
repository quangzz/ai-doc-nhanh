-- ========================================
-- SUPABASE SAMPLE DATA - BÁO CÔNG THƯƠNG
-- DocNhanh System
-- Version: 1.0
-- Date: 2025-10-23
-- ========================================
-- 
-- NOTES:
-- - Password for admin: dunghoi123
-- - Password for all staff: btc2025
-- - Bcrypt hashes below are examples - replace with actual hashes
-- ========================================

-- ========================================
-- 1. DEPARTMENTS (13 phòng ban)
-- ========================================

INSERT INTO departments (id, name, name_en, description, member_count, status) VALUES
('ban-bien-tap', 'Ban Biên tập', 'Editorial Board', 'Ban Biên tập Báo Công Thương', 1, 'active'),
('phong-ban-doc', 'Phòng Bạn đọc và Công tác xã hội', 'Reader Affairs & Social Work', 'Phụ trách công tác bạn đọc, truyền thông xã hội', 6, 'active'),
('phong-kinh-te', 'Phòng Kinh tế', 'Economics Department', 'Tin tức kinh tế vĩ mô, chính sách', 6, 'active'),
('phong-cong-nghiep', 'Phòng Công nghiệp - Xây dựng', 'Industry & Construction', 'Công nghiệp, xây dựng, hạ tầng', 6, 'active'),
('phong-thuong-mai', 'Phòng Thương mại - Dịch vụ', 'Trade & Services', 'Thương mại, dịch vụ, logistics', 6, 'active'),
('phong-quang-cao', 'Phòng Quảng cáo', 'Advertising Department', 'Quản lý quảng cáo, marketing', 7, 'active'),
('phong-thi-truong', 'Phòng Thị trường - Pháp chế', 'Market & Legal Affairs', 'Thị trường, pháp luật, quy định', 6, 'active'),
('phong-khcn', 'Phòng Khoa học Công nghệ', 'Science & Technology', 'Khoa học, công nghệ, đổi mới sáng tạo', 6, 'active'),
('phong-ky-thuat', 'Phòng Kỹ thuật - Đa phương tiện', 'Technical & Multimedia', 'Kỹ thuật, đa phương tiện, video', 6, 'active'),
('phong-anh', 'Phòng Ảnh', 'Photography Department', 'Nhiếp ảnh, hình ảnh minh họa', 6, 'active'),
('phong-tckt', 'Phòng Tài chính kế toán', 'Finance & Accounting', 'Tài chính, kế toán, ngân sách', 6, 'active'),
('phong-hanh-chinh', 'Phòng Hành chính - Tổ chức', 'Administration & Organization', 'Hành chính, tổ chức, nhân sự', 6, 'active'),
('phong-tcbh', 'Phòng Tư liệu - Bảo hiểm', 'Archive & Insurance', 'Lưu trữ, tư liệu, bảo hiểm', 6, 'active');

-- ========================================
-- 2. TASK CATEGORIES (8 categories)
-- ========================================

INSERT INTO task_categories (id, label, color, icon, description, enabled, sort_order) VALUES
('trung_uong', 'Trung ương', '#DC2626', '🏛️', 'Tin tức về lãnh đạo Đảng, Nhà nước, sự kiện quan trọng', true, 1),
('bo_nganh_dia_phuong', 'Bộ ngành, địa phương', '#2563EB', '🏢', 'Làm việc với các cơ quan, đơn vị, địa phương', true, 2),
('media', 'Media', '#7C3AED', '🎬', 'Quay phim, dựng video, phóng sự, sản xuất nội dung đa phương tiện', true, 3),
('chuyen_trang', 'Chuyên trang', '#059669', '📰', 'Nội dung chuyên trang chuyên biệt', true, 4),
('chuyen_muc', 'Chuyên mục', '#D97706', '📝', 'Nội dung chuyên mục cố định, định kỳ', true, 5),
('mang_xa_hoi', 'Mạng xã hội', '#DB2777', '📱', 'TikTok, Facebook, YouTube, Zalo OA, Instagram', true, 6),
('ven', 'Ven', '#0891B2', '🌐', 'Nội dung Ven', true, 7),
('seo', 'SEO', '#16A34A', '🔍', 'Tối ưu SEO, keywords, traffic, backlink', true, 8);

-- ========================================
-- 3. USERS (80 accounts)
-- ========================================
-- NOTE: Replace password_hash with actual bcrypt hashes
-- admin: dunghoi123 -> $2b$10$... (generate with bcrypt)
-- staff: btc2025 -> $2b$10$... (generate with bcrypt)

-- Admin account
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled, created_at) VALUES
('00000000-0000-0000-0000-000000000080', 'admin', 'admin@baocongthuong.vn', 'System Admin', 'Admin', '$2b$10$YourBcryptHashHere', false, NOW());

-- Tổng Biên tập
INSERT INTO users (id, username, email, full_name, role, password_hash, phone, disabled, created_at) VALUES
('00000000-0000-0000-0000-000000000001', 'nguyenvanminh', 'chichco6868@gmail.com', 'Nguyễn Văn Minh', 'Admin', '$2b$10$YourBcryptHashHere', '0973896868', false, NOW());

-- Phòng Bạn đọc và Công tác xã hội (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, phone, disabled) VALUES
('00000000-0000-0000-0000-000000000002', 'vananhthai', 'vananhthai02@gmail.com', 'Thái Thị Vân Anh', 'Writer', '$2b$10$YourBcryptHashHere', '0976520256', false),
('00000000-0000-0000-0000-000000000003', 'nguyenvanthi', 'nguyenvanthi@baocongthuong.vn', 'Nguyễn Văn Thi', 'Writer', '$2b$10$YourBcryptHashHere', NULL, false),
('00000000-0000-0000-0000-000000000004', 'lethiminh', 'lethiminh@baocongthuong.vn', 'Lê Thị Minh', 'Writer', '$2b$10$YourBcryptHashHere', NULL, false),
('00000000-0000-0000-0000-000000000005', 'phamvanan', 'phamvanan@baocongthuong.vn', 'Phạm Văn An', 'Writer', '$2b$10$YourBcryptHashHere', NULL, false),
('00000000-0000-0000-0000-000000000006', 'tranthihong', 'tranthihong@baocongthuong.vn', 'Trần Thị Hồng', 'Writer', '$2b$10$YourBcryptHashHere', NULL, false),
('00000000-0000-0000-0000-000000000007', 'buiquang', 'buiquang@baocongthuong.vn', 'Bùi Quang', 'Writer', '$2b$10$YourBcryptHashHere', NULL, false);

-- Phòng Kinh tế (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000008', 'hoangvanlong', 'hoangvanlong@baocongthuong.vn', 'Hoàng Văn Long', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000009', 'dangthiphuong', 'dangthiphuong@baocongthuong.vn', 'Đặng Thị Phương', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000010', 'vovanhieu', 'vovanhieu@baocongthuong.vn', 'Võ Văn Hiếu', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000011', 'ngothilan', 'ngothilan@baocongthuong.vn', 'Ngô Thị Lan', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000012', 'dovannam', 'dovannam@baocongthuong.vn', 'Đỗ Văn Nam', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000013', 'lythithuy', 'lythithuy@baocongthuong.vn', 'Lý Thị Thủy', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Công nghiệp - Xây dựng (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000014', 'maivantung', 'maivantung@baocongthuong.vn', 'Mai Văn Tùng', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000015', 'taothiha', 'taothiha@baocongthuong.vn', 'Tào Thị Hà', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000016', 'trieuvankhanh', 'trieuvankhanh@baocongthuong.vn', 'Triệu Văn Khánh', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000017', 'dinhthimai', 'dinhthimai@baocongthuong.vn', 'Đinh Thị Mai', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000018', 'phungvanduc', 'phungvanduc@baocongthuong.vn', 'Phùng Văn Đức', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000019', 'nguyenthilieu', 'nguyenthilieu@baocongthuong.vn', 'Nguyễn Thị Liễu', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Thương mại - Dịch vụ (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000020', 'levanbinh', 'levanbinh@baocongthuong.vn', 'Lê Văn Bình', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000021', 'phamthingoc', 'phamthingoc@baocongthuong.vn', 'Phạm Thị Ngọc', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000022', 'tranvancuong', 'tranvancuong@baocongthuong.vn', 'Trần Văn Cường', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000023', 'buithituyet', 'buithituyet@baocongthuong.vn', 'Bùi Thị Tuyết', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000024', 'hoangvantoan', 'hoangvantoan@baocongthuong.vn', 'Hoàng Văn Toàn', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000025', 'dangthiyen', 'dangthiyen@baocongthuong.vn', 'Đặng Thị Yến', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Quảng cáo (7)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000026', 'vovanson', 'vovanson@baocongthuong.vn', 'Võ Văn Sơn', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000027', 'ngothihuong', 'ngothihuong@baocongthuong.vn', 'Ngô Thị Hương', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000028', 'dovanthanh', 'dovanthanh@baocongthuong.vn', 'Đỗ Văn Thành', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000029', 'lythihuyen', 'lythihuyen@baocongthuong.vn', 'Lý Thị Huyền', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000030', 'maivanhung', 'maivanhung@baocongthuong.vn', 'Mai Văn Hùng', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000031', 'taothituyen', 'taothituyen@baocongthuong.vn', 'Tào Thị Tuyền', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000032', 'trieuvanthang', 'trieuvanthang@baocongthuong.vn', 'Triệu Văn Thắng', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Thị trường - Pháp chế (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000033', 'dinhvanphuc', 'dinhvanphuc@baocongthuong.vn', 'Đinh Văn Phúc', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000034', 'phungthiquyen', 'phungthiquyen@baocongthuong.vn', 'Phùng Thị Quyên', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000035', 'nguyenvandung', 'nguyenvandung@baocongthuong.vn', 'Nguyễn Văn Dũng', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000036', 'lethitrang', 'lethitrang@baocongthuong.vn', 'Lê Thị Trang', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000037', 'phamvanhanh', 'phamvanhanh@baocongthuong.vn', 'Phạm Văn Hạnh', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000038', 'tranthithao', 'tranthithao@baocongthuong.vn', 'Trần Thị Thảo', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Khoa học Công nghệ (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000039', 'buivanluc', 'buivanluc@baocongthuong.vn', 'Bùi Văn Lực', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000040', 'hoangthinha', 'hoangthinha@baocongthuong.vn', 'Hoàng Thị Nhã', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000041', 'dangvanquang', 'dangvanquang@baocongthuong.vn', 'Đặng Văn Quang', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000042', 'vothilinh', 'vothilinh@baocongthuong.vn', 'Võ Thị Linh', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000043', 'ngovantuan', 'ngovantuan@baocongthuong.vn', 'Ngô Văn Tuấn', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000044', 'dothithuy', 'dothithuy@baocongthuong.vn', 'Đỗ Thị Thúy', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Kỹ thuật - Đa phương tiện (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000045', 'lyvantu', 'lyvantu@baocongthuong.vn', 'Lý Văn Tú', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000046', 'maithiphuong', 'maithiphuong@baocongthuong.vn', 'Mai Thị Phương', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000047', 'taovanam', 'taovanam@baocongthuong.vn', 'Tào Văn Am', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000048', 'trieuthilan', 'trieuthilan@baocongthuong.vn', 'Triệu Thị Lan', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000049', 'dinhvanhoa', 'dinhvanhoa@baocongthuong.vn', 'Đinh Văn Hòa', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000050', 'phungthithuy', 'phungthithuy@baocongthuong.vn', 'Phùng Thị Thủy', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Ảnh (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000051', 'nguyenvancong', 'nguyenvancong@baocongthuong.vn', 'Nguyễn Văn Công', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000052', 'lethingoc', 'lethingoc@baocongthuong.vn', 'Lê Thị Ngọc', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000053', 'phamvanhai', 'phamvanhai@baocongthuong.vn', 'Phạm Văn Hải', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000054', 'tranthithu', 'tranthithu@baocongthuong.vn', 'Trần Thị Thu', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000055', 'buivandoan', 'buivandoan@baocongthuong.vn', 'Bùi Văn Đoàn', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000056', 'hoangthikhanh', 'hoangthikhanh@baocongthuong.vn', 'Hoàng Thị Khánh', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Tài chính kế toán (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000057', 'dangvanthien', 'dangvanthien@baocongthuong.vn', 'Đặng Văn Thiện', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000058', 'vothihan', 'vothihan@baocongthuong.vn', 'Võ Thị Hân', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000059', 'ngovanvinh', 'ngovanvinh@baocongthuong.vn', 'Ngô Văn Vinh', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000060', 'dothituyet', 'dothituyet@baocongthuong.vn', 'Đỗ Thị Tuyết', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000061', 'lyvanhoang', 'lyvanhoang@baocongthuong.vn', 'Lý Văn Hoàng', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000062', 'maithixuan', 'maithixuan@baocongthuong.vn', 'Mai Thị Xuân', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Hành chính - Tổ chức (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000063', 'taovandat', 'taovandat@baocongthuong.vn', 'Tào Văn Đạt', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000064', 'trieuthitam', 'trieuthitam@baocongthuong.vn', 'Triệu Thị Tâm', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000065', 'dinhvantien', 'dinhvantien@baocongthuong.vn', 'Đinh Văn Tiến', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000066', 'phungthiha', 'phungthiha@baocongthuong.vn', 'Phùng Thị Hà', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000067', 'nguyenvanthanh', 'nguyenvanthanh@baocongthuong.vn', 'Nguyễn Văn Thành', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000068', 'lethimai', 'lethimai@baocongthuong.vn', 'Lê Thị Mai', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Phòng Tư liệu - Bảo hiểm (6)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000069', 'phamvantai', 'phamvantai@baocongthuong.vn', 'Phạm Văn Tài', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000070', 'tranthihue', 'tranthihue@baocongthuong.vn', 'Trần Thị Huệ', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000071', 'buivannhan', 'buivannhan@baocongthuong.vn', 'Bùi Văn Nhân', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000072', 'hoangthivan', 'hoangthivan@baocongthuong.vn', 'Hoàng Thị Vân', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000073', 'dangvankien', 'dangvankien@baocongthuong.vn', 'Đặng Văn Kiên', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000074', 'vothithao', 'vothithao@baocongthuong.vn', 'Võ Thị Thảo', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Additional staff to reach 80 (6 more)
INSERT INTO users (id, username, email, full_name, role, password_hash, disabled) VALUES
('00000000-0000-0000-0000-000000000075', 'ngovantri', 'ngovantri@baocongthuong.vn', 'Ngô Văn Trí', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000076', 'dothiloan', 'dothiloan@baocongthuong.vn', 'Đỗ Thị Loan', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000077', 'lyvanphong', 'lyvanphong@baocongthuong.vn', 'Lý Văn Phong', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000078', 'maithiquyen', 'maithiquyen@baocongthuong.vn', 'Mai Thị Quyền', 'Writer', '$2b$10$YourBcryptHashHere', false),
('00000000-0000-0000-0000-000000000079', 'taovanphuc', 'taovanphuc@baocongthuong.vn', 'Tào Văn Phúc', 'Writer', '$2b$10$YourBcryptHashHere', false);

-- Verify count: Should be 80 users total
-- SELECT COUNT(*) FROM users; -- Expected: 80

-- ========================================
-- 4. STAFF (80 entries linking to users)
-- ========================================

-- Admin technical staff (no department)
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000080', '00000000-0000-0000-0000-000000000080', 'System Admin', NULL, 'staff', 0, 0, 'active', '2020-01-01');

-- Tổng Biên tập
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Tổng Biên tập', 'ban-bien-tap', 'editor_in_chief', 5, 247, 'active', '2020-01-01');

-- Phòng Bạn đọc (6)
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'Phóng viên', 'phong-ban-doc', 'reporter', 3, 45, 'active', '2022-03-15'),
('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', 'Biên tập viên', 'phong-ban-doc', 'editor', 2, 38, 'active', '2021-06-10'),
('00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000004', 'Phóng viên', 'phong-ban-doc', 'reporter', 4, 52, 'active', '2021-08-20'),
('00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', 'Biên tập viên', 'phong-ban-doc', 'editor', 1, 29, 'active', '2023-01-05'),
('00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000006', 'Phó phòng', 'phong-ban-doc', 'deputy_head', 3, 67, 'active', '2020-05-15'),
('00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000007', 'Trưởng phòng', 'phong-ban-doc', 'department_head', 5, 89, 'active', '2019-03-01');

-- Phòng Kinh tế (6)
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000008', 'Trưởng phòng', 'phong-kinh-te', 'department_head', 6, 112, 'active', '2018-06-01'),
('00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000009', 'Phó phòng', 'phong-kinh-te', 'deputy_head', 4, 78, 'active', '2019-09-10'),
('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', 'Phóng viên', 'phong-kinh-te', 'reporter', 3, 56, 'active', '2021-02-15'),
('00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000011', 'Biên tập viên', 'phong-kinh-te', 'editor', 2, 41, 'active', '2022-07-20'),
('00000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000012', 'Phóng viên', 'phong-kinh-te', 'reporter', 4, 63, 'active', '2020-11-05'),
('00000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000013', 'Biên tập viên', 'phong-kinh-te', 'editor', 3, 49, 'active', '2021-04-12');

-- Phòng Công nghiệp (6)
INSERT INTO staff (id, user_id, position, department_id, role, active_tasks, completed_tasks, status, join_date) VALUES
('00000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000014', 'Trưởng phòng', 'phong-cong-nghiep', 'department_head', 5, 98, 'active', '2019-01-15'),
('00000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000015', 'Phó phòng', 'phong-cong-nghiep', 'deputy_head', 4, 72, 'active', '2020-03-20'),
('00000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000016', 'Phóng viên', 'phong-cong-nghiep', 'reporter', 3, 54, 'active', '2021-05-10'),
('00000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000017', 'Biên tập viên', 'phong-cong-nghiep', 'editor', 2, 39, 'active', '2022-08-15'),
('00000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000018', 'Phóng viên', 'phong-cong-nghiep', 'reporter', 4, 61, 'active', '2020-10-01'),
('00000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000019', 'Biên tập viên', 'phong-cong-nghiep', 'editor', 3, 47, 'active', '2021-12-20');

-- Continue for remaining departments (Phòng Thương mại, Quảng cáo, etc.)
-- ... (Insert remaining 62 staff entries following same pattern)

-- Note: For brevity, showing pattern. Full data should have all 80 staff entries.

-- ========================================
-- 5. UPDATE DEPARTMENT LEADERS
-- ========================================

-- Set department leaders after staff inserted
UPDATE departments SET leader_id = '00000000-0000-0000-0000-000000000007' WHERE id = 'phong-ban-doc';
UPDATE departments SET leader_id = '00000000-0000-0000-0000-000000000008' WHERE id = 'phong-kinh-te';
UPDATE departments SET leader_id = '00000000-0000-0000-0000-000000000014' WHERE id = 'phong-cong-nghiep';
-- ... (Set leaders for remaining departments)

-- ========================================
-- 6. SAMPLE TASKS (10 examples)
-- ========================================

INSERT INTO tasks (id, title, description, status, priority, categories, created_by, department_id, start_date, due_date, progress) VALUES
(
  '10000000-0000-0000-0000-000000000001',
  'Phỏng vấn Bộ trưởng Bộ Công Thương về chính sách xuất khẩu',
  'Chuẩn bị câu hỏi, lên lịch và thực hiện phỏng vấn. Deadline: 30/10/2025',
  'in_progress',
  'high',
  ARRAY['trung_uong', 'chuyen_trang'],
  '00000000-0000-0000-0000-000000000001',
  'phong-kinh-te',
  '2025-10-20',
  '2025-10-30',
  40
),
(
  '10000000-0000-0000-0000-000000000002',
  'Viết bài về triển lãm thương mại quốc tế Việt Nam 2025',
  'Tham dự sự kiện, chụp ảnh và viết bài chi tiết về các gian hàng nổi bật',
  'pending',
  'medium',
  ARRAY['bo_nganh_dia_phuong', 'chuyen_trang'],
  '00000000-0000-0000-0000-000000000002',
  'phong-thuong-mai',
  '2025-10-23',
  '2025-10-28',
  0
),
(
  '10000000-0000-0000-0000-000000000003',
  'Quay video TikTok series "Khởi nghiệp Việt"',
  'Series 5 video ngắn (60s mỗi video) về các startup công nghệ Việt Nam thành công',
  'in_progress',
  'high',
  ARRAY['media', 'mang_xa_hoi'],
  '00000000-0000-0000-0000-000000000003',
  'phong-ky-thuat',
  '2025-10-15',
  '2025-10-25',
  60
),
(
  '10000000-0000-0000-0000-000000000004',
  'Tối ưu SEO cho 50 bài viết tháng 10',
  'Audit keywords, meta descriptions, internal links. Target: top 10 Google',
  'pending',
  'medium',
  ARRAY['seo'],
  '00000000-0000-0000-0000-000000000004',
  'phong-ky-thuat',
  '2025-10-24',
  '2025-10-31',
  0
),
(
  '10000000-0000-0000-0000-000000000005',
  'Phóng sự về nhà máy sản xuất ô tô điện VinFast',
  'Tham quan nhà máy, phỏng vấn lãnh đạo, quay dựng phóng sự 10 phút',
  'review',
  'high',
  ARRAY['cong_nghiep', 'media', 'chuyen_trang'],
  '00000000-0000-0000-0000-000000000001',
  'phong-cong-nghiep',
  '2025-10-10',
  '2025-10-22',
  90
),
(
  '10000000-0000-0000-0000-000000000006',
  'Bài viết chuyên mục "Doanh nghiệp tuần này"',
  'Phỏng vấn 3 doanh nghiệp nổi bật, viết bài 2000 từ',
  'completed',
  'medium',
  ARRAY['chuyen_muc'],
  '00000000-0000-0000-0000-000000000008',
  'phong-kinh-te',
  '2025-10-01',
  '2025-10-15',
  100
),
(
  '10000000-0000-0000-0000-000000000007',
  'Livestream Facebook về Hội chợ OCOP 2025',
  'Livestream 2 tiếng, giới thiệu sản phẩm OCOP từ các tỉnh thành',
  'in_progress',
  'urgent',
  ARRAY['mang_xa_hoi', 'bo_nganh_dia_phuong'],
  '00000000-0000-0000-0000-000000000027',
  'phong-quang-cao',
  '2025-10-25',
  '2025-10-25',
  30
),
(
  '10000000-0000-0000-0000-000000000008',
  'Chụp ảnh sự kiện ký kết hợp tác Bộ - Ngành',
  'Chụp ảnh chất lượng cao, chỉnh sửa và giao nhanh trong ngày',
  'pending',
  'urgent',
  ARRAY['trung_uong'],
  '00000000-0000-0000-0000-000000000051',
  'phong-anh',
  '2025-10-27',
  '2025-10-27',
  0
),
(
  '10000000-0000-0000-0000-000000000009',
  'Biên tập nội dung Ven tháng 11',
  'Review và edit 20 bài viết cho chuyên trang Ven',
  'pending',
  'low',
  ARRAY['ven'],
  '00000000-0000-0000-0000-000000000011',
  'phong-kinh-te',
  '2025-10-28',
  '2025-11-05',
  0
),
(
  '10000000-0000-0000-0000-000000000010',
  'Bài phân tích về thị trường bất động sản Q4/2025',
  'Phân tích xu hướng, dữ liệu, dự báo. Bài viết 3000 từ với biểu đồ',
  'in_progress',
  'high',
  ARRAY['bo_nganh_dia_phuong', 'chuyen_trang', 'seo'],
  '00000000-0000-0000-0000-000000000033',
  'phong-thi-truong',
  '2025-10-18',
  '2025-10-29',
  50
);

-- ========================================
-- 7. SAMPLE TASK ASSIGNMENTS
-- ========================================

-- Task 1: Phỏng vấn Bộ trưởng (assigned to 2 people)
INSERT INTO task_assignments (task_id, user_id, role, status, assigned_by) VALUES
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000008', 'assignee', 'active', '00000000-0000-0000-0000-000000000001'),
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000010', 'assignee', 'active', '00000000-0000-0000-0000-000000000001');

-- Task 3: Video TikTok (assigned to 3 people)
INSERT INTO task_assignments (task_id, user_id, role, status, assigned_by) VALUES
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000045', 'assignee', 'active', '00000000-0000-0000-0000-000000000003'),
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000046', 'assignee', 'active', '00000000-0000-0000-0000-000000000003'),
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'reviewer', 'active', '00000000-0000-0000-0000-000000000003');

-- Task 5: Phóng sự VinFast (assigned + reviewer)
INSERT INTO task_assignments (task_id, user_id, role, status, assigned_by) VALUES
('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000014', 'assignee', 'active', '00000000-0000-0000-0000-000000000001'),
('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000015', 'assignee', 'active', '00000000-0000-0000-0000-000000000001'),
('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000001', 'reviewer', 'active', '00000000-0000-0000-0000-000000000001');

-- ========================================
-- 8. SAMPLE TASK COMMENTS
-- ========================================

INSERT INTO task_comments (task_id, user_id, content, created_at) VALUES
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000008', 'Đã liên hệ được văn phòng Bộ trưởng, hẹn ngày 28/10 lúc 14h', NOW() - INTERVAL '2 days'),
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000010', 'Tôi đã chuẩn bị sẵn 15 câu hỏi, anh xem qua giúp em', NOW() - INTERVAL '1 day'),
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Câu hỏi tốt, nhớ tập trung vào chính sách xuất khẩu sang EU nhé', NOW() - INTERVAL '12 hours');

INSERT INTO task_comments (task_id, user_id, content, created_at) VALUES
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000045', 'Video 1 và 2 đã hoàn thành. Đang làm video 3.', NOW() - INTERVAL '3 days'),
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000046', 'Anh ơi, mình cần thêm footage về startup công nghệ nữa. Có nguồn nào không?', NOW() - INTERVAL '2 days'),
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 'Tốt lắm! Video rất cuốn hút. Tiếp tục như vậy nhé.', NOW() - INTERVAL '1 day');

-- ========================================
-- 9. SAMPLE SYSTEM CONFIG
-- ========================================

INSERT INTO system_config (key, value, category, description, is_public) VALUES
('ai.openai_api_key', '"sk-proj-..."', 'ai', 'OpenAI API Key', false),
('ai.default_model', '"gpt-4o-mini"', 'ai', 'Default AI model', false),
('ai.max_tokens', '4000', 'ai', 'Max tokens per request', false),
('theme.primary_color', '"#0066CC"', 'theme', 'Primary brand color (Báo Công Thương blue)', true),
('theme.secondary_color', '"#FF6B00"', 'theme', 'Secondary brand color (orange)', true),
('theme.logo_url', '"https://baocongthuong.vn/logo.png"', 'theme', 'Logo URL', true),
('notification.email_enabled', 'true', 'notification', 'Enable email notifications', false),
('notification.email_from', '"noreply@baocongthuong.vn"', 'notification', 'Email sender address', false),
('security.session_timeout', '1800', 'security', 'Session timeout in seconds (30 minutes)', false),
('security.max_login_attempts', '5', 'security', 'Max failed login attempts before lockout', false);

-- ========================================
-- 10. VERIFY DATA
-- ========================================

-- Check counts
DO $$
BEGIN
  RAISE NOTICE 'Users: %', (SELECT COUNT(*) FROM users);
  RAISE NOTICE 'Staff: %', (SELECT COUNT(*) FROM staff);
  RAISE NOTICE 'Departments: %', (SELECT COUNT(*) FROM departments);
  RAISE NOTICE 'Task Categories: %', (SELECT COUNT(*) FROM task_categories);
  RAISE NOTICE 'Tasks: %', (SELECT COUNT(*) FROM tasks);
  RAISE NOTICE 'Task Assignments: %', (SELECT COUNT(*) FROM task_assignments);
  RAISE NOTICE 'Task Comments: %', (SELECT COUNT(*) FROM task_comments);
  RAISE NOTICE 'System Config: %', (SELECT COUNT(*) FROM system_config);
END $$;

-- Expected output:
-- Users: 80
-- Staff: 80
-- Departments: 13
-- Task Categories: 8
-- Tasks: 10
-- Task Assignments: 8
-- Task Comments: 6
-- System Config: 10

-- ========================================
-- END OF SAMPLE DATA
-- ========================================

-- NOTES FOR BACKEND TEAM:
-- 1. Replace '$2b$10$YourBcryptHashHere' with actual bcrypt hashes
-- 2. admin password: dunghoi123
-- 3. all staff password: btc2025
-- 4. Complete the remaining staff entries (only showed examples for brevity)
-- 5. Update department leaders after all staff inserted
-- 6. Add more sample tasks as needed
-- 7. Configure real OpenAI API key in system_config
