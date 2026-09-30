# 🏎️ DREAM CAR COLLECTION HUB - BỘ SƯU TẬP XE MƠ ƯỚC V1.0

Script hỗ trợ tự động hóa toàn diện cho tựa game **[💭] Bộ sưu tập xe mơ ước (Dream Car Collection)** trên Roblox, phát triển bởi nhóm **F Students = Inventors**.

Tương thích mượt mà 100% cho **Delta Executor (Android & PC)**, Codex, Wave, Hydrogen, Fluxus và Solara.

---

## 🚀 Cách Sử Dụng (Script Execution Command)

Chỉ cần sao chép lệnh loader bên dưới và dán vào Executor của bạn (Delta / Codex / Wave / Fluxus):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/cars/main/loader.lua"))()
```

Hoặc nạp trực tiếp file script chính:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/cars/main/script.lua"))()
```

---

## 🌟 Tổng Quan Tính Năng Chính

| Nhóm Tính Năng | Mô Tả Chi Tiết |
|---|---|
| 📦 **Auto Crate / Hatch** | Mở rương tự động (Lucky Crate, Cosmic Crate), bỏ qua hoạt ảnh mở rương (Fast Hatch), tự động lọc bán hoặc xóa xe độ hiếm thấp (Common, Uncommon, Rare) để giữ chỗ cho siêu xe. |
| 🏎️ **Auto Economy** | Tự động hút toàn bộ tiền tích lũy trong Showroom/Garage (Showroom Cash Vacuum), tự động trang bị các xe tạo thu nhập cao nhất (Equip Best), tự động mua nâng cấp Garage khi đủ tiền. |
| 🔄 **Auto Progression** | Tự động Tái sinh (Rebirth) ngay khi đạt điều kiện mở khóa x2/x3 thu nhập vĩnh viễn; tự nhận thưởng Nhiệm vụ hằng ngày, Quà online theo mốc giờ và Ngọc thưởng Bộ sưu tập (Car Index Gems). |
| 🚿 **Auto Car Wash ASMR** | Tự động đưa xe vào khu vực rửa xe kiếm thêm tiền mặt và điểm kinh nghiệm liên tục. |
| 🎁 **Auto Redeem Codes** | Tự động kiểm tra và nhập toàn bộ Giftcode tân thủ & sự kiện (`100XHATCH`, `RELEASE`, `LARP`, `DISCORDWELCOME`). |
| ⚡ **Tiện Ích & Tối Ưu** | Tích hợp chống ngắt kết nối 24/7 (Anti-AFK), bộ tăng tốc đồ họa (FPS Booster 60 FPS cho máy yếu và Android), tùy chỉnh tốc độ di chuyển (WalkSpeed Boost). |

---

## 🛠️ Chi Tiết Các Mô-đun Hệ Thống

### 1. 📦 Mở Hộp & Quản Lý Xe (Auto Crate & Hatch)
* **Lựa chọn loại Crate**: Hỗ trợ mở **Lucky Crate**, **Cosmic Crate** hoặc **Tất cả các rương**.
* **Bỏ qua hoạt ảnh (Fast Hatch / Skip Animation)**: Rút ngắn thời gian mở hộp về mức tối thiểu, gia tăng tốc độ nhận xe gấp 5 lần.
* **Auto Bán / Xóa Xe Rác**: Tự động dọn kho với các xe độ hiếm thấp (`Common`, `Uncommon`, `Rare`), giữ an toàn tuyệt đối cho các dòng xe cao cấp (`Epic`, `Legendary`, `Mythic`, `Exotic`).

### 2. 🏎️ Kinh Tế & Showroom (Auto Economy)
* **Showroom Cash Vacuum**: Quét toàn bộ tiền mặt sinh ra từ các xe đang trưng bày trong Showroom của bạn và tự động gom về túi ngay lập tức.
* **Auto Equip Best**: Tự động đánh giá chỉ số tạo tiền của toàn bộ xe trong bộ sưu tập và chọn ra dàn xe mạnh nhất đưa vào trưng bày.
* **Auto Nâng Cấp Garage**: Tự động mở rộng số lượng chỗ để xe và mở khóa tầng mới khi tích đủ số dư.

### 3. 🔄 Tiến Trình & Nhận Quà (Auto Progression)
* **Auto Rebirth**: Tự động tái sinh khi nhân vật đạt mốc quy định để nhận thêm hệ số nhân tiền (Multiplier) và các đặc quyền cấp cao.
* **Auto Claim Quests & Daily Rewards**: Tự động ấn nhận tất cả các phần thưởng nhiệm vụ và mốc quà online theo thời gian.
* **Auto Index Gems**: Nhận ngọc thưởng tức thì khi mở khóa bất kỳ mẫu xe mới nào trong bách khoa toàn thư xe.

### 4. 🚿 Trạm Xịt Rửa Xe (Auto Car Wash)
* Tự động tương tác với vòi xịt rửa xe ASMR, dọn dẹp bùn đất bám trên thân xe để nhận tiền thưởng phụ trội và điểm kinh nghiệm cày cấp.

### 5. 🎁 Tự Động Nhập Giftcode (Auto Redeem Codes)
* Tự động quét bảng nhập code và điền các mã code quà tặng đang hoạt động:
  * `100XHATCH`
  * `RELEASE`
  * `LARP`
  * `DISCORDWELCOME`

### 6. ⚡ Tiện Ích & Giảm Lag (Utilities & Performance)
* **Anti-AFK 24/7**: Tự động bắt sự kiện `LocalPlayer.Idled` và mô phỏng tín hiệu giữ kết nối, giúp treo máy xuyên đêm không lo bị ngắt kết nối sau 20 phút.
* **FPS Booster**: Giảm tải hiệu ứng ánh sáng (Shadows, Blur, SunRays, Bloom) và tinh chỉnh bộ đệm đồ họa, giữ khung hình ổn định 60 FPS mượt mà cho điện thoại Android chạy Delta Executor.
* **Tăng tốc chạy (Speed Boost)**: Di chuyển linh hoạt giữa các khu vực trong Showroom và trạm rửa xe.

---

## 🎨 Giao Diện Hiện Đại & Thân Thiện

* Thiết kế theo phong cách **Cyber Neon Red & Carbon Dark** lấy cảm hứng từ bảng điều khiển siêu xe.
* Tích hợp **Nút Tròn Thu Nhỏ (Floating Button 🏎️)**: Tiện lợi khi thao tác trên màn hình cảm ứng điện thoại, dễ dàng ẩn hoặc hiện bảng điều khiển chỉ với 1 chạm.
* Thanh trạng thái hiển thị thời gian thực (Live Status Bar) cập nhật thông tin kiếm tiền và số xe đã mở.

---

## 🌐 Thông Tin Repository
* **GitHub Repository**: `https://github.com/khahuynh963/cars.git`
* **Tác giả**: `khahuynh963`
