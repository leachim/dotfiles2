#!/bin/bash
# Configuration for Linux workstation with Wayland/Sway desktop

export BEEP=$HOME/.dotfiles/files/soft_beep.wav
export TERM="xterm-256color"

alias zotero="/opt/Zotero_linux-x86_64/zotero"
alias matlab-desktop="$HOME/.matlab/bin/matlab &"

# Linux shell defaults
alias ls="ls --color=auto"
alias free="free -mt"
alias psn="ps auxf"
alias google-chrome="google-chrome -enable-features=UseOzonePlatform -ozone-platform=wayland"

# Package management
alias apu="sudo apt update"
alias apg="sudo apt upgrade"
alias apa="sudo apt update && sudo apt upgrade"
alias api="sudo apt install"
alias reboot="sudo systemctl reboot"
alias poweroff="sudo systemctl poweroff"
alias suspend="systemctl suspend"
alias backup-package-list="dpkg --get-selections"

# System utilities
alias m-timezone="timedatectl"
alias m-timezone-update="sudo dpkg-reconfigure tzdata"
alias scrotclip="scrot -s ~/.temp.png && xclip -selection clipboard -t image/png -i ~/.temp.png && rm -f ~/.temp.png"

# Browser aliases
alias firefox="Exec=env MOZ_X11_EGL=1 /usr/bin/firefox"
alias pfirefox="/usr/bin/firefox -private-window"
alias pchrome="/usr/bin/chromium -incognito"
tchrome() { /usr/bin/chromium --user-data-dir="$(mktemp -d)"; }

# X11/Wayland caps lock fix
capsfix () { /usr/bin/python3 -c "from ctypes import *; X11 = cdll.LoadLibrary(\"libX11.so.6\"); display = X11.XOpenDisplay(None); X11.XkbLockModifiers(display, c_uint(0x0100), c_uint(2), c_uint(0)); X11.XCloseDisplay(display)" ; }
CAPSFIX () { capsfix; }

# Monitor and presentation settings (xrandr)
m-mode-present () { xrandr --output DP1 --auto ; xrandr --output DP2 --auto ; }
m-mode-savepower() { if [ ! -f /tmp/savedata.lock ]; then systemctl stop bluetooth.service && brightnessctl set 10% && touch /tmp/savedata.lock; else systemctl start bluetooth.service && brightnessctl set 30% && sleep 3 && rm -f /tmp/savedata.lock; fi; }
m-mode-flightmode() { if [ ! -f /tmp/flightmode.lock ]; then nmcli radio wifi off && touch /tmp/flightmode.lock; echo "Turning flight mode on"; else nmcli radio wifi on && rm -f /tmp/flightmode.lock; echo "Turning flight mode off"; fi; }
m-mode-quiet() { if [ ! -f /tmp/quiet.lock ]; then killall -SIGUSR1 dunst; touch /tmp/quiet.lock; echo "Turning quiet mode on"; else killall -SIGUSR2 dunst; rm -f /tmp/quiet.lock; echo "Turning quiet mode off"; fi; }

dual-dp () { xrandr --output eDP1 --primary --output DP1 --auto --right-of eDP1; }
dual-vga () { xrandr --output eDP1 --primary --output DP2 --auto --right-of eDP1; }
dual-hdmi () { xrandr --output eDP1 --primary --output HDMI1 --auto --right-of eDP1; }
single () { xrandr --output DP1 --off; xrandr --output DP2 --off ; xrandr --output HDMI1 --off ; xrandr --output HDMI2 --off ; }
present () { xrandr --output DP1 --auto ; xrandr --output DP2 --auto; }

darken () { brightnessctl set 0% ; }
lighten () { brightnessctl set 100% ; }

# Battery status (upower)
function m-battery () { upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage" ; }

# Network management (nmcli/wireguard)
alias wgup="sudo wg-quick up "
alias wgdown="sudo wg-quick down "
alias wgstatus="sudo wg"
alias caup="sudo ipsec up CAM && touch /tmp/vpn.lock"
alias cadown="sudo ipsec down CAM && rm -f /tmp/vpn.lock"
alias nmshow="nmcli device wifi list"
alias nmlist="nmcli con show --active"
alias nmup="nmcli connection up"
alias nmdown="nmcli connection down"
alias m-connect-ext="nmcli device wifi connect 00:5F:67:13:6C:3B"
alias m-connect-fre="nmcli device wifi connect A4:05:D6:08:38:00"
alias m-connect-new="nmcli device wifi connect"
alias m-connect-list="nmcli dev wifi list"
alias m-connect-scan="nmcli dev wifi rescan"

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
