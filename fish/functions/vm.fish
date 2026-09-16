function vm --description 'Conectar a una VM (fzf). Uso: vm [-u USUARIO] [filtro]'
    set -l override_user ""
    set -l query ""

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -u --user
                set i (math $i + 1)
                set override_user $argv[$i]
            case '*'
                set query "$query $argv[$i]"
        end
        set i (math $i + 1)
    end
    set query (string trim -- $query)

    set -l sel (__vm_list | fzf \
        --prompt 'ssh> ' --height 70% --reverse --border \
        --header 'Enter: conectar   Ctrl-U: elegir otro usuario   Ctrl-C: salir' \
        --expect ctrl-u \
        --preview 'ssh -G {1} | grep -E "^(hostname|user|port) "' \
        --preview-window up:4:border-rounded \
        --color 'hl:red,hl+:red' \
        --query "$query")

    test -z "$sel"; and return 1

    set -l key $sel[1]
    set -l line $sel[2]
    set -l host (string split -n ' ' -- $line)[2]

    if test "$key" = ctrl-u
        read -P "usuario para $host: " override_user
    end

    set -l target $host
    if test -n "$override_user"
        set target "$override_user@$host"
    end

    if string match -q 'prd*' -- $host; or string match -q '*gogies*' -- $host
        set_color -o red; echo "⚠  PRODUCCIÓN → $target"; set_color normal
    end

    if test "$VM_LOG" = 0
        ssh $target
        return
    end

    if not set -q VM_LOG_DIR
        set -g VM_LOG_DIR /tmp/vm-logs
        echo "⚠  VM_LOG_DIR no definido, logueando en /tmp/vm-logs"
    end
    set -l dir "$VM_LOG_DIR/$host"
    mkdir -p $dir

    # OJO: en fish, concatenar una substitución vacía anula TODA la cadena.
    # Por eso el sufijo se arma en una variable aparte.
    set -l stamp (date +%Y-%m-%d_%H%M%S)
    set -l suffix ""
    test -n "$override_user"; and set suffix "_$override_user"
    set -l f "$dir/$stamp$suffix.log"

    script -q -c "ssh $target" $f
    echo "log → $f"
end
