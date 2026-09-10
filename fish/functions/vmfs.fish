function vmfs --description 'Montar el FS de una VM con sshfs. Uso: vmfs <alias> [ruta_remota]'
    if test (count $argv) -eq 0
        set -l sel (__vm_list | fzf --prompt 'sshfs> ' --height 70% --reverse --border)
        test -z "$sel"; and return 1
        set argv (string split -n ' ' -- $sel)[2]
    end
    set -l host $argv[1]
    set -l rpath /
    test (count $argv) -ge 2; and set rpath $argv[2]
    set -l mnt "$HOME/mnt/$host"
    mkdir -p $mnt
    sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,follow_symlinks,idmap=user \
        $host:$rpath $mnt; or return 1
    echo "$host:$rpath → $mnt"
end

function vmfs-u --description 'Desmontar un sshfs. Uso: vmfs-u <alias>'
    fusermount3 -u "$HOME/mnt/$argv[1]"; and rmdir "$HOME/mnt/$argv[1]"
end
