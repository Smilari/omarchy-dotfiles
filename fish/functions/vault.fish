function vault --description 'VaultWarden del equipo vía bw. Uso: vault estado | buscar | ver | copiar | crear | editar | mover | borrar | colecciones | inventario | lock'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/vault.py $argv
end
