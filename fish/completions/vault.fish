complete -c vault -f -n '__fish_use_subcommand' -a estado -d 'servidor, usuario y si está bloqueado'
complete -c vault -f -n '__fish_use_subcommand' -a inventario -d 'relevamiento sin secretos a logs/vault/'
complete -c vault -f -n '__fish_use_subcommand' -a lock -d 'bloquear y borrar la sesión guardada'
complete -c vault -f -n '__fish_seen_subcommand_from inventario' -l personales -d 'sumar los items personales'
