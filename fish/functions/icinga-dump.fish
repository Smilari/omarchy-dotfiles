function icinga-dump --description 'Volcado de la config y el estado de Icinga (solo lectura). Uso: icinga-dump [-o DIR] [--sin-estado] | diff [A] [B]'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/icinga-dump.py $argv
end
