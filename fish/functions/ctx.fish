function ctx --description 'Contexto de monitoreo (Icinga y Loki) en un Markdown. Uso: ctx icinga [--env E] [--todo] | host <alias> [--desde 1h] | logs <objetivo> [--desde 1h] [--buscar T] [--todo]'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/ctx.py $argv
end
