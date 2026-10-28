function teams --description 'Chats grupales de Teams (vía Power Automate + OneDrive). Uso: teams sync | lista | dump <chat> | buscar <texto>'
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
