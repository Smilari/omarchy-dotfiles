#!/usr/bin/env fish
# Restaura la configuración de este repo en un Omarchy recién instalado.
# Correr desde la raíz del repo: ./install.fish

set -l REPO (dirname (status filename))
cd $REPO

echo "== paquetes base"
sudo pacman -S --needed fzf tmux sshfs wl-clipboard openfortivpn rsync git

echo "== funciones fish"
mkdir -p ~/.config/fish/functions ~/.config/fish/completions
cp fish/functions/*.fish ~/.config/fish/functions/
cp fish/completions/*.fish ~/.config/fish/completions/ 2>/dev/null

echo "== config.fish"
if test -f ~/.config/fish/config.fish
    cp ~/.config/fish/config.fish ~/.config/fish/config.fish.pre-dotfiles
    echo "   backup en config.fish.pre-dotfiles"
end
cp fish/config.fish ~/.config/fish/config.fish

echo "== config de apps"
for d in config/*/
    set -l name (basename $d)
    test "$name" = tmux.conf; and continue
    if test "$name" = hypr
        echo "   hypr (omitido — Omarchy lo administra, ver pendientes)"
        continue
    end
    mkdir -p ~/.config/$name
    cp -r $d. ~/.config/$name/
    echo "   $name"
end
test -f config/tmux.conf; and cp config/tmux.conf ~/.tmux.conf

echo "== systemd usuario"
mkdir -p ~/.config/systemd/user
cp systemd/*.service ~/.config/systemd/user/ 2>/dev/null; or true
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service 2>/dev/null; or true

echo "== directorios de trabajo"
mkdir -p ~/.ssh/config.d ~/.ssh/cm ~/mnt
chmod 700 ~/.ssh ~/.ssh/cm ~/.ssh/config.d

echo
echo "PENDIENTE MANUAL:"
echo "  1. Clave SSH  -> ~/.ssh/id_rsa (chmod 600)"
echo "  2. Config SSH -> copiar tu ~/.ssh/config y config.d/ desde donde los tengas"
echo "  3. VPN        -> sudo cp etc/openfortivpn.conf.example /etc/openfortivpn/<perfil>.conf"
echo "                   completar el password y chmod 600"
echo "  4. set -Ux VM_LOG_DIR <ruta de logs>; set -Ux OPS_BASE <ruta de bitácora>"
echo "  5. ssh-add ~/.ssh/id_rsa"
echo "  6. Hyprland  -> comparar config/hypr/ contra lo que genere Omarchy"
echo "                 y replicar a mano: monitor, teclado latam, bindings"
