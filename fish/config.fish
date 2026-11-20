# Desactivar mensaje por defecto de Fish
set -g fish_greeting ""

if status is-interactive
    # Banner solo en terminales anchas: en un panel al costado de Claude ocupa media pantalla
    test "$COLUMNS" -ge 140; and fastfetch

    # Prompt en dos líneas (config/starship.toml), saltos con zoxide y atajos de fzf
    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init fish | source   # z <palabra> · zi (picker)
    type -q fzf; and fzf --fish | source             # Ctrl-R historial · Ctrl-T archivo · Alt-C carpeta

    if type -q eza
        alias ls 'eza --group-directories-first --icons=auto'
        alias ll 'eza -la --git --group-directories-first --icons=auto'
        alias lt 'eza -T -L 2 --group-directories-first --icons=auto'
    end
end
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
source ~/.config/fish/functions/vpn.fish
source ~/.config/fish/functions/copy.fish
source ~/.config/fish/functions/vmrun.fish

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
