#!/usr/bin/env bash
# Tạo game mới từ template — 1 lệnh, game mới đứng độc lập, không đụng game cũ.
# Dùng: bash game-factory/scripts/new-game.sh <slug> "Tên Game" [Tên mã]
#   slug: chữ thường, số, gạch ngang (vd: robot-dua-xe). Slug là duy nhất:
#   nó thành thư mục games/<slug>/, key localStorage, và dòng trong registry.
#   GAMES_DIR và REGISTRY có thể override bằng biến môi trường (để test).
set -euo pipefail
FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(dirname "$FACTORY_DIR")"
GAMES_DIR="${GAMES_DIR:-$ROOT_DIR/games}"
REGISTRY="${REGISTRY:-$FACTORY_DIR/GAMES.md}"
slug="${1:-}"; title="${2:-}"; codename="${3:-Seed}"
if [ -z "$slug" ] || [ -z "$title" ]; then echo "Dùng: new-game.sh <slug> \"Tên Game\" [Tên mã]"; exit 1; fi
if ! [[ "$slug" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then echo "Lỗi: slug chỉ gồm chữ thường, số, gạch ngang, bắt đầu bằng chữ/số."; exit 1; fi
if [ -e "$GAMES_DIR/$slug" ]; then echo "Lỗi: đã có thư mục games/$slug."; exit 1; fi
if [ -f "$REGISTRY" ] && grep -q "| \`$slug\` |" "$REGISTRY"; then echo "Lỗi: slug đã có trong registry."; exit 1; fi
mkdir -p "$GAMES_DIR"
cp -r "$FACTORY_DIR/template" "$GAMES_DIR/$slug"
TITLE="$title" SLUG="$slug" CODENAME="$codename" python3 - "$GAMES_DIR/$slug/index.html" "$GAMES_DIR/$slug/VERSIONS.md" <<'PYEOF'
import sys, os
html_path, ver_path = sys.argv[1], sys.argv[2]
s = open(html_path).read()
assert 'GAME TITLE' in s and "'mygame'" in s and "'Seed'" in s
s = s.replace('GAME TITLE', os.environ['TITLE'])
s = s.replace("'mygame'", "'" + os.environ['SLUG'] + "'")
s = s.replace("'Seed'", "'" + os.environ['CODENAME'] + "'")
open(html_path, 'w').write(s)
v = open(ver_path).read()
v = v.replace('Seed', os.environ['CODENAME'], 1)
open(ver_path, 'w').write(v)
PYEOF
cat > "$GAMES_DIR/$slug/README.md" <<EOF
# $title

- Slug: \`$slug\` · Version: v0.1 "$codename" · Nguồn: game-factory/template
- Chơi: \`python3 -m http.server 8765 --directory .\` rồi mở http://localhost:8765/
- Đổi luật chơi: sửa phần ENTITIES + FLOW trong \`index.html\`, giữ nguyên
  AUDIO, QUALITY, DEBUG HOOKS, LOOP (xem \`../game-factory/PLAYBOOK.md\`).
- Đóng version: xem checklist trong PLAYBOOK mục 6. Tag đã publish không sửa.
EOF
echo "template=v0.1" > "$GAMES_DIR/$slug/.factory"
if [ -f "$REGISTRY" ] && grep -q '<!-- NEW-GAMES -->' "$REGISTRY"; then
  next=$(printf '%03d' $(( $(grep -c '^| [0-9]' "$REGISTRY") + 1 )))
  python3 - "$REGISTRY" "$next" "$slug" "$title" "$codename" <<'PYEOF'
import sys
path, num, slug, title, codename = sys.argv[1:6]
s = open(path).read()
row = f"| {num} | `{slug}` | {title} | v0.1 \"{codename}\" | 🛠️ Đang làm | games/{slug}/ |\n"
assert '<!-- NEW-GAMES -->' in s
s = s.replace('<!-- NEW-GAMES -->', row + '<!-- NEW-GAMES -->', 1)
open(path, 'w').write(s)
PYEOF
fi
echo "Xong: games/$slug/ — $title (v0.1 \"$codename\")"
echo "Chạy thử: python3 -m http.server 8765 --directory games/$slug"
echo "Smoke test: node game-factory/scripts/smoke.mjs http://localhost:8765/"
