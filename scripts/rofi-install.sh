echo "Installing Rofi Wayland dependencies and building..."

sudo pacman -S --needed --noconfirm base-devel git meson ninja wayland-protocols libxkbcommon pango cairo glib2 bison flex check startup-notification gdk-pixbuf2 libxcb xcb-util xcb-util-wm xcb-util-cursor

sudo pacman -Rns rofi --noconfirm 2>/dev/null || true

if [ -d "rofi-wayland-source" ]; then
    rm -rf rofi-wayland-source
fi

git clone https://github.com/lbonn/rofi.git rofi-wayland-source
cd rofi-wayland-source
meson setup build
ninja -C build
sudo ninja -C build install

cd ~
echo "Rofi Wayland installed successfully."
