function snapshot --description 'Fotos de estado de VMs antes y después de una maniobra. Uso: snapshot <perfil> <amb> [etiqueta] | diff <perfil> <amb> [A [B]] | lista'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/snapshot.py $argv
end
