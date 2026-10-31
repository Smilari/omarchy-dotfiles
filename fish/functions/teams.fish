function teams --description 'Chats grupales de Teams (Power Automate + OneDrive). Uso: teams sync [-v] | lista | dump <chat> | buscar <palabras>'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    # El token lo resuelve graph.py: sync lo exige; lista, dump y buscar usan la copia local si no hay.
    python3 $OPS_BASE/tools/teams.py $argv
end
