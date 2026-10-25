# Registry — mọi game làm từ factory

Một dòng cho một game. Slug là duy nhất và không bao giờ đổi sau khi tạo
(vì nó là thư mục + key localStorage). Script `new-game.sh` tự thêm dòng
mới và từ chối slug trùng.

| # | Slug | Tên game | Version hiện tại | Trạng thái | Thư mục |
|---|---|---|---|---|---|
| 001 | `k-team-robot-arena` | K Team: Robot Arena 3D | v1.3 "Echo" | ✅ Live | (repo root — game gốc, factory rút ra từ đây) |
<!-- NEW-GAMES -->
