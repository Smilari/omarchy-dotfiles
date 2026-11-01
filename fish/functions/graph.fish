function graph --description 'Token de Microsoft Graph y sync de todo lo que lo usa. Uso: graph token | estado | sync [mail teams planner] [-v] | logout'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/graph.py $argv
end
