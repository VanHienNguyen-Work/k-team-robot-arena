# Cách làm game — Playbook rút ra từ K Team: Robot Arena 3D

> Tài liệu này đóng gói toàn bộ cách làm đã kiểm chứng qua game đầu tiên
> (v1.0 → v1.3 "Echo", 23–25/10/2026) thành quy trình dùng lại cho mọi
> game sau. Kèm theo là `game-template.zip`: khung game chạy được ngay,
> đã chứa sẵn mọi hệ bắt buộc dưới đây.

## 1. Triết lý (5 điều không đổi)

1. **Một file, chạy offline.** Toàn bộ game nằm trong `index.html` duy
   nhất (~2.000 dòng ở game thật, ~700 dòng ở template), thư viện Three.js
   vendored vào `lib/` — không CDN, không build step, không đợi mạng.
2. **Chơi được càng sớm càng tốt.** Bản đầu tiên chỉ cần: menu → bấm
   bắt đầu → di chuyển → bắn → chết → chơi lại. Mọi hệ "hay" (shop, pet,
   nâng cấp) chỉ thêm sau khi gameplay lõi đã vui.
3. **Người chơi phản hồi, mình sửa, test lại ngay.** Mỗi vòng phản hồi
   là 1 commit nhỏ, có đo đạc trước/sau (không sửa theo cảm giác).
4. **Máy yếu cũng phải chơi được.** Mọi quyết định hiệu năng đều nằm
   trong mục 4, không phải việc "tối ưu sau".
5. **Version nào cũng khóa được.** Bất cứ lúc nào cũng có thể đóng
   version ổn định trong 10 phút theo mục 6.

## 2. Quy trình 6 giai đoạn

| Giai đoạn | Làm gì | Xong khi nào |
|---|---|---|
| 1. Chốt concept | Thể loại, nhân vật, vòng lặp chơi cốt lõi (30 giây đầu người chơi làm gì?), nền tảng (mobile-first hay desktop) | Viết được 1 đoạn mô tả, đặt được tên + slug game |
| 2. Khung chơi được | Từ template: đổi tên, slug, nhân vật; 1 loại địch, 1 vũ khí, 1 điều kiện thua | Chơi trọn 1 trận trên máy thật (không chỉ VM) |
| 3. Vòng lặp feedback | Mỗi phản hồi → sửa → test lại → báo kết quả có số đo | Người chơi không còn phàn nàn về cùng 1 điểm 2 lần |
| 4. Hệ meta | Shop, pet, nâng cấp giữa wave, lưu trữ vĩnh viễn — chỉ khi lõi đã vui | Hệ nào cũng có test riêng, không phá save cũ |
| 5. Hiệu năng + âm thanh + mobile | Quality 3 nấc, audio iOS-safe, điều khiển cảm ứng, auto-aim | Stress test đạt, máy thật có tiếng, mobile chơi được |
| 6. Đóng version | Theo checklist mục 6 | Tag đã push, bản live khớp byte với local |

## 3. Kiến trúc chuẩn (thứ tự trong `index.html`)

1. **Version** — 2 hằng số `GAME_VERSION`, `VERSION_NAME` (mục 6).
2. **Audio** — nguyên khối, không rút gọn (mục 4.3).
3. **Quality** — 3 nấc + tự hạ (mục 4.2).
4. **World** — scene, ánh sáng, đất, chướng ngại vật.
5. **Entities** — địch, đạn, hiệu ứng (phần này là "game", thay theo
   từng game mới).
6. **Flow** — start/wave/game-over/pause.
7. **Loop** — `requestAnimationFrame`, dt kẹp, HUD change-guarded.
8. **Debug hooks** — `window.KTEAM` + `?autotest=1` + `?touch=1`.

## 4. Tám hệ bắt buộc (đã có sẵn trong template)

### 4.1 Menu + version line
Menu hiển thị: tên game, nút Bắt đầu, nút Chất lượng, nút Kiểm tra
tiếng, dòng trạng thái âm thanh, và dòng version dạng:
`Phiên bản v1.3 "Echo" · Tag Git: v1.3`. Người chơi luôn biết mình đang
chơi bản nào — mọi báo lỗi sau đó đều đối chiếu được với tag.

### 4.2 Quality 3 nấc + tự hạ
- **Cao:** DPR ≤ 2, bóng đổ 2048, đủ hiệu ứng. **Trung bình:** DPR 1.5,
  bóng 1024, bớt hiệu ứng. **Thấp:** DPR 1, tắt bóng, tắt hiệu ứng phụ.
- Chế độ **Tự động** (mặc định): đo FPS mỗi 2,5s; < 45 thì hạ 1 nấc +
  toast báo; **chỉ hạ, không bao giờ tự tăng lại** (tránh dao động).
- Lưu lựa chọn vào localStorage (`<slug>-quality`). Antialias không
  đổi được sau khi tạo WebGL context — đừng hứa với người chơi điều này.

### 4.3 Âm thanh iOS-safe (bài học đắt nhất)
Âm thanh game dùng Web Audio API (`beep` + `noiseBurst`). iOS có **hai
lớp khóa độc lập**, thiếu 1 lớp là câm:
- **Lớp 1 — khóa autoplay:** iOS chỉ cho AudioContext chạy khi mở khóa
  trong cử chỉ thật. Cách sửa: `unlockAudio()` gắn vào mọi
  `pointerdown`/`touchstart`/`keydown`, phát 1 node câm trong cử chỉ.
  Chỉ gọi `resume()` ngoài cử chỉ thì vô dụng.
- **Lớp 2 — công tắc im lặng:** WebAudio chạy kênh ambient nên công tắc
  bên hông iPhone giết tiếng hoàn toàn, còn `resume()` không qua mặt
  được. Từ iOS 17, API chính thức `navigator.audioSession.type =
  'playback'` chuyển sang kênh playback. Đặt nó lúc khởi động và trong
  mọi cử chỉ, bọc try/catch cho iOS cũ (iOS cũ không có API → cách duy
  nhất là gạt công tắc sang chế độ chuông).
- **Chẩn đoán:** nút "Kiểm tra tiếng" phát chuỗi tiếng to/dài + dòng
  trạng thái (state/muted/phiên). Vào trận mà đang tắt tiếng thì toast
  báo rõ. Nút mute lưu `<slug>-muted`.

### 4.4 Save — schema có version, không bao giờ phá
- Key theo slug: `<slug>-save-v1`, `<slug>-best`, `<slug>-quality`,
  `<slug>-muted`, `<slug>-autoaim`. Đổi game là đổi slug, không dùng
  chung key với game cũ.
- Hậu tố `-v1` là version schema: khi đổi cấu trúc save, bump lên
  `-v2` kèm code migrate, không bao giờ ghi đè format cũ trong im lặng.
- Mọi đọc/ghi localStorage bọc try/catch (chế độ ẩn danh có thể chặn).

### 4.5 HUD change-guarded
HUD chỉ ghi DOM khi giá trị đổi. Ghi 8 field mỗi frame nghe thì vô
hại, nhưng đúng lúc boss + đông địch nó thành 1 trong các thủ phạm
giật (đã đo trong game thật).

### 4.6 Luật hiệu năng (đo được, không đoán)
- **Không đèn theo đạn:** mỗi viên đạn 1 PointLight từng làm GPU sập
  khung hình khi bắn liên thanh (đo: 35 đèn → 14 đèn, tốc độ game tăng
  ~2,4 lần sau khi bỏ). Đạn dùng vật liệu unlit phát sáng, nhìn y hệt.
- **Va chạm đạn bằng phép thử đoạn thẳng:** đo khoảng cách từ tâm địch
  tới đoạn đường đạn đi trong 1 frame, 1 phép thử/địch/viên/frame — chi
  phí không phụ thuộc dt. Cách cũ (chia nhỏ bước theo dt) sinh vòng
  xoắn: lag → dt lớn → nhiều bước → càng lag.
- **dt kẹp 0.05, trần đạn 140, vật liệu đạn dùng chung, buffer tiếng
  nổ dùng chung 1 cái, hạt dùng chung vật liệu theo màu.**
- **Stress probe chuẩn:** 3 viên/60ms + 25 địch + boss, quality khóa
  Cao, đo tốc độ game + số đèn + exception trước/sau mỗi lần sửa.

### 4.7 Mobile + auto-aim
- Joystick ảo trái, nút bắn/phải; `?touch=1` ép chế độ mobile để test
  trên desktop.
- Auto-aim bật mặc định, có nút tắt: chọn mục tiêu theo điểm số
  (khoảng cách + góc lệch + ưu tiên boss + bám mục tiêu cũ), chuyển
  mục tiêu cần chênh lệch rõ + cooldown, điểm ngắm lọc mượt — không
  dí thẳng vào mục tiêu (gây rung khi boss di chuyển nhanh).

### 4.8 Debug hooks + test tự động
- `window.KTEAM` expose: scene, state, player, enemies, bullets, các
  hàm spawn/start/quality/audio, và getter `muted`/`audioState`.
- `?autotest=1`: tự chơi, spawn địch xác định, ghi `window.__AUTOTEST__`
  + đổi title khi xong — để script CDP đọc kết quả mà không cần nhìn.
- Lưu ý: biến module-scope (như `THREE`, hàm nội bộ) không gọi được
  từ `Runtime.evaluate` — mọi thứ cần test phải qua KTEAM hoặc click
  nút thật. Click giả lập bằng evaluate không tính là cử chỉ tin cậy
  nên không mở khóa được audio — muốn test audio phải dùng CDP
  `Input.dispatchMouseEvent` thật.
- Headless Chrome trên VM chạy game-time chỉ ~0,35× thời gian thật
  (tụt tới 0,05× khi stress) — test cần chờ dài, đừng kết luận vội.

## 5. Hạ tầng kiểm chứng (giữ nguyên cho game sau)

- **Smoke test trước mọi lần push:** syntax check (tách script module
  → `node --check`), load menu, đọc version line, bấm Kiểm tra tiếng,
  bấm Bắt đầu, 0 exception.
- **Test theo hệ:** mỗi hệ lớn (shop, pet, skill, nâng cấp, đồ họa,
  hiệu năng) có 1 script CDP riêng, chạy xong mới merge.
- **Verify live:** sau khi Pages build xong, tải bản live về so byte
  với local — khớp mới báo xong. **Safari giữ cache ~10 phút** sau mỗi
  lần deploy: dặn người chơi đóng hẳn tab rồi mở lại nếu chưa thấy
  bản mới.
- **Backup:** mỗi lần ship regenerate file zip (trừ `.git`) vào
  `your_files/`.

## 6. Quy trình đóng version (checklist)

1. Đổi `GAME_VERSION` (vX.Y) + `VERSION_NAME` (1 từ tiếng Anh kiểu
   model AI, gợi đúng điểm nhấn của bản — vd: Forge, Tempest, Velocity,
   Echo).
2. Thêm mục vào `VERSIONS.md` (ngày, tag, thay đổi chính, số đo nếu có).
3. Cập nhật dòng version trong `README.md`.
4. Chạy smoke test, 0 exception.
5. Commit + tag annotated (`git tag -a vX.Y`) + push cả commit lẫn tag.
6. Chờ Pages `built`, tải bản live so byte với local.
7. Regenerate zip backup, cập nhật memory.
8. **Tag đã publish thì không bao giờ sửa hay dời** — có lỗi thì đóng
   version mới, không vá tag cũ.

## 7. Bắt đầu game mới (3 bước)

1. Copy `game-template.zip` thành thư mục game mới.
2. Đổi `GAME TITLE`, `SAVE_PREFIX` (slug riêng), `VERSION_NAME` bản
   đầu tiên.
3. Thay phần ENTITIES + FLOW bằng luật chơi mới, giữ nguyên AUDIO,
   QUALITY, DEBUG HOOKS, LOOP. Chơi trọn 1 trận trên máy thật trước khi
   thêm bất kỳ hệ meta nào.

## 8. Lịch sử version của game mẫu (để đối chiếu)

- **v1.0 "Forge"** (23/10/2026): gameplay, shop, pet.
- **v1.1 "Tempest"** (25/10/2026): âm thanh, vũ khí cao cấp, skill pet,
  địa hình 4 vùng.
- **v1.2 "Velocity"** (25/10/2026): đồ họa toon, quality 3 nấc, sửa đơ
  bắn liên thanh + boss.
- **v1.3 "Echo"** (25/10/2026): hệ tên mã version, sửa câm tiếng iOS
  (unlock mọi cử chỉ + phiên playback + nút Kiểm tra tiếng).
