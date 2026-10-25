# K TEAM — Robot Arena 3D 🤖⚡

Game 3D arena shooter **góc nhìn thứ nhất (FPS)** chạy ngay trên trình duyệt: điều khiển **Rubi** — robot đỏ tươi của **K Team** — sống sót qua từng wave robot nổi loạn, chọn nâng cấp giữa các wave và hạ **Boss mỗi 5 wave**.

![genre](https://img.shields.io/badge/genre-3D%20arena%20shooter-e8212f) ![tech](https://img.shields.io/badge/tech-Three.js%20%2B%20WebGL-37e0ff) ![build](https://img.shields.io/badge/build-kh%C3%B4ng%20c%E1%BA%A7n-ffc21c)

## Hình ảnh thực tế (chụp từ bản chạy thật)

![Menu chính](screenshots/menu.png)
![Gameplay — Rubi giữa đấu trường, HUD, combo](screenshots/gameplay.png)
![Gameplay mobile — shoulder-cam lệch tâm, camera tự bám, joystick + nút bắn](screenshots/gameplay-mobile.png)

## Chơi ngay

**▶ Chơi trực tiếp trên trình duyệt (GitHub Pages): https://vanhiennguyen-work.github.io/k-team-robot-arena/**

Hoặc chạy local — không cần cài đặt, không cần build, chỉ cần một static server:

```bash
# cách 1
python3 -m http.server 8080
# cách 2
npx serve .
```

Mở `http://localhost:8080` và bấm **Vào đấu trường**.

> Thư viện Three.js (MIT) được đóng gói sẵn trong `lib/` — game chạy **offline 100%**, không phụ thuộc CDN.

## Phiên bản

- **v1.1 hiện tại** (tag Git `v1.1`): âm thanh phong phú + nút tắt tiếng góc trên, 9 vũ khí (thêm Laze xuyên, Sấm Sét lan, Minigun 3 tia, Băng làm chậm), mỗi pet 1 kĩ năng chủ động, đấu trường 4 vùng đất. Chi tiết từng version xem [`VERSIONS.md`](VERSIONS.md).
- **v1.0** (tag Git `v1.0`): bản ổn định đầu tiên — shop, pet, màn nâng cấp 1 hàng.

## Cửa hàng & Pet (bản nâng cấp)

- **Điểm tích lũy:** điểm mỗi ván cộng thành tiền tệ vĩnh viễn khi ván kết thúc — vào **🛒 Cửa hàng** (từ menu hoặc màn hình kết thúc) để mua đồ.
- **5 vũ khí:** Blaster Rubi (mặc định) · Song Tia Lửa (2 tia) · Pháo Plasma · Bão Lửa Liên Thanh · Cannon Hoàng Kim (nổ diện rộng). Đổi vũ khí là **súng góc nhìn thứ nhất đổi hình thật** (nòng, màu đạn, tốc độ bắn đều khác).
- **5 trang bị:** Giáp Hợp Kim (+50 máu) · Găng Tia Lửa (+15% tốc độ bắn) · Giày Tốc Độ · Kính Ngắm AI (tầm khóa 62) · Lõi Năng Lượng (+20% dmg) — mua 1 lần dùng mãi và **hiện trên người Rubi** (khiên vàng, kính ngắm, lõi sáng...).
- **10 pet từ vũ trụ mascot của Ryan:** Mochi · Robo Nông Dân · Robo Đầu Bếp · RAI · Robo Y Tế · Robo Cứu Hỏa · Robo Hải Tặc · Mèo Mun · Robo Phi Hành · Robo Siêu Anh Hùng. Sau mỗi ván, game **quay pet cho ván sau dựa trên điểm ván vừa chơi** (điểm càng cao tỉ lệ Epic càng lớn: 0đ ≈ 18% → 4000đ ≈ 58%). Pet tự chạy theo chủ, **làm chim mồi dụ quái đuổi theo mình**, bắn tia hỗ trợ và mỗi bé có một perk riêng (Mochi hồi máu, Hải Tặc +10% điểm, Siêu Anh Hùng mồi nhử mạnh nhất...). Pet ngã sẽ hồi sinh ở wave kế tiếp.
- **Chỉ số riêng từng pet:** ⚔️ Tấn công (sát thương + tốc độ ra đòn) · 🛡️ Phòng thủ (% giảm sát thương nhận vào — Siêu Anh Hùng 35%) · ❤️ Sức lực (máu tối đa 60–130) — xem trong menu, cửa hàng (thanh chỉ số) và HUD trong trận.
- **Màn chọn nâng cấp giữa wave:** 3 thẻ trên 1 hàng ở phía trên màn hình (tránh vùng nút bắn), icon vẽ theo nội dung, có ⭐ gợi ý theo bối cảnh (wave/boss/máu/súng/pet) và khóa chọn 0,6s đầu chống chọn nhầm.

## Cách chơi

| Điều khiển | Hành động |
|---|---|
| `W A S D` | Di chuyển theo hướng camera |
| Chuột | Xoay camera / ngắm (click vào game để khoá chuột) |
| Giữ chuột trái | Bắn liên thanh |
| `Shift` | Dash — lướt né đòn, bất tử trong chớp mắt |
| `P` / `Esc` | Tạm dừng |
| `1` `2` `3` | Chọn nâng cấp giữa wave |
| `T` / nút 🎯 trên HUD | Bật/tắt **chế độ tâm bắn tự động**: tâm tự bám theo địch gần nhất (cả hướng ngang + độ ngẩng), tâm chuyển vàng + hiện nhãn ĐANG KHÓA khi bám; tự ngắm bằng chuột/vuốt thì chế độ tạm nhường rồi bám lại |

> **Độ ổn định camera (thuật toán bám v2):** mục tiêu được chọn bằng điểm số (khoảng cách + độ lệch khỏi tâm hiện tại + ưu tiên Boss + điểm dính), đổi mục tiêu có cooldown 0,7s; góc quay suy ra từ **điểm ngắm đã lọc trong không gian 3D** (trượt tối đa 30 đv/s) nên không giật kể cả khi địch áp sát — nơi tốc độ góc vốn bùng nổ; rung khi bị đánh được giới hạn tối đa 1 lần/0,3s chống cộng dồn khi bị vây. Đo bằng kịch bản boss (1 Boss + 6 minion vây): tổng quãng quay camera giảm 8,18 → 0,39 rad/9s. FOV: 100° (desktop) / 120° (mobile).
| 📱 Mobile | Joystick trái di chuyển — **camera tự bám theo hướng chạy**, giữ nút 🔥 bắn thì **Rubi tự quay mặt về địch gần nhất + đạn tự khóa mục tiêu**, 💨 dash; vuốt màn hình chỉ khi muốn tự chỉnh camera |

## Gameplay

- **Wave vô hạn, độ khó tăng dần**: số lượng và máu địch tăng theo wave.
- **4 loại địch**: Scout (nhanh, yếu) · Chaser (cân bằng) · Tank (chậm, trâu, đòn đau) · **Boss mỗi 5 wave** (khổng lồ, bắn đạn 3 tia, lõi năng lượng).
- **Hệ thống Combo**: hạ địch liên tiếp để nhân điểm tối đa x5.
- **Nâng cấp giữa wave** (chọn 1 trong 3): sát thương, tốc độ bắn, máu tối đa, tốc độ chạy, hồi máu…
- **Vật phẩm hồi máu** rơi ra từ địch (18%) — nhặt để +25 HP.
- Kỷ lục điểm lưu tự động trên trình duyệt (localStorage).

## Kỹ thuật

- Game nằm trong `index.html` (~900 dòng) + Three.js r160 đóng gói tại `lib/three.module.min.js` (bản quyền MIT của Three.js Authors): ES module + import map, không bundler, chạy offline.
- Nhân vật Rubi và toàn bộ địch dựng bằng hình khối 3D theo đúng thiết kế đã khoá của tuyến Robo/K Team: thân đỏ tươi `#e8212f`, ngực trắng chữ **K** + tia sét vàng, 1 mắt trắng lớn, ăng-ten đầu.
- Hiệu ứng: đổ bóng thời gian thực (PCF soft shadow), hạt nổ (particles), rung màn hình, hitmarker, thanh máu billboard trên đầu địch, đạn phát sáng.
- Âm thanh tổng hợp bằng WebAudio (bắn, nổ, nhặt đồ, qua wave…) — không cần file audio.
- Camera **góc nhìn thứ nhất nhập vai**: chỉ hiển thị khẩu súng của Rubi + tâm ngắm — súng rung khi chạy (bob), giật lùi + chớp lửa đầu nòng khi bắn, camera nghiêng khi strafe và FOV giãn khi dash; pointer lock trên desktop; camera tự bám + joystick ảo + auto-aim trên mobile.
- Có chế độ tự kiểm tra: mở `index.html?autotest=1` — game tự chơi 14 giây và ghi kết quả vào `#autotest-result` / `window.__AUTOTEST__`.

## Cấu trúc repo

```
.
├── index.html   # toàn bộ game (HTML + CSS + JS)
├── lib/
│   └── three.module.min.js   # Three.js r160 (MIT), đóng gói sẵn để chạy offline
├── README.md
└── .gitignore
```

## Bản quyền

Nhân vật Rubi / K Team và mã nguồn game thuộc về **© Ryan Nguyễn**.
