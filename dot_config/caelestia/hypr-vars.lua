-- Overrides for ~/.config/hypr/variables.lua (Caelestia dots).
return {
    -- Same as KDE: Hyprland start runs `gsettings set ... cursor-theme/size`,
    -- which is shared with Plasma, so any other value would leak into KDE.
    cursorTheme          = "breeze_cursors",
    cursorSize           = 24,

    -- Apps
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
}
