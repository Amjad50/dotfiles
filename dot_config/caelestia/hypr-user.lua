-- Loaded last by ~/.config/hypr/hyprland.lua.
local home = os.getenv("HOME")
local local_bin = home .. "/.local/bin"

-- The login manager starts Hyprland without a login shell, so the locally
-- installed caelestia CLI and QML modules aren't on the default paths.
local path = os.getenv("PATH") or "/usr/bin"
if not path:find(local_bin, 1, true) then
    hl.env("PATH", local_bin .. ":" .. path)
end
hl.env("QML_IMPORT_PATH", home .. "/.local/lib/qt6/qml")
-- qtengine (QT_QPA_PLATFORMTHEME=qtengine is set by the dots) lives here
hl.env("QT_PLUGIN_PATH", home .. "/.local/lib/qt6/plugins")

-- Keyboard layouts as in KDE: us + ara, Alt+Shift switches
hl.config({
    input = {
        kb_layout  = "us,ara",
        kb_options = "grp:alt_shift_toggle",
    },
})

hl.on("hyprland.start", function()
    -- KDE's polkit agent (gnome-keyring/polkit-gnome aren't installed).
    hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
    -- First run only: generate the colour scheme (done here, not at install,
    -- so terminal recolouring never touches open Konsole windows in KDE).
    hl.exec_cmd("test -f " .. home .. "/.local/state/caelestia/scheme.json || caelestia scheme set -n caelestia")
end)
