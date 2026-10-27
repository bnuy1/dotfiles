# Mangowm
sudo zypper addrepo https://download.opensuse.org/repositories/home:/andybuilds:/wayland/openSUSE_Tumbleweed/ home:andybuilds:wayland
sudo zypper refresh
sudo zypper install mangowm

# pwucontrol
sudo zypper install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.saivert.pwvucontrol

# pipewire
sudo zypper install pipewire pipewire-alsa pipewire-pulseaudio
systemctl --user enable --now pipewire.service pipewire.socket
systemctl --user enable --now pipewire-pulse.service pipewire-pulse.socket
systemctl --user enable --now wireplumber.service
systemctl --user stop wireplumber && mkdir -p ~/.config/systemd/user/wireplumber.service.d && printf '[Service]\nEnvironment=WIREPLUMBER_PROFILE=main\nExecStart=\nExecStart=/usr/bin/wireplumber\n' > ~/.config/systemd/user/wireplumber.service.d/override.conf && systemctl --user daemon-reload && systemctl --user start wireplumber

# waybar
sudo zypper install waybar

# shell
cat /etc/shells | grep fish || sudo zypper install fish
chsh -s $(which fish)
