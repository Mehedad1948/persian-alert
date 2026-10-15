#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

;@Ahk2Exe-SetName Persian Alert
;@Ahk2Exe-SetDescription Beeps when you start typing in Persian
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCopyright Copyright (c) 2026 Mehrdad. MIT License.
;@Ahk2Exe-SetOrigFilename PersianAlert.exe

; Beeps once when you start typing in Persian, then stays quiet until you type in
; another language or move to a different window.
; Typed text is only checked in memory; it is never stored, logged, or sent anywhere.

APP_NAME := "Persian Alert"
APP_VERSION := "1.0.0"  ; keep in sync with ;@Ahk2Exe-SetVersion above
SETTINGS_FILE := A_ScriptDir "\settings.ini"
STARTUP_LINK := A_Startup "\PersianAlert.lnk"
STARTUP_ARG := "--startup"
DEFAULT_TOGGLE_HOTKEY := "^!p"
PERSIAN_LANG_ID := 0x0429
MENU_ENABLED := "Enabled"
MENU_SETTINGS := "Edit settings"
MENU_RELOAD := "Reload settings"
MENU_STARTUP := "Start with Windows"

DEFAULT_SETTINGS := "
(
; Persian Alert settings. After saving, choose 'Reload settings' from the tray menu.

[General]
; Shortcut that turns the alert on/off. ^ = Ctrl, ! = Alt, + = Shift, # = Win.
ToggleHotkey=^!p

[Beep]
; Pitch in Hz (37-32767) and length in milliseconds (1-2000).
Frequency=1500
DurationMs=150

[Apps]
; Comma-separated program names. Find them in Task Manager > Details > Name.
; Never beep in these apps:
Ignore=Telegram.exe
; Only beep in these apps. Leave empty to watch every app:
Only=
)"

settings := LoadSettings()
alertedWindow := 0

BuildTrayMenu()
RegisterToggleHotkey()
UpdateTray()
if !HasArg(STARTUP_ARG)
    TrayTip("Running in the tray. Press " HotkeyLabel(settings.toggleHotkey) " to turn it on or off.", APP_NAME, "Iconi Mute")

typingHook := InputHook("V I L0")
typingHook.OnChar := OnTypedChar
typingHook.Start()

OnTypedChar(hook, char) {
    global alertedWindow
    if A_IsSuspended || Ord(char) < 0x20 || GetKeyState("Ctrl") || GetKeyState("LWin") || GetKeyState("RWin")
        return
    if !IsPersianChar(char) && !IsPersianLayout() {
        alertedWindow := 0
        return
    }
    window := WinExist("A")
    if (window = alertedWindow) || !IsWatchedApp()
        return
    alertedWindow := window
    SoundBeep(settings.frequency, settings.durationMs)
}

IsPersianChar(char) {
    code := Ord(char)
    return (code >= 0x0600 && code <= 0x06FF)
        || (code >= 0xFB50 && code <= 0xFDFF)
        || (code >= 0xFE70 && code <= 0xFEFF)
}

IsPersianLayout() {
    window := WinExist("A")
    if !window
        return false
    threadId := DllCall("GetWindowThreadProcessId", "Ptr", window, "Ptr", 0, "UInt")
    layout := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    return (layout & 0xFFFF) = PERSIAN_LANG_ID
}

IsWatchedApp() {
    try exe := WinGetProcessName("A")
    catch
        return settings.onlyApps.Length = 0
    for app in settings.ignoreApps
        if (exe = app)
            return false
    if settings.onlyApps.Length = 0
        return true
    for app in settings.onlyApps
        if (exe = app)
            return true
    return false
}

LoadSettings() {
    if !FileExist(SETTINGS_FILE)
        try FileAppend(DEFAULT_SETTINGS, SETTINGS_FILE, "UTF-8-RAW")
    return {
        toggleHotkey: ReadSetting("General", "ToggleHotkey", DEFAULT_TOGGLE_HOTKEY),
        frequency: ReadNumber("Beep", "Frequency", 1500, 37, 32767),
        durationMs: ReadNumber("Beep", "DurationMs", 150, 1, 2000),
        ignoreApps: ReadList("Apps", "Ignore", "Telegram.exe"),
        onlyApps: ReadList("Apps", "Only", "")
    }
}

ReadSetting(section, key, default) {
    try return Trim(IniRead(SETTINGS_FILE, section, key, default))
    catch
        return default
}

ReadNumber(section, key, default, min, max) {
    value := ReadSetting(section, key, default)
    return (IsInteger(value) && value >= min && value <= max) ? Integer(value) : default
}

ReadList(section, key, default) {
    items := []
    for item in StrSplit(ReadSetting(section, key, default), ",", " `t")
        if (item != "")
            items.Push(item)
    return items
}

RegisterToggleHotkey() {
    try {
        Hotkey(settings.toggleHotkey, (*) => Toggle(), "S")
    } catch {
        MsgBox("The shortcut '" settings.toggleHotkey "' in settings.ini is not valid. Using Ctrl+Alt+P instead.", APP_NAME, "Icon!")
        settings.toggleHotkey := DEFAULT_TOGGLE_HOTKEY
        Hotkey(DEFAULT_TOGGLE_HOTKEY, (*) => Toggle(), "S")
    }
}

HotkeyLabel(keys) {
    label := ""
    for modifier in [["^", "Ctrl+"], ["!", "Alt+"], ["+", "Shift+"], ["#", "Win+"]]
        if InStr(keys, modifier[1])
            label .= modifier[2]
    return label StrUpper(RegExReplace(keys, "[\^!+#<>*~$]"))
}

HasArg(arg) {
    for value in A_Args
        if (value = arg)
            return true
    return false
}

Toggle() {
    Suspend(-1)
    UpdateTray()
    SoundBeep(A_IsSuspended ? 500 : 1000, 80)
    ToolTip(APP_NAME ": " (A_IsSuspended ? "OFF" : "ON"))
    SetTimer(() => ToolTip(), -1500)
}

EditSettings() {
    if !FileExist(SETTINGS_FILE)
        try FileAppend(DEFAULT_SETTINGS, SETTINGS_FILE, "UTF-8-RAW")
    try Run('notepad.exe "' SETTINGS_FILE '"')
    catch
        MsgBox("Could not open " SETTINGS_FILE, APP_NAME, "Icon!")
}

ToggleStartup() {
    try {
        if FileExist(STARTUP_LINK)
            FileDelete(STARTUP_LINK)
        else
            FileCreateShortcut(A_ScriptFullPath, STARTUP_LINK, A_ScriptDir, STARTUP_ARG, APP_NAME)
    } catch as err {
        MsgBox("Could not change the startup setting: " err.Message, APP_NAME, "Icon!")
    }
    UpdateTray()
}

BuildTrayMenu() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add(MENU_ENABLED, (*) => Toggle())
    A_TrayMenu.Add()
    A_TrayMenu.Add(MENU_SETTINGS, (*) => EditSettings())
    A_TrayMenu.Add(MENU_RELOAD, (*) => Reload())
    A_TrayMenu.Add(MENU_STARTUP, (*) => ToggleStartup())
    A_TrayMenu.Add()
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    A_TrayMenu.Default := MENU_ENABLED
    A_TrayMenu.ClickCount := 1
}

UpdateTray() {
    if A_IsSuspended
        A_TrayMenu.Uncheck(MENU_ENABLED)
    else
        A_TrayMenu.Check(MENU_ENABLED)
    if FileExist(STARTUP_LINK)
        A_TrayMenu.Check(MENU_STARTUP)
    else
        A_TrayMenu.Uncheck(MENU_STARTUP)
    A_IconTip := APP_NAME " " APP_VERSION ": " (A_IsSuspended ? "OFF" : "ON")
}
