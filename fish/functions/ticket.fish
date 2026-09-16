function ticket --description 'Crea una entrada en 01-Tickets. Uso: ticket <asunto>'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido. Corré: set -Ux OPS_BASE <ruta del repo>"
        return 1
    end
    set -q TICKET_URL_BASE; or set -l TICKET_URL_BASE ""
    if test (count $argv) -eq 0
        echo "uso: ticket <asunto del requerimiento o falla>"
        return 1
    end
    set -l asunto (string join ' ' -- $argv)

    echo "--- TICKET ---"
    read -P "🎫 ID MDA (Enter para omitir): " input_id

    set -l track_id "N/A"
    set -l link_md ""
    set -l m (string match -ri '([a-z0-9]{3}-[a-z0-9]{3}-[a-z0-9]{4})' -- "$input_id")
    if test (count $m) -ge 2
        set track_id (string upper $m[2])
        set link_md "**🔗 MDA:** [$track_id]($TICKET_URL_BASE$track_id)"
    end

    set -l cat (__ops_pick "categoría" \
        "🔥 Incidente / Falla" \
        "👁️ Monitoreo" \
        "📋 Documentación e Inventario" \
        "⚙️ Configuración y Setup" \
        "🗄️ Operaciones BBDD" \
        "🔐 Accesos y Permisos" \
        "🖥️ Operaciones en VMs / Infra" \
        "📌 Requerimiento General")
    test -z "$cat"; and set cat "📌 Requerimiento General"

    set -l hoy (date +%Y-%m-%d)
    set -l hora (date +%H:%M)
    set -l dir "$OPS_BASE/01-Tickets/"(date +%Y)"/"(__ops_mes)"/$hoy "(__ops_slug "$asunto")
    mkdir -p $dir

    if test "$cat" = "🗄️ Operaciones BBDD"
        mkdir -p "$dir/Scripts" "$dir/Out"
        touch "$dir/Out/Output.txt"
    end

    set -l f "$dir/README.md"
    if test -f $f
        echo "ya existe: $f"
        __ops_open $f
        return 0
    end

    printf '%s\n' \
        "# Ticket: $asunto" \
        "" \
        "$link_md" \
        "**Fecha:** $hoy $hora | **ID MDA:** $track_id" \
        "**Categoría:** $cat" \
        "**Estado:** 🟡 En Progreso" \
        "**Ticket ASI/NOC:** —" \
        "" \
        "---" \
        "" \
        "## 📝 Solicitud / Objetivo" \
        "" \
        "" \
        "## 🔍 Acciones / Logs" \
        "" \
        "" \
        "## 🚧 Bloqueos" \
        "" \
        "> Sin bloqueos por el momento." \
        "" \
        "## ➡️ Próximos Pasos" \
        "" \
        "- [ ] " \
        "" \
        "## 📎 Tickets ASI Generados" \
        "" \
        "> *(Completar si se derivó algún ticket a NOC/ASI — formato: ASI #XXXXXX — descripción breve)*" \
        > $f

    echo "→ $f"
    __ops_open $f
end
