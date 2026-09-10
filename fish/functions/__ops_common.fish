# Helpers compartidos por `ticket` y `task`.
# Cargar con: source ~/.config/fish/functions/__ops_common.fish

set -q OPS_BASE; or set -gx OPS_BASE "$HOME/ops"

function __ops_mes --description 'Devuelve MM-Mes en español, sin depender del locale'
    set -l meses enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre
    set -l n (date +%m)
    echo (string join '' $n '-' $meses[(math $n + 0)])
end

function __ops_slug --description 'Limpia un asunto para usarlo como nombre de carpeta'
    string replace -ra '[\\/]' '-' -- "$argv" \
    | string replace -ra '[:*?"<>|]' '' \
    | string trim
end

function __ops_pick --description 'Selector fzf. Uso: __ops_pick "Título" opcion1 opcion2 ...'
    set -l titulo $argv[1]
    printf '%s\n' $argv[2..-1] | fzf --prompt "$titulo> " --height 40% --reverse --border
end

function __ops_open --description 'Abre el archivo con el editor configurado'
    set -q EDITOR; or set -gx EDITOR nano
    $EDITOR $argv[1]
end
