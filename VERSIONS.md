# Lịch sử phiên bản — K Team Robot Arena 3D

Mỗi phiên bản được gắn tag Git (`git tag`) để truy vết đúng code đã phát hành.
Chơi bản mới nhất tại: https://vanhiennguyen-work.github.io/k-team-robot-arena/

Mỗi phiên bản còn có **1 tên mã (codename)** đặt theo kiểu các AI đặt tên cho model của mình: 1 từ tiếng Anh gợi đúng điểm nhấn của bản đó (vd: `Forge`, `Tempest`, `Velocity`). Tên mã hiển thị trong game ở menu, cùng với số version và tag Git. Version mới chỉ cần đổi 2 hằng số `GAME_VERSION` + `VERSION_NAME` trong `index.html` và thêm 1 mục mới vào file này.

## v1.0 — Forge · "Shop & Pet" (23/10/2026) — tag: `v1.0`

Phiên bản ổn định đầu tiên, đóng gói toàn bộ tính năng đã hoàn thiện trong ngày 23/10:

- **Gameplay gốc:** FPS nhập vai Rubi, wave vô hạn, Boss "Titan Nổi Loạn" mỗi 5 wave, combo x5, dash, pickup hồi máu, nâng cấp giữa wave.
- **Tâm Tự Động:** tự bám mục tiêu (điểm số chọn mục tiêu + lọc điểm ngắm 3D), FOV 100° desktop / 120° mobile, chống rung khi gặp Boss.
- **Cửa hàng:** điểm tích lũy vĩnh viễn, 5 vũ khí + 5 trang bị; súng FPS đổi hình theo vũ khí, trang bị hiện trên model Rubi và HUD.
- **Pet:** 10 pet từ vũ trụ mascot (Mochi, RAI, Mèo Mun, 7 Robo K Team), quay cuối ván theo điểm ván trước; pet làm mồi nhử có máu riêng, bắn tia hỗ trợ, mỗi pet có chỉ số ATK / DEF / Sức lực riêng.
- **Màn nâng cấp:** 3 thẻ 1 hàng ở phía trên màn hình, icon SVG theo nội dung, gợi ý theo bối cảnh (wave/BOSS/máu/súng/pet), khóa chọn 0,6s đầu chống chọn nhầm nút bắn.

## v1.1 — Tempest · "Âm thanh, vũ khí cao cấp, kĩ năng pet & địa hình mới" (25/10/2026) — tag: `v1.1`

- **Âm thanh:** bộ hiệu ứng âm thanh WebAudio cho từng hành động (bắn theo từng loại súng, trúng đòn, nhặt đồ, dash, Boss, kĩ năng pet, mua đồ, thắng wave, thua trận) + nút bật/tắt nhanh 🔊/🔇 ở góc trên màn hình game, nhớ lựa chọn qua các phiên chơi.
- **Vũ khí cao cấp:** +4 súng mới — Laze Lượng Tử (đạn xuyên), Sấm Sét Lan (sét lan sang địch gần), Minigun Hạt (3 tia/tốc độ cao), Băng Đóng Lạnh (làm chậm địch) — cùng súng vẽ chi tiết hơn (ống ngắm, băng đạn, nòng phụ, lõi phát sáng).
- **Kĩ năng pet:** mỗi pet có 1 kĩ năng chủ động riêng dùng trong trận (vd: RAI bắn Tia Trí Tuệ, Mèo Mun Vồ Nhanh, Robo Cứu Hỏa tung Vòng Lửa, Robo Siêu Anh Hùng Đấm Sóng Xung Kích) với hiệu ứng nhìn thấy được.
- **Địa hình:** đấu trường chia 4 vùng đất (cỏ / cát / băng / núi lửa) với chướng ngại vật nhiều loại (đá, tinh thể, thùng, trụ năng lượng, cây), đài kỷ niệm K ở trung tâm và chi tiết trang trí.

## v1.2 — Velocity · "Ổn định & mượt mà" (25/10/2026) — tag: `v1.2`

Bản ổn định: không thêm tính năng chơi mới mà tập trung làm game đẹp hơn và hết giật trên máy yếu — toàn bộ thay đổi từ sau v1.1:

- **Đồ họa toon:** nhân vật tô màu mảng hoạt hình 4 nấc + viền đen, thân có chi tiết panel/ốc vít/vết xước vẽ bằng code, hộp bo tròn góc, đèn môi trường làm mềm vùng tối — giữ nguyên phong cách sticker của Rubi, game vẫn chạy offline nhẹ.
- **Nhân vật sống động hơn:** địch chạy nhún nhảy squash & stretch, mắt mở to khi trúng đòn, chết đổ ngửa rồi mới vỡ tung (pet không bắn vào xác), Rubi thở phập phồng ở menu, súng nghiêng khi dash.
- **Chất lượng 3 nấc + tự động:** nút ⚙️ Chất lượng ở menu (Tự động / Cao / Trung bình / Thấp, nhớ lựa chọn); chế độ Tự động đo FPS mỗi 2,5s, dưới 45 FPS thì hạ nấc, dưới 25 FPS nhảy thẳng xuống Thấp. Nấc Thấp tắt bóng/viền/đèn trang trí và giảm hạt để cứu máy yếu.
- **Hết đơ khi bắn liên thanh + đông địch + Boss:** bỏ đèn gắn theo từng viên đạn (từng là thủ phạm chính làm GPU sập khung hình), va chạm đạn đổi sang phép thử đoạn thẳng (không còn vòng lặp nặng thêm khi lag), HUD chỉ ghi DOM khi số đổi, tiếng nổ dùng chung 1 bộ nhớ âm thanh, trần 140 viên đạn. Đo stress giống hệt trước/sau: tốc độ game tăng ~2,4 lần, số đèn 35 → 14.
