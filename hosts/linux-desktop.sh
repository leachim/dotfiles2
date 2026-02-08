#!/bin/bash
# Configuration for Linux workstation with Wayland/Sway desktop

export BEEP=$HOME/.dotfiles/files/soft_beep.wav
export TERM="xterm-256color"

# If running from tty1, start Sway desktop session
if [ "$(tty)" = "/dev/tty1" ]; then
    export XKB_DEFAULT_LAYOUT=us,de
    export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle

    exec env \
        MESA_LOADER_DRIVER_OVERRIDE=i965 \
        QT_WAYLAND_FORCE_DPI=physical \
        QT_QPA_PLATFORM=wayland-egl \
        QT_WAYLAND_DISABLE_WINDOWDECORATION=1 \
        QT_QPA_PLATFORMTHEME=qt5ct \
        ECORE_EVAS_ENGINE=wayland_egl \
        ELM_ENGINE=wayland_egl \
        CLUTTER_BACKEND=wayland \
        SDL_VIDEODRIVER=wayland \
        BEMENU_BACKEND=wayland \
        MOZ_ENABLE_WAYLAND=1 \
        dbus-run-session sway
fi
