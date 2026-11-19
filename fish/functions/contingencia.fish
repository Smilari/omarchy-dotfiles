function contingencia --description 'Contingencias: contingencia [filtro] | nueva "Título" [--hora HH:MM] | nota "texto" [--hora HH:MM] | fin [--hora HH:MM] | cerrar | issue | pdf'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    set -l py $OPS_BASE/tools/contingencia.py
    set -l base $OPS_BASE/contingencias
    switch "$argv[1]"
        case nueva
            set -l dir (python3 $py $argv); or return 1
            cd $dir
            echo "→ $dir"
        case nota fin cerrar issue pdf
            python3 $py $argv
        case '*'
            set -l sel (python3 $py --list \
                | fzf --prompt 'contingencia> ' --height 70% --reverse --border \
                      --header 'Enter: ir a la carpeta · Ctrl-E: README · Ctrl-L: log' \
                      --delimiter \t --with-nth 2 --ansi --query "$argv" \
                      --bind "ctrl-e:execute(nano $base/{1}/README.md)" \
                      --bind "ctrl-l:execute(nano $base/{1}/log.md)" \
                      --preview "python3 $py --preview {1}" \
                      --preview-window 'right,60%,wrap,<110(down,65%,wrap)')
            test -z "$sel"; and return 1
            cd $base/(string split -f1 \t -- $sel)
    end
end
