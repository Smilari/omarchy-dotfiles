function ops --description 'Saltar a una entrada de bitácora. Uso: ops [filtro]'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"; return 1
    end
    set -l sel (find $OPS_BASE/01-Tickets $OPS_BASE/02-Tareas -mindepth 3 -maxdepth 3 -type d 2>/dev/null \
                    | sed "s|$OPS_BASE/||" | sort -t/ -k4 -r \
                    | fzf --prompt 'bitácora> ' --height 60% --reverse --border --query "$argv")
    test -z "$sel"; and return 1
    cd "$OPS_BASE/$sel"
    pwd
end
