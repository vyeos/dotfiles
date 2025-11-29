sudo pacman -S --needed base-devel git meson ninja wayland-protocols libxkbcommon pango cairo glib2 bison flex check startup-notification gdk-pixbuf2 libxcb xcb-util xcb-util-wm xcb-util-cursor

sudo pacman -Rns rofi

# 1. Clone the repository
git clone https://github.com/lbonn/rofi.git rofi-wayland-source

# 2. Enter the directory
cd rofi-wayland-source

# 3. Setup the build
meson setup build

# 4. Compile
ninja -C build

# 5. Install to your system
sudo ninja -C build install

rofi -v
