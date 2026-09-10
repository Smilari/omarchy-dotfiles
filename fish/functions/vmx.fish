function vmx --description 'Multi-exec: abre N VMs en panes tmux sincronizados (equiv. MultiExec de Moba)'
    set -l sel (__vm_list | fzf --multi \
        --prompt 'multi-exec> ' --height 70% --reverse --border \
        --header 'TAB: marcar   Enter: abrir todo en tmux' \
        --query "$argv")
    test -z "$sel"; and return 1

    set -l hosts
    for l in $sel
        set -a hosts (string split -n ' ' -- $l)[2]
    end

    set -l win "multi-"(date +%H%M%S)
    tmux new-session -d -s $win "ssh $hosts[1]"
    for h in $hosts[2..-1]
        tmux split-window -t $win "ssh $h"
        tmux select-layout -t $win tiled
    end
    tmux set-window-option -t $win synchronize-panes on
    tmux attach -t $win
end
