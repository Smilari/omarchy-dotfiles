function __snapshot_perfiles
    for f in $OPS_BASE/tools/snapshot/*.toml
        path change-extension '' (path basename $f)
    end
end
function __snapshot_ambientes --description 'Ambientes del perfil que ya está en la línea'
    set -l args (commandline -opc)
    set -l p $args[2]
    test "$p" = diff; and set p $args[3]
    test -f $OPS_BASE/tools/snapshot/$p.toml; or return
    string match -rg '^\[hosts\.([a-z0-9]+)\]' <$OPS_BASE/tools/snapshot/$p.toml
end
complete -c snapshot -f -n '__fish_use_subcommand' -a '(__snapshot_perfiles)' -d perfil
complete -c snapshot -f -n '__fish_use_subcommand' -a diff -d 'comparar dos fotos (por defecto, las dos últimas)'
complete -c snapshot -f -n '__fish_use_subcommand' -a lista -d 'fotos guardadas'
complete -c snapshot -f -n '__fish_seen_subcommand_from diff; and test (count (commandline -opc)) -eq 2' -a '(__snapshot_perfiles)'
complete -c snapshot -f -n 'not __fish_use_subcommand; and test (count (commandline -opc)) -le 3' -a '(__snapshot_ambientes)'
