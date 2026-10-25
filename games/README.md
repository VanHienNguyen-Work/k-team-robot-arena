# Games — nơi ở của mọi game làm từ factory

Mỗi game là một thư mục độc lập, tự chạy được (index.html + lib/), không
import chéo game khác. Tạo game mới bằng 1 lệnh từ repo root:

```bash
bash game-factory/scripts/new-game.sh <slug> "Tên Game" [Tên mã]
```

Slug là duy nhất: nó thành tên thư mục, key localStorage và dòng trong
`game-factory/GAMES.md`. Game nào cũng chạy smoke test chung trước khi
đóng version:

```bash
python3 -m http.server 8765 --directory games/<slug>
node game-factory/scripts/smoke.mjs http://localhost:8765/
```
