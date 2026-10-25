# 🏭 Game Factory — làm hàng trăm game từ một khuôn

Factory này rút ra từ **K Team: Robot Arena 3D** (v1.3 "Echo") — game đầu
tiên đã chứng minh toàn bộ quy trình chạy được trên máy thật. Mọi game
sau đều bắt đầu từ đây, không làm lại từ đầu.

## Tạo game mới: 1 lệnh

```bash
bash game-factory/scripts/new-game.sh <slug> "Tên Game" [Tên mã]
# vd: bash game-factory/scripts/new-game.sh robot-dua-xe "Robot Đua Xe" Turbo
```

Script làm 4 việc, và từ chối nếu slug trùng:
1. Copy `template/` thành `games/<slug>/` (game mới đứng độc lập).
2. Thay tên game, `SAVE_PREFIX` = slug, tên mã version đầu tiên.
3. Viết README riêng cho game + file `.factory` ghi nguồn template.
4. Thêm 1 dòng vào `GAMES.md` (registry).

Sau đó chỉ việc sửa phần ENTITIES + FLOW trong `index.html` của game
mới — phần AUDIO, QUALITY, DEBUG HOOKS, LOOP giữ nguyên.

## Vì sao làm được hàng trăm game

- **Độc lập tuyệt đối:** mỗi game là 1 thư mục tự chạy (không import
  chéo, không dependency chung). Hỏng 1 game không lan sang game khác.
- **Slug duy nhất:** thư mục + key localStorage + registry cùng 1 slug,
  script chặn trùng ngay lúc tạo — không bao giờ có 2 game đè save nhau.
- **Test chung:** `scripts/smoke.mjs` nhận URL bất kỳ, kiểm tra version
  line, KTEAM hooks, nút Kiểm tra tiếng, vào trận, 0 exception — cùng
  1 script cho game thứ 1 hay game thứ 100.
- **Release chung:** mọi game theo cùng checklist đóng version trong
  `PLAYBOOK.md` mục 6 (bump 2 hằng số → VERSIONS.md → smoke → commit
  → tag → verify live). Tag đã publish không bao giờ sửa.
- **Registry:** `GAMES.md` là danh mục duy nhất — nhìn vào là biết có
  bao nhiêu game, game nào đang ở version nào, game nào live.

## Cấu trúc

```
game-factory/
  README.md          ← file này: cách tạo + luật mở rộng
  PLAYBOOK.md        ← quy trình đầy đủ: 6 giai đoạn, 8 hệ bắt buộc,
                       luật hiệu năng, bài học xương máu
  GAMES.md           ← registry mọi game (001 = K Team, game gốc)
  template/          ← khung game chạy được (v0.1 "Seed")
    index.html       ← menu/HUD/wave/bắn/kỷ lục + audio iOS-safe
                        + quality 3 nấc + KTEAM hooks
    lib/three.module.min.js  ← Three.js r160, offline
    README.md / VERSIONS.md
  scripts/
    new-game.sh      ← tạo game mới (1 lệnh)
    smoke.mjs        ← smoke test chung cho mọi game
games/
  README.md          ← nơi ở của các game mới (mỗi game 1 thư mục)
```

## Nâng cấp factory (khi template cần thêm hệ mới)

1. Sửa `template/` + ghi vào `PLAYBOOK.md` + bump version template
   trong file `.factory` của các game (không bắt buộc áp ngược).
2. Game cũ không tự động nhận hệ mới — đó là chủ đích: game đã live
   thì ổn định, game mới hưởng template mới. Muốn áp ngược thì cherry-pick
   thủ công từng hệ, test lại rồi đóng version mới cho game đó.
3. Không bao giờ sửa trực tiếp game trong `games/` từ factory — mỗi
   game có vòng đời riêng (branch/commit/tag của nó).
