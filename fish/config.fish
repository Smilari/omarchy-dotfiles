# Desactivar mensaje por defecto de Fish
set -g fish_greeting ""

# Banner interactivo de Omarchy
if status is-interactive
    fastfetch
end
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
source ~/.config/fish/functions/vpn.fish
source ~/.config/fish/functions/__ops_common.fish
source ~/.config/fish/functions/copy.fish
source ~/.config/fish/functions/vmrun.fish
