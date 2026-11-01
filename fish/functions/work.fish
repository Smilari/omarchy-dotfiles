function work --description 'Bitácora: work [filtro] | new <slug> ["Título"] [-p padre] | log [slug] "texto" | close <slug> | index'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido. Corré: set -Ux OPS_BASE <ruta del repo>"
        return 1
    end
    set -l base $OPS_BASE/work

    switch "$argv[1]"
        case new
            set -l slug ""
            set -l titulo ""
            set -l parent —
            set -l resto $argv[2..-1]
            while test (count $resto) -gt 0
                switch $resto[1]
                    case -p --parent
                        set parent $resto[2]
                        set -e resto[1..2]
                    case '*'
                        if test -z "$slug"
                            set slug $resto[1]
                        else
                            set titulo $resto[1]
                        end
                        set -e resto[1]
                end
            end
            if test -z "$slug"
                echo 'uso: work new <slug> ["Título"] [-p <padre>]'
                return 1
            end
            if test "$parent" != — -a ! -d "$base/$parent"
                echo "no existe el padre: $parent"
                return 1
            end
            test -z "$titulo"; and set titulo $slug
            set -l dir $base/$slug
            if test -e $dir
                echo "ya existe: $dir"
                cd $dir
                return 1
            end
            mkdir -p $dir
            set -l hoy (date +%F)
            printf '%s\n' --- \
                'estado: activo' \
                'esperando: —' "parent: $parent" 'planner: —' 'noc: —' 'mda: —' \
                "actualizado: $hoy" --- \
                "# $titulo" '' '## TL;DR' '' '## Próximo paso' '' \
                '## Pendientes' '' '- [ ] ' '' '## Decisiones' '' '## Referencias' '' >$dir/README.md
            printf '# Log — %s\n\n- %s — Creado.\n' $titulo $hoy >$dir/log.md
            cd $dir
            nano README.md

        case log
            # work log "texto" (parado en la carpeta del item) o work log <slug> "texto"
            set -l slug ""
            set -l texto ""
            if test (count $argv) -ge 3
                set slug $argv[2]
                set texto $argv[3..-1]
            else
                set texto $argv[2]
                set -l aqui (string replace -r "^$base/" '' -- (pwd))
                if test "$aqui" != (pwd)
                    set slug (string split -f1 / -- $aqui)
                end
            end
            if test -z "$slug" -o ! -f "$base/$slug/log.md" -o -z "$texto"
                echo 'uso: work log "texto"   (dentro del item)   o   work log <slug> "texto"'
                return 1
            end
            set -l hoy (date +%F)
            printf '- %s — %s\n' $hoy (string join ' ' -- $texto) >>$base/$slug/log.md
            sed -i -E "s/^actualizado:.*/actualizado: $hoy/" $base/$slug/README.md
            tail -1 $base/$slug/log.md

        case close
            set -l slug $argv[2]
            if test -z "$slug" -o ! -d "$base/$slug"
                echo "no existe: $slug"
                return 1
            end
            set -l hoy (date +%F)
            sed -i -E "s/^estado:.*/estado: cerrado/; s/^actualizado:.*/actualizado: $hoy/" $base/$slug/README.md
            printf '- %s — Cerrado.\n' $hoy >>$base/$slug/log.md
            git -C $OPS_BASE mv work/$slug archive/$slug; or return 1
            work index
            echo "→ archive/$slug"

        case index
            python3 $OPS_BASE/tools/work-index.py

        case '*'
            set -l sel (python3 $OPS_BASE/tools/work-index.py --list \
                | fzf --prompt 'work> ' --height 70% --reverse --border \
                      --header 'Enter: ir a la carpeta · Ctrl-E: README · Ctrl-L: log' \
                      --delimiter \t --with-nth 2 --ansi --query "$argv" \
                      --bind "ctrl-e:execute(nano $base/{1}/README.md)" \
                      --bind "ctrl-l:execute(nano $base/{1}/log.md)" \
                      --preview "python3 $OPS_BASE/tools/work-index.py --preview {1}" \
                      --preview-window 'right,60%,wrap,<110(down,65%,wrap)')
            test -z "$sel"; and return 1
            cd $base/(string split -f1 \t -- $sel)
    end
end
