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

hl.config({
    input = {
        -- Keyboard layouts as in KDE: us + ara, Alt+Shift switches
        kb_layout    = "us,ara",
        kb_options   = "grp:alt_shift_toggle",
        -- Focus follows the mouse (built-in: no cursor warp, visible windows only)
        follow_mouse = 1,
    },
    misc = {
        -- Alt+Tab onto another window keeps it maximized/fullscreen
        on_focus_under_fullscreen = 1,
    },
})

-- File pickers from the desktop portals (e.g. "Open workspace" in editors) float
-- like Caelestia's other file dialogs, whatever their title says.
hl.window_rule({
    match = { class = "xdg-desktop-portal-gtk|org.freedesktop.impl.portal.desktop.kde" },
    tag   = "+float_60_70",
})

-- Apps started over D-Bus (e.g. "Open" on a recording notification launches
-- Dolphin) get systemd's environment. Hyprland exports QT_QPA_PLATFORMTHEME
-- there but not the plugin path, so they fell back to a light theme. Export
-- both for this session and remove them on exit: the user manager lingers,
-- and KDE must not inherit Hyprland's Qt theme.
local qt_env = "QT_QPA_PLATFORMTHEME QT_PLUGIN_PATH"
hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user unset-environment " .. qt_env)
end)

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment " .. qt_env)
    -- KDE's polkit agent (gnome-keyring/polkit-gnome aren't installed).
    hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
    -- KDE wallet as the Secret Service (org.freedesktop.secrets), as Plasma does:
    -- unlock from the login password when PAM passed one, then serve secrets.
    hl.exec_cmd("/usr/libexec/pam_kwallet_init")
    hl.exec_cmd("ksecretd")
    -- First run only: generate the colour scheme (done here, not at install,
    -- so terminal recolouring never touches open Konsole windows in KDE).
    hl.exec_cmd("test -f " .. home .. "/.local/state/caelestia/scheme.json || caelestia scheme set -n caelestia")
end)
