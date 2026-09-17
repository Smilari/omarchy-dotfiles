function task --description 'Crea una entrada en 02-Tareas (Planner). Uso: task <asunto>'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido. Corré: set -Ux OPS_BASE <ruta del repo>"
        return 1
    end
    if test (count $argv) -eq 0
        echo "uso: task <nombre de la tarjeta del Planner>"
        return 1
    end
    set -l asunto (string join ' ' -- $argv)

    set -l cat (__ops_pick "categoría" \
        "🚀 Arquitectura y CI/CD" \
        "🔧 Refactor y Normalización" \
        "📦 Migraciones y Releases" \
        "🔬 Investigación y POC" \
        "🎯 Proyecto Especial")
    test -z "$cat"; and set cat "🎯 Proyecto Especial"

    set -l hoy (date +%Y-%m-%d)
    set -l hora (date +%H:%M)
    set -l dir "$OPS_BASE/02-Tareas/"(date +%Y)"/"(__ops_mes)"/$hoy "(__ops_slug "$asunto")
    mkdir -p $dir

    if test "$cat" = "📦 Migraciones y Releases"
        mkdir -p "$dir/Images" "$dir/Scripts"
    end

    set -l f "$dir/README.md"
    if test -f $f
        echo "ya existe: $f"
        cd $dir
        __ops_open $f
        return 0
    end

    printf '%s\n' \
        "# Tarea (Planner): $asunto" \
        "" \
        "**Fecha Inicio:** $hoy $hora" \
        "**Categoría:** $cat" \
        "**Estado:** 🔵 To-Do" \
        "**Ticket ASI/NOC:** —" \
        "" \
        "---" \
        "" \
        "## 🎯 Objetivo General" \
        "" \
        "" \
        "## 📝 Tareas / Progreso" \
        "" \
        "- [ ] " \
        "" \
        "## 🔍 Hallazgos / Evidencia" \
        "" \
        "### Entorno DEV" \
        "" \
        "### Entorno QA" \
        "" \
        "### Entorno HML" \
        "" \
        "### Entorno PRD" \
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
    cd $dir
    __ops_open $f
end
