#!/usr/bin/env fish
# Copia la configuración VIVA del sistema hacia este repo.
# Correr desde la raíz del repo: ./sync.fish
# Es la mitad "hacia adentro": sistema -> repo.

set -l REPO (dirname (status filename))
cd $REPO

echo "== fish"
mkdir -p fish/functions fish/completions
for f in ~/.config/fish/functions/*.fish
    cp $f fish/functions/
    echo "   "(basename $f)
end
cp ~/.config/fish/completions/*.fish fish/completions/ 2>/dev/null
cp ~/.config/fish/config.fish fish/config.fish

echo "== config de apps"
mkdir -p config
for d in alacritty hypr tmux nvim
    if test -d ~/.config/$d
        rsync -a --delete --exclude="*.bak" --exclude="*.bak.*" --exclude="*.save" --exclude="*.save.*" --exclude="*.orig" --exclude="*upgrade-to-*" ~/.config/$d/ config/$d/
        echo "   $d"
    end
end
# Barra de Omarchy (omarchy-shell): solo el layout y los scripts propios.
# El resto de ~/.config/omarchy (temas, branding, hooks) lo administra Omarchy.
mkdir -p config/omarchy
cp ~/.config/omarchy/shell.json config/omarchy/shell.json; and echo "   omarchy/shell.json"
if test -d ~/.config/omarchy/bar
    rsync -a --delete ~/.config/omarchy/bar/ config/omarchy/bar/
    echo "   omarchy/bar"
end
test -f ~/.tmux.conf; and cp ~/.tmux.conf config/tmux.conf
test -f ~/.config/starship.toml; and cp ~/.config/starship.toml config/starship.toml

echo "== systemd (unidades de usuario propias)"
mkdir -p systemd
for u in rclone-personal
    test -f ~/.config/systemd/user/$u.service; and cp ~/.config/systemd/user/$u.service systemd/; and echo "   $u.service"
end

echo "== paquetes"
mkdir -p packages
pacman -Qqe > packages/pacman-explicit.txt
pacman -Qqm > packages/aur.txt
echo "   "(wc -l < packages/pacman-explicit.txt)" paquetes explícitos"


echo
echo "Listo. Revisá con: git status --short"
