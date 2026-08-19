# ChatGPT 剪短影音 Skills

一組給可操作本機檔案與終端機的 AI Agent 使用的繁體中文 Skills，協助你安全地準備剪輯環境，並把自己提供的影片製作成直式短影音。

這個套件把「環境安裝／檢查」、「字幕準備」和「實際剪輯」分成獨立 Skill。它會保護原始素材、在付費或上傳前取得同意，並以實際輸出與 QA 證據為準，不把計畫、指令或未驗證的檔案說成完成品。

![ChatGPT 剪短影音的八大步驟](assets/ChatGPT剪短影音的八大步驟.png)

## Skills 的分工

| Skill | 用途 | 不會做的事 |
| --- | --- | --- |
| [`chatgpt-video-editing-setup`](skills/chatgpt-video-editing-setup/SKILL.md) | 檢查、安裝、修復或驗證 video-use、FFmpeg、ffprobe、思源黑體 TW 字幕字體、PureText Agent API 環境與選用的 HyperFrames 環境 | 不上傳素材、不轉寫、不剪輯、不輸出影片 |
| [`chatgpt-short-video-editor`](skills/chatgpt-short-video-editor/SKILL.md) | 對使用者提供的影片執行逐字轉寫、剪輯策略、粗剪、字幕、預覽、QA 與正式輸出 | 不會靜默安裝工具，也不會在預覽核准前輸出正式定稿 |
| [`puretext-video-subtitles`](skills/puretext-video-subtitles/SKILL.md) | 透過 PureText 為使用者提供的影音建立可編輯字幕、翻譯、名詞索引與 SRT／VTT／JSON 匯出，供剪輯流程使用 | 不下載 YouTube、不決定剪輯點、不渲染或發布影片 |

## 安裝

### 快速安裝（互動式，建議）

在你的專案目錄執行：

```sh
npx skills add billlin0904/chatgpt-video-editing-skills --full-depth
```

安裝器會讓你選擇要安裝的 Skills 與偵測到的 Agent。

若你確定要一次選取這個 Repo 內的所有 Skills，並安裝到所有偵測到的 Agent，可執行：

```sh
npx skills add billlin0904/chatgpt-video-editing-skills --all --full-depth
```

`--all` 會同時選取「全部 Skills」與「全部偵測到的 Agent」，請先確認這正是你想要的範圍。

### 只安裝單一 Skill

只安裝環境設定 Skill：

```sh
npx skills add billlin0904/chatgpt-video-editing-skills --skill chatgpt-video-editing-setup --full-depth
```

只安裝剪輯 Skill：

```sh
npx skills add billlin0904/chatgpt-video-editing-skills --skill chatgpt-short-video-editor --full-depth
```

只安裝 PureText 字幕 Skill：

```sh
npx skills add billlin0904/chatgpt-video-editing-skills --skill puretext-video-subtitles --full-depth
```

### 手動 Clone 後從本機安裝

```sh
git clone https://github.com/billlin0904/chatgpt-video-editing-skills.git
cd chatgpt-video-editing-skills
npx skills add . --full-depth
```

這種方式適合先閱讀內容、再從本機路徑安裝。若要手動複製 Skill，必須連同各自的 `references/` 一起保留，不能只複製 `SKILL.md`。

### 更新與移除

更新已安裝的兩個 Skills：

```sh
npx skills update chatgpt-video-editing-setup chatgpt-short-video-editor
```

互動式移除：

```sh
npx skills remove chatgpt-video-editing-setup chatgpt-short-video-editor
```

若你安裝在全域範圍，更新或移除時請加上 `--global`。你也可以先用 `npx skills list` 確認目前專案範圍的安裝狀態。

## 前置需求

- 能讀寫本機檔案並執行終端機指令的相容 Agent。
- Git、Python 與 [uv](https://docs.astral.sh/uv/)；實際需求仍以 video-use 當下版本的官方文件為準。
- [FFmpeg](https://ffmpeg.org/) 與 `ffprobe`。
- [video-use](https://github.com/browser-use/video-use) 完整 Repo；剪輯輔助程式位於其中，不能只保留一份 Skill 文件。
- [思源黑體（Source Han Sans）](https://github.com/adobe-fonts/source-han-sans) TW 子集 OTF（Regular 與 Bold），供繁體中文字幕燒錄使用；採 SIL Open Font License 1.1 授權，Setup Skill 只從官方 Repo 的 `release` 分支下載。
- PureText Agent API 的可撤銷 Token 與可用額度，供完整精度流程取得 word-level 時間碼。設定 `PURETEXT_API_BASE_URL` 與 `PURETEXT_AGENT_TOKEN`；未設定時，`puretext-video-subtitles` 只會停在本機檢查，不會嘗試重用瀏覽器登入資訊。
- [Pillow](https://python-pillow.github.io/) 用於簡單靜態資訊卡。
- [HyperFrames](https://github.com/heygen-com/hyperframes) 僅在已核准的策略需要 HTML、CSS 或 GSAP 動畫時才是選用需求；若選用，必須有 Node.js 22 或更新版本與 Bun。未選用時，不要求 Node.js、HyperFrames Repo、`bun.lock` 或其 Core Skills。

缺少工具時，剪輯 Skill 會停在安全位置，說明缺口並交給 Setup Skill 檢查。它不會自行 Clone、更新、安裝套件或改動你的 Skills 目錄。

## 第一次使用

先檢查環境：

> 請使用 `chatgpt-video-editing-setup` 檢查我的短影音剪輯環境。先只做檢查並列出需要的變更，等我確認後再安裝；不要上傳或轉寫任何媒體。

環境通過後開始剪輯：

> 請使用 `chatgpt-short-video-editor`，把 `/完整/路徑/原始影片.mov` 剪成 60–90 秒、9:16 的繁體中文 Reels。先完成素材檢查、逐字轉寫與內容整理，再用 4–8 句提出剪輯策略，等我確認後才開始剪。

若要先用 PureText 建立可剪輯字幕：

> 請使用 `puretext-video-subtitles` 為 `/完整/路徑/原始影片.mov` 建立英文原文與繁體中文字幕。先顯示預估分鐘與用量，取得我的確認後才建立工作；完成後保留 word timestamps 與字幕文件，交給剪輯流程使用。

若想一次提供完整規格，可直接複製 [`examples/完整提示詞.md`](examples/完整提示詞.md)。

## 八大步驟

1. 素材檢查：用 `ffprobe` 確認來源規格與可解碼性，原始影片保持不變。
2. 逐字轉寫：先取得檔案層級的上傳同意，再以 PureText Agent API 取得或讀取已驗證的 word-level 字幕文件。
3. 內容整理：找出 Hook、核心主線、可刪內容與待確認資訊。
4. 剪輯決策：先提出 4–8 句白話策略，取得核准後才決定剪接點與創意元素。
5. 逐段粗剪：依完整字詞邊界建立 EDL，保留 30–200ms 邊界空間與約 30ms 音訊淡入淡出。
6. 轉色／圖卡／字幕：只有技術上必要或已核准時才調色；靜態圖卡用 Pillow，選用動畫才用 HyperFrames，字幕以思源黑體 TW 最後合成。
7. 混音與完整預覽：先輸出並檢查一支完整 720p 預覽。
8. QA 與正式定稿：預覽獲得明確核准後才輸出 1080×1920 正式檔；正式檔仍需獨立檢查與完整解碼，通過後才交付。

完整規則見 [`eight-step-workflow.md`](skills/chatgpt-short-video-editor/references/eight-step-workflow.md) 與 [`production-rules.md`](skills/chatgpt-short-video-editor/references/production-rules.md)。

## 隱私、憑證與費用

- 不要把 API Key 貼進聊天、命令列參數、公開檔案、Git commit、shell history 或 log。
- `PURETEXT_API_BASE_URL` 與 `PURETEXT_AGENT_TOKEN` 只能由本機環境變數提供；不可寫入聊天、命令列參數、公開檔案、Git commit、shell history 或 log。
- Agent 不得讀取、顯示或推測 Token 值，也不可改用瀏覽器登入 Cookie、Google Session 或其他使用者憑證。
- 第一次把媒體傳給 PureText Agent API 前，Agent 必須說明具體檔名、用途是取得逐字時間碼、預估分鐘數與可能消耗額度或產生費用，並等待你的明確同意。
- 若你不願上傳雲端，可明確選擇本機 Whisper 降級方案；它的時間碼信心較低，需要對每個剪接邊界做額外播放檢查，不能說成與 PureText 的已驗證 word-level 時間碼同等精準。

詳細安全規則見 [`security-and-verification.md`](skills/chatgpt-video-editing-setup/references/security-and-verification.md)。

## 會保留的產物

所有新產物都放在原始影片旁的 `edit/`，原始檔不會被覆寫、移動、重新命名或刪除：

```text
edit/
├── project.md
├── transcripts/<source>.json
├── corrected-transcript.md
├── edl.json
├── master.srt
├── clips/
├── animations/slot_<id>/
├── qa/
├── preview.mp4
└── final.mp4
```

`final.mp4` 只有在 720p 預覽獲得核准、1080×1920 正式檔完成渲染，而且正式檔本身通過剪接點、代表畫面與完整解碼檢查後，才會被當成可交付成片。完整定義見 [`output-contract.md`](skills/chatgpt-short-video-editor/references/output-contract.md)。

## 常見問題

### Agent 說找不到 FFmpeg、ffprobe、video-use、字幕字體或憑證

請改用 `chatgpt-video-editing-setup`。它會先檢查，再列出需要你核准的變更。若既有 Repo 有未提交修改，它會停下來，不會直接 pull、reset 或覆寫；既有字體檔也不會被重新下載或覆寫。

### 沒有 PureText 額度，或不想上傳素材

完整精度流程以 PureText Agent API 為主。你可以明確要求使用本機 Whisper 降級方案，但要接受較低信心的時間碼與額外邊界 QA；Agent 不應默默切換。

### 已經看到指令、轉寫文字或預覽，為什麼還沒算完成？

指令不等於已執行，畫面不等於完整 QA，預覽也不等於正式交付。正確順序是：完整預覽檢查 → 你核准預覽 → 渲染正式檔 → 驗證正式檔 → 交付。

### 想加動畫、B-roll、音樂或 CTA

請在剪輯策略階段提出或核准。這些都是 opt-in 創意決策，不是預設自動加入。簡單靜態圖卡優先使用 Pillow；只有已核准的 HTML、CSS 或 GSAP 動畫才需要 HyperFrames。

## 第三方、授權與聲明

本 Repo 不內含第三方上游程式碼。相關工具、API 與服務仍受各自的條款與授權約束，詳見 [`THIRD_PARTY_NOTICE.md`](THIRD_PARTY_NOTICE.md)。

本專案以 [MIT License](LICENSE) 發布。歡迎先閱讀 [`CONTRIBUTING.md`](CONTRIBUTING.md) 與 [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) 再參與貢獻。

這是社群維護的非官方專案，與 OpenAI、ChatGPT、video-use、HyperFrames、PureText、FFmpeg、Pillow 或 Adobe 的開發者及所屬公司沒有從屬、授權、背書或合作關係。產品名稱與商標屬各自權利人所有。
