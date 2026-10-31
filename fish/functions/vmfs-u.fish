function vmfs-u --description 'Desmontar un sshfs de vmfs. Uso: vmfs-u [alias]  (sin alias: elegir de los montados)'
    set -l host $argv[1]
    if test -z "$host"
        set -l montados (findmnt -rn -t fuse.sshfs -o TARGET | string match "$HOME/mnt/*" | string replace "$HOME/mnt/" '')
        if test (count $montados) -eq 0
            echo "no hay nada montado con vmfs"
            return 0
        end
        set host (printf '%s\n' $montados | fzf --prompt 'desmontar> ' --height 40% --reverse --border)
        test -z "$host"; and return 1
    end
    fusermount3 -u "$HOME/mnt/$host"; and rmdir "$HOME/mnt/$host"; and echo "desmontado $host"
end
