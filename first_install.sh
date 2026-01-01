#!/usr/bin/bash

main() {
local pkg_mng

# FLATPAK APP LIST 
local apps=(
	com.discordapp.Discord
	com.stremio.Stremio
	md.obsidian.Obsidian
	org.gnome.World.Secrets
	org.mozilla.Thunderbird
	org.qbittorrent.qBittorrent
	org.telegram.desktop
	com.calibre_ebook.calibre
	com.spotify.Client
	app.devsuite.Ptyxis
)

# PACKAGE MANAGER DETECTION
if dnf --version > /dev/null 2>&1; then 
	pkg_mng="dnf"
	echo "--- DNF detected ---"
fi
if apt --version > /dev/null 2>&1; then 
	pkg_mng="apt"
	echo "--- APT detected ---"
fi
if pacman --version > /dev/null 2>&1; then
	true	
fi

#FLATPAK SETUP
if ! flatpak --version; then
	sudo "${pkg_mng}" install -y flatpak
fi

if ! flatpak install flathub "${apps[@]}"; then
	echo "Flatpak apps:Failed installation on one or more apps" >&2
	
else
	echo "Flatpak apps: installed"
	
fi

#GNOME SETUP

#shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "flatpak run app.devsuite.Ptyxis"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>t"

gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>Delete']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Super>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Super>Right']"


#theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


return 0
}


main

