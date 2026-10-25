// Smoke test dùng chung cho MỌI game từ factory: không hardcode tên game.
// Dùng: node game-factory/scripts/smoke.mjs <url-game-dang-chay>
// Kiểm tra: version line có chữ, KTEAM hooks đủ, bấm Kiểm tra tiếng,
// bấm Bắt đầu vào trận được, 0 exception. Thoát 1 nếu có lỗi.
// Chrome: CHROME_BIN (mặc định: Chrome puppeteer trên VM này).
import { spawn } from 'node:child_process';
const url = process.argv[2];
if (!url) { console.error('Dùng: node smoke.mjs <url>'); process.exit(2); }
const CHROME = process.env.CHROME_BIN || '/home/hatch/.cache/puppeteer/chrome/linux-156.0.8078.47/chrome-linux64/chrome';
const PORT = 9370 + Math.floor(Math.random() * 20);
const chrome = spawn(CHROME, ['--headless=new', '--disable-gpu', '--no-sandbox', '--use-angle=swiftshader-webgl', '--enable-unsafe-swiftshader', `--remote-debugging-port=${PORT}`, '--user-data-dir=/tmp/ktest/profile-smoke-' + Math.random().toString(36).slice(2, 7), '--window-size=1280,900', 'about:blank'], { stdio: 'ignore' });
const sleep = ms => new Promise(r => setTimeout(r, ms));
let wsUrl = null;
for (let i = 0; i < 40 && !wsUrl; i++) { try { const r = await fetch(`http://localhost:${PORT}/json/new?${encodeURIComponent(url)}`, { method: 'PUT' }); wsUrl = (await r.json()).webSocketDebuggerUrl; } catch (e) {} if (!wsUrl) await sleep(500); }
if (!wsUrl) { console.error('Không mở được Chrome CDP'); chrome.kill(); process.exit(2); }
const ws = new WebSocket(wsUrl); let id = 0; const pending = new Map(); const errs = [];
ws.onmessage = ev => { const m = JSON.parse(ev.data); if (m.id && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); } if (m.method === 'Runtime.exceptionThrown') errs.push(m.params.exceptionDetails.text); };
const send = (method, params = {}) => new Promise(res => { const i = ++id; pending.set(i, res); ws.send(JSON.stringify({ id: i, method, params })); });
await new Promise(r => ws.onopen = r);
await send('Runtime.enable'); await send('Page.enable');
await send('Page.navigate', { url });
await sleep(5000);
const ev2 = async expr => { const r = await send('Runtime.evaluate', { expression: expr, returnByValue: true }); if (r.result?.exceptionDetails) return 'ERR'; return r.result?.result?.value; };
const fails = [];
const versionLine = await ev2(`document.getElementById('version-line')?.textContent || ''`);
console.log('version-line:', versionLine); if (!versionLine) fails.push('thiếu version-line');
const keys = await ev2(`window.KTEAM ? Object.keys(window.KTEAM).join(',') : ''`);
console.log('KTEAM:', keys); for (const k of ['state', 'startGame', 'SFX', 'audio']) if (!keys.includes(k)) fails.push('thiếu KTEAM.' + k);
await ev2(`document.getElementById('btn-soundtest')?.click()`);
await sleep(300);
console.log('audio-status:', await ev2(`document.getElementById('audio-status')?.textContent || ''`));
await ev2(`document.getElementById('btn-start')?.click()`);
await sleep(1500);
const playing = await ev2(`window.KTEAM?.state?.playing`);
console.log('playing:', playing); if (playing !== true) fails.push('bấm Bắt đầu không vào trận');
console.log('exceptions:', errs.length ? errs.slice(0, 3).join(' | ') : '(none)'); if (errs.length) fails.push(errs.length + ' exception');
ws.close(); chrome.kill();
if (fails.length) { console.error('SMOKE FAIL:', fails.join(' ; ')); process.exit(1); }
console.log('SMOKE OK');
