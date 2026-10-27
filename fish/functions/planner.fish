function planner --description 'Planners de Microsoft vía Graph. Uso: planner token | plans | dump <planId> | sync | apply <archivo> [--si]'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    if test "$argv[1]" = token
        # El token de Graph Explorer empieza con eyJ (JWT). Se toma del portapapeles
        # y queda solo en esta sesión: nunca como variable universal.
        set -l tok (wl-paste 2>/dev/null | string trim)
        if not string match -q 'eyJ*' -- $tok
            read -s -P "Pegá el access token de Graph Explorer: " tok
        end
        set -gx GRAPH_TOKEN $tok
        echo "token cargado para esta sesión (dura ~1 h)"
        return 0
    end
    if not set -q GRAPH_TOKEN
        echo "Sin token. Copialo de Graph Explorer (pestaña Access token) y corré: planner token"
        return 1
    end
    python3 $OPS_BASE/tools/planner.py $argv
end
