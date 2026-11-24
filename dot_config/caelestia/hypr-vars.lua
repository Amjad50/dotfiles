-- Overrides for ~/.config/hypr/variables.lua (Caelestia dots).
return {
    -- Same as KDE: Hyprland start runs `gsettings set ... cursor-theme/size`,
    -- which is shared with Plasma, so any other value would leak into KDE.
    cursorTheme          = "breeze_cursors",
    cursorSize           = 24,

    -- Apps
    terminal             = "konsole",
    browser              = "zen-browser",
    editor               = "code",
    fileExplorer         = "dolphin",
    audioSettings        = "kcmshell6 kcm_pulseaudio",

    -- Touchpad scroll speed as in KDE (Caelestia default is 0.3)
    touchpadScrollFactor = 1.0,

    -- KDE-style keys, on top of Caelestia's
    kbCloseWindow        = { "SUPER + Q", "SUPER + W", "ALT + F4" },
    kbBrowser            = "SUPER + B", -- Super+W closes windows now
    kbTerminal           = { "SUPER + T", "SUPER + Return" },
    kbLauncher           = { "SUPER + SUPER_L", "SUPER + Space" },

    -- KDE/Spectacle-style capture: Super+R region screenshot, Super+Shift+R region recording
    kbScreenshotFreeze   = { "SUPER + SHIFT + S", "SUPER + R" },
    kbRecordRegion       = { "SUPER + SHIFT + ALT + R", "SUPER + SHIFT + R" },
    kbTodoWs             = "", -- was Super+R (Todoist workspace, unused)

    -- Quick maximize (keeps the bar); Super+F stays true fullscreen
    kbWindowBorderedFullscreen = { "SUPER + ALT + F", "SUPER + M" },
    kbMusicWs            = "", -- was Super+M (Spotify workspace)
}
