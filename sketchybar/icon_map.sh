#!/usr/bin/env bash

# 入力: アプリ名（macOSの正式名）
# 出力: $icon_result にligatureを設定（sketchybar-app-fontでレンダリング）
function __icon_map() {
    case "$1" in
        # === Browsers ===
        "Arc") icon_result=":arc:" ;;
        "Dia") icon_result=":dia:" ;;
        "Safari"|"Safari Technology Preview") icon_result=":safari:" ;;
        "Google Chrome"|"Google Chrome Beta"|"Google Chrome Canary") icon_result=":google_chrome:" ;;
        "Firefox"|"Firefox Nightly") icon_result=":firefox:" ;;
        "Firefox Developer Edition") icon_result=":firefox_developer_edition:" ;;
        "Microsoft Edge") icon_result=":microsoft_edge:" ;;
        # === Terminals ===
        "WezTerm"|"wezterm-gui"|"WezTerm-gui") icon_result=":wezterm:" ;;
        "Terminal") icon_result=":terminal:" ;;
        "iTerm"|"iTerm2") icon_result=":iterm:" ;;
        "Alacritty") icon_result=":alacritty:" ;;
        # === Editors / IDE ===
        "Code"|"Visual Studio Code") icon_result=":code:" ;;
        "Cursor") icon_result=":cursor:" ;;
        "Xcode") icon_result=":xcode:" ;;
        # === Notes / Knowledge ===
        "Obsidian") icon_result=":obsidian:" ;;
        "Notion") icon_result=":notion:" ;;
        "Notion Mail") icon_result=":notion_mail:" ;;
        "Notes") icon_result=":notes:" ;;
        "GoodNotes") icon_result=":goodnotes:" ;;
        # === Communication ===
        "Slack") icon_result=":slack:" ;;
        "Discord") icon_result=":discord:" ;;
        "Zoom"|"zoom.us") icon_result=":zoom:" ;;
        "Microsoft Teams") icon_result=":microsoft_teams:" ;;
        "Messages") icon_result=":messages:" ;;
        "Mail") icon_result=":mail:" ;;
        # === Music ===
        "Spotify") icon_result=":spotify:" ;;
        "Music") icon_result=":music:" ;;
        # === Productivity ===
        "Raycast") icon_result=":raycast:" ;;
        "Alfred") icon_result=":alfred:" ;;
        "1Password"|"1Password 7"|"1Password 8") icon_result=":1password:" ;;
        "Calendar") icon_result=":calendar:" ;;
        "Figma") icon_result=":figma:" ;;
        # === Files ===
        "Finder") icon_result=":finder:" ;;
        "Preview") icon_result=":preview:" ;;
        # === Dev ===
        "Docker"|"Docker Desktop") icon_result=":docker:" ;;
        "OrbStack") icon_result=":orbstack:" ;;
        "Postman") icon_result=":postman:" ;;
        "TablePlus") icon_result=":tableplus:" ;;
        "GitHub Desktop") icon_result=":github:" ;;
        # === System ===
        "System Settings"|"System Preferences") icon_result=":gear:" ;;
        "Activity Monitor") icon_result=":activity_monitor:" ;;
        "App Store") icon_result=":app_store:" ;;
        # === Other ===
        "AltTab") icon_result=":alttab:" ;;
        "Antigravity") icon_result=":antigravity:" ;;
        "Claude") icon_result=":claude:" ;;
        # === Default fallback ===
        *) icon_result=":default:" ;;
    esac
}
