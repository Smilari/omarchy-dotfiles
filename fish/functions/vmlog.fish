function vmlog --description 'Sesiones grabadas por vm: elegir una, verla limpia y dejar una copia en texto. Uso: vmlog [alias]'
    set -l base (__vm_logdir)
    test -n "$argv[1]"; and set base $base/$argv[1]
    if not test -d $base
        echo "no hay sesiones grabadas en $base"
        return 1
    end
    # Lo más nuevo arriba. Se muestra <alias>/<fecha>; el preview ya viene sin códigos de terminal.
    set -l sel (find $base -name '*.log' -printf '%T@\t%p\n' 2>/dev/null | sort -rn | cut -f2 \
        | fzf --prompt 'log> ' --height 80% --reverse --border \
              --delimiter / --with-nth -2.. \
              --preview "sed -E 's/\x1b\[[0-9;?]*[ -\/]*[@-~]//g; s/\x1b\][^\x07]*\x07//g; s/\x1b[()][A-Z0-9]//g; s/\r//g' {} | col -b | tail -n 120" \
              --preview-window 'right,65%,wrap')
    test -z "$sel"; and return 1
    set -l txt (string replace -r '\.log$' '.txt' -- $sel)
    __vmlog_limpio $sel >$txt
    echo "copia limpia → $txt"
    less $txt
end

function __vmlog_limpio --description 'Saca de un log de script(1) los códigos de color, de cursor y los retornos de carro'
    sed -E 's/\x1b\[[0-9;?]*[ -\/]*[@-~]//g; s/\x1b\][^\x07]*\x07//g; s/\x1b[()][A-Z0-9]//g; s/\r//g' $argv[1] | col -b
end
