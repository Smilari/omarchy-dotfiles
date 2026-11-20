function vault --description 'VaultWarden del equipo vía bw. Uso: vault status | search | show | get | copy | create | edit | move | delete | collections | inventory | backup | lock'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/vault.py $argv
end
