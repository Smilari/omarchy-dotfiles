function __vault_colecciones --description 'Colecciones del último inventario o de bw'
    set -l tsv (path filter -f $OPS_BASE/logs/vault/inventario-*.tsv)[-1]
    test -n "$tsv"; or return
    awk -F'\t' 'NR>1 && $3!="" {n=split($3,a," ; "); for(i=1;i<=n;i++) print a[i]}' $tsv | sort -u
end
set -l sub estado lock colecciones buscar ver copiar crear editar mover borrar inventario
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a estado -d 'servidor, usuario y si está bloqueado'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a lock -d 'bloquear y borrar la sesión guardada'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a colecciones -d 'colecciones de la organización'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a buscar -d 'items por nombre, usuario o URL'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a ver -d 'detalle de un item, sin secretos'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a copiar -d 'al portapapeles (45 s)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a crear -d 'item nuevo (simulacro y confirmación)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a editar -d 'cambiar un item (simulacro y confirmación)'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a mover -d 'cambiar colecciones'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a borrar -d 'a la papelera o definitivo'
complete -c vault -f -n "not __fish_seen_subcommand_from $sub" -a inventario -d 'relevamiento sin secretos a logs/vault/'
complete -c vault -f -n '__fish_seen_subcommand_from inventario' -l personales -d 'sumar los items personales'
complete -c vault -f -n '__fish_seen_subcommand_from copiar' -a 'pass usuario totp notas'
complete -c vault -f -n '__fish_seen_subcommand_from crear editar mover' -l coleccion -r -a '(__vault_colecciones)'
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l nombre -r
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l usuario -r
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l url -r
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l campo -r -d 'nombre=valor'
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l pass -r -a 'generar pegar'
complete -c vault -f -n '__fish_seen_subcommand_from crear editar' -l notas -d 'abrir el editor'
complete -c vault -f -n '__fish_seen_subcommand_from crear editar mover borrar' -l si -d 'sin confirmación'
complete -c vault -f -n '__fish_seen_subcommand_from borrar' -l definitivo -d 'sin papelera'
