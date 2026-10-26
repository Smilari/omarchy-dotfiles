# Desactivar mensaje por defecto de Fish
set -g fish_greeting ""

# Banner interactivo de Omarchy
if status is-interactive
    fastfetch
end
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
source ~/.config/fish/functions/vpn.fish
source ~/.config/fish/functions/copy.fish
source ~/.config/fish/functions/vmrun.fish

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
