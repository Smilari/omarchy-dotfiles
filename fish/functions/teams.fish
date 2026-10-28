function teams --description 'Mensajes de chats y canales de Teams vía Graph. Uso: teams lista [filtro] | dump <conv> | buscar <texto>'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    if not set -q GRAPH_TOKEN
        echo "Sin token. Copialo de Graph Explorer (pestaña Access token) y corré: planner token"
        return 1
    end
    python3 $OPS_BASE/tools/teams.py $argv
end
