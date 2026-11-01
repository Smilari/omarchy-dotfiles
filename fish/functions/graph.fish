function graph --description 'Token de Microsoft Graph (planner, teams). Uso: graph token | estado | logout'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/graph.py $argv
end
