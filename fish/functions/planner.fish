function planner --description 'Planners de Microsoft vía Graph. Uso: planner plans | dump <planId> | sync | apply <archivo> [--si]'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    # `planner token` quedó como atajo del token compartido de `graph`.
    if test "$argv[1]" = token
        graph token
        return
    end
    python3 $OPS_BASE/tools/planner.py $argv
end
