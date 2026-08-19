@echo off
setlocal EnableExtensions

rem Installs the local development copies of the video editing Skills for Codex.
rem Open a new Codex task after this script finishes so Codex loads the updates.

set "ROOT=%~dp0"
set "CODEX_SKILLS=%USERPROFILE%\.codex\skills"

echo.
echo Installing Codex Skills from:
echo   %ROOT%skills
echo.

if not exist "%CODEX_SKILLS%" mkdir "%CODEX_SKILLS%"

call :install_skill "chatgpt-short-video-editor"
if errorlevel 1 goto :failed

call :install_skill "puretext-video-subtitles"
if errorlevel 1 goto :failed

echo.
echo Skills installed successfully.
echo Start a new Codex task to load the updated Skills.
echo.
pause
exit /b 0

:install_skill
set "SKILL_NAME=%~1"
set "SOURCE=%ROOT%skills\%SKILL_NAME%"
set "DESTINATION=%CODEX_SKILLS%\%SKILL_NAME%"

if not exist "%SOURCE%\SKILL.md" (
  echo [ERROR] Cannot find %SOURCE%\SKILL.md
  exit /b 1
)

echo Updating %SKILL_NAME%...
robocopy "%SOURCE%" "%DESTINATION%" /E /R:2 /W:1 /NFL /NDL /NJH /NJS /NP
set "ROBOCOPY_EXIT=%ERRORLEVEL%"

rem Robocopy exit codes 0-7 mean success (including copied or skipped files).
if %ROBOCOPY_EXIT% GEQ 8 (
  echo [ERROR] Failed to install %SKILL_NAME% ^(robocopy exit %ROBOCOPY_EXIT%^).
  exit /b %ROBOCOPY_EXIT%
)

exit /b 0

:failed
echo.
echo Skill installation did not finish. Review the error above.
echo.
pause
exit /b 1
