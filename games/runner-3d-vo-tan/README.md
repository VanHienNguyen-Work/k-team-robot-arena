# Runner 3D Vô Tận 🏃

- Slug: `runner-3d-vo-tan` · Version: v0.1 "Sprint" · Nguồn: game-factory/template
- Chơi: `python3 -m http.server 8765 --directory .` rồi mở http://localhost:8765/
- Cách chơi: robot đỏ chạy mãi không dừng. ← → (hoặc vuốt ngang) chuyển
  làn, ↑ (vuốt lên) nhảy qua rào thấp cam, ↓ (vuốt xuống) trượt qua
  thanh cao tím, né khối đỏ kín làn, nhặt xu vàng (+25 điểm). Tốc độ
  tăng dần theo thời gian, điểm = quãng đường + xu.
- Hệ dùng chung từ factory (giữ nguyên khi nâng cấp): audio iOS-safe,
  quality 3 nấc, KTEAM hooks + `?autotest=1` (autopilot tự né).
- Đóng version: xem checklist trong `../game-factory/PLAYBOOK.md` mục 6.
  Tag đã publish không sửa.
