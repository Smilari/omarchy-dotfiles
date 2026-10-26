function work --description 'Bitácora: work [filtro] | work new <slug> [-p padre] | work close <slug> | work index'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido. Corré: set -Ux OPS_BASE <ruta del repo>"
        return 1
    end
    set -l base $OPS_BASE/work

    switch "$argv[1]"
        case new
            set -l slug $argv[2]
            if test -z "$slug"
                echo "uso: work new <slug> [-p <padre>]"
                return 1
            end
            set -l parent —
            if test "$argv[3]" = -p -a -n "$argv[4]"
                set parent $argv[4]
                if not test -d $base/$parent
                    echo "no existe el padre: $parent"
                    return 1
                end
            end
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
                "# $slug" '' '## TL;DR' '' '## Próximo paso' '' \
                '## Pendientes' '' '- [ ] ' '' '## Decisiones' '' '## Referencias' '' >$dir/README.md
            printf '# Log — %s\n\nLo más nuevo abajo.\n\n- %s — Creado.\n' $slug $hoy >$dir/log.md
            cd $dir
            $EDITOR README.md

        case close
            set -l slug $argv[2]
            if not test -d $base/$slug
                echo "no existe: $slug"
                return 1
            end
            set -l hoy (date +%F)
            sed -i -E "s/^estado:.*/estado: cerrado/; s/^actualizado:.*/actualizado: $hoy/" $base/$slug/README.md
            printf -- '- %s — Cerrado.\n' $hoy >>$base/$slug/log.md
            git -C $OPS_BASE mv work/$slug archive/$slug; or return 1
            work index
            echo "→ archive/$slug"

        case index
            python3 $OPS_BASE/tools/work-index.py

        case '*'
            set -l sel (python3 $OPS_BASE/tools/work-index.py --list \
                | fzf --prompt 'work> ' --height 70% --reverse --border \
                      --delimiter \t --with-nth 2 --ansi --query "$argv" \
                      --preview "python3 $OPS_BASE/tools/work-index.py --preview {1}" \
                      --preview-window 'right,60%,wrap,<110(down,65%,wrap)')
            test -z "$sel"; and return 1
            cd $base/(string split -f1 \t -- $sel)
    end
end
