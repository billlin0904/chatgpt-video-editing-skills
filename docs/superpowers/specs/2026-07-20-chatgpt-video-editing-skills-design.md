# ChatGPT Video Editing Skills Repo Design

## Goal

建立一個可公開安裝的 GitHub Skills Repo，讓使用者能在支援 Agent Skills 的工具中安裝 AI 短影音環境，並依「ChatGPT剪短影音的八大步驟」執行安全、非破壞式、可驗證的直式短影音剪輯。

## Audience and use cases

- 第一次建立 AI 剪輯環境的創作者。
- 想把 MOV、MP4 或口播素材剪成 Reels、Shorts、TikTok 的使用者。
- 想保留逐字稿、字幕、EDL、預覽與 QA 證據的進階使用者。

不處理單純的 Premiere、CapCut 或其他 NLE 操作問答；這類問題不應誤觸發本 Repo 的 Skills。

## Architecture

Repo 採兩個 Standard Skills，加一份可獨立複製的完整提示詞：

1. `chatgpt-video-editing-setup`：只負責環境檢查、取得安裝授權、安裝或連結 `browser-use/video-use`、安裝 HyperFrames Skills、安全設定 ElevenLabs，以及做不產生付費轉寫的最小驗證。
2. `chatgpt-short-video-editor`：只負責素材檢查、逐字轉寫、內容整理、策略確認、粗剪、視覺與字幕、混音預覽、QA 與定稿。
3. `examples/完整提示詞.md`：保留新手可一次貼上的安裝＋剪輯完整流程。

剪輯 Skill 若發現依賴缺失，應轉交 Setup Skill 或提供安裝指令，不自行悄悄改動系統。安裝 Skill 完成後不主動開始付費轉寫或剪輯。

## Safety contract

- 不包含、不安裝、不依賴 OpenMontage。
- 不覆寫、搬移或重新命名原始影片；工作檔只放在來源旁的 `edit/`。
- Clone Repo、安裝套件、下載大型依賴、改動 Skills 目錄前，必須列出動作並取得同意。
- 既有 Repo 有未提交變更時，不拉取、不重設、不覆寫。
- `ELEVENLABS_API_KEY` 只讀取環境變數或 `~/Developer/video-use/.env`；不回顯、不寫入日誌、不提交 Git，`.env` 權限為 `600`。
- 第一次把媒體交給 ElevenLabs 前，說明檔案、用途與可能額度，取得同意後才上傳。
- 未經確認，不加入 B-roll、動畫、音樂、CTA 或發布排程。
- 未實際執行並驗證，不回報安裝、轉寫、預覽或成片完成。

## Editing contract

八大步驟固定為：素材檢查、逐字轉寫、內容整理、剪輯決策、逐段粗剪、轉色／圖卡／字幕、混音與完整預覽、QA 與正式定稿。

執行硬規則：

- 使用 word-level verbatim timestamps，剪接點貼齊字詞邊界並保留 30–200ms 邊界空間。
- 每段音訊邊界加入約 30ms 淡入淡出。
- 先提出 4–8 句白話策略並等待確認，再決定剪接點。
- 先做 720p 完整預覽；字幕最後合成；確認後才輸出 1080×1920 定稿。
- 最多三輪有證據的自我修正；驗證完整解碼、音畫同步、字幕安全區、色彩、音訊與每個剪接點。

## Tool roles

- `video-use`：主要剪輯工作流、轉寫快取、EDL、逐段輸出、渲染與 QA。
- ElevenLabs Scribe v2：逐字級時間碼與可選說話者／音訊事件資訊。
- FFmpeg／ffprobe：素材檢查、逐段剪接、音訊、合成、編碼與解碼驗證。
- Pillow：靜態標題、字幕或資訊卡。
- HyperFrames：只有策略確認需要 HTML／CSS／GSAP 動畫時才使用；不是每支影片的必要工具。

第三方 Repo 程式碼不封裝進本 Repo；只提供官方來源、安裝與使用契約，各自授權仍由原專案管理。

## Public package

- GitHub：`Jaycheng1103/chatgpt-video-editing-skills`
- Visibility：Public
- License：MIT（只涵蓋本 Repo 原創內容）
- Install all：`npx skills add Jaycheng1103/chatgpt-video-editing-skills --all --full-depth`
- Install one：`npx skills add Jaycheng1103/chatgpt-video-editing-skills --skill <skill-name> --full-depth`
- README 必須包含快速開始、手動安裝、相依工具、API 安全、流程圖、輸出內容、第三方聲明與移除方式。

## Verification

- 兩個 `SKILL.md` 均少於 100 行，具有 `name`／`description` frontmatter 與正、反向觸發詞。
- Repo 驗證腳本檢查必要檔案、禁用 OpenMontage、Secret 防護、核心八步與輸出契約。
- Skill Maker `quick_validate.py` 分別驗證兩個 Skills。
- 在乾淨暫存目錄，從本機 Repo 與 GitHub 遠端執行 Skills 安裝，確認兩個 Skills 都可被發現。
- GitHub 頁面可讀、預設分支存在，公開 Clone 成功。

