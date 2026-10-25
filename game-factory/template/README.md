# Game Template — khung game 3D chạy được ngay

Template rút ra từ **K Team: Robot Arena 3D** (v1.3 "Echo") — toàn bộ hệ bắt
buộc đã có sẵn, chỉ việc thay nội dung game.

## Chạy thử
```bash
python3 -m http.server 8765 --directory .
# mở http://localhost:8765/ — bấm Bắt đầu là chơi được
```

## Đã có sẵn trong template (đừng xóa khi làm game mới)
- Menu + HUD + pause + màn hình kết thúc, kỷ lục lưu localStorage
- **Âm thanh iOS-safe:** mở khóa mọi cử chỉ + phiên playback qua mặt công
  tắc im lặng (iOS 17+) + nút "Kiểm tra tiếng" + dòng trạng thái + nút mute
- **Chất lượng 3 nấc** (Cao/Trung bình/Thấp) + chế độ Tự động tự hạ khi FPS < 45
- **Luật hiệu năng:** đạn dùng vật liệu phát sáng không đèn (không PointLight
  theo đạn), va chạm đạn bằng phép thử đoạn thẳng, dt kẹp 0.05, HUD chỉ
  ghi DOM khi số đổi, buffer tiếng nổ dùng chung
- **Debug hooks:** `window.KTEAM` + `?autotest=1` + `?touch=1` để test tự động
- Điều khiển: WASD + chuột (pointer lock) trên desktop, joystick ảo + nút
  bắn trên mobile

## Bắt đầu game mới (3 bước)
1. Copy cả thư mục này thành thư mục game mới.
2. Đổi 3 chỗ trong `index.html`: `GAME TITLE`, `SAVE_PREFIX` (slug riêng,
   vd `robot-arena` — mọi key localStorage ăn theo nó, không được trùng
   game cũ), và `VERSION_NAME` cho bản đầu tiên.
3. Thay phần ENTITIES + FLOW bằng luật chơi của game mới, giữ nguyên
   phần AUDIO, QUALITY, DEBUG HOOKS và LOOP.

## Đóng version
Xem playbook `../PLAYBOOK.md` (bản đầy đủ trong thư mục game-factory): bump 2 hằng số →
VERSIONS.md → README → smoke test → commit → tag → push → verify live
→ zip backup. Tag đã publish thì không bao giờ sửa.
