function __vault_colecciones --description 'Colecciones del último inventario o de bw'
    set -l tsv (path filter -f $OPS_BASE/logs/vault/inventario-*.tsv)[-1]
    test -n "$tsv"; or return
    awk -F'\t' 'NR>1 && $3!="" {n=split($3,a," ; "); for(i=1;i<=n;i++) print a[i]}' $tsv | sort -u
end
set -l sub status lock collections search show get copy create edit move delete inventory backup
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a status -d 'servidor, usuario y si está bloqueado'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a lock -d 'bloquear y borrar la sesión guardada'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a collections -d 'colecciones de la organización'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a search -d 'items por nombre, usuario o URL'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a show -d 'detalle de un item, con contraseña y campos'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a get -d 'un valor por stdout'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a copy -d 'al portapapeles (45 s)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a create -d 'item nuevo (simulacro y confirmación)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a edit -d 'cambiar un item (simulacro y confirmación)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a move -d 'cambiar colecciones'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a delete -d 'a la papelera o definitivo'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a inventory -d 'relevamiento a logs/vault/'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a backup -d 'respaldo cifrado de la organización'
complete -c vault -f -n '__fish_seen_subcommand_from inventory' -l personales -d 'sumar los items personales'
complete -c vault -f -n '__fish_seen_subcommand_from copy get' -a 'pass usuario totp notas'
complete -c vault -f -n '__fish_seen_subcommand_from create edit move' -l coleccion -r -a '(__vault_colecciones)'
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l nombre -r
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l usuario -r
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l url -r
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l campo -r -d 'nombre=valor'
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l pass -r -a 'generar pegar'
complete -c vault -f -n '__fish_seen_subcommand_from create edit' -l notas -d 'abrir el editor'
complete -c vault -f -n '__fish_seen_subcommand_from create edit move delete' -l si -d 'sin confirmación'
complete -c vault -f -n '__fish_seen_subcommand_from delete' -l definitivo -d 'sin papelera'
