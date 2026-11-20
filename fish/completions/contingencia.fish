set -l sub new log end close issue pdf
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a new -d 'contingencia nueva (queda activa)'
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a log -d 'línea en la timeline'
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a end -d 'servicio normalizado: pasa a seguimiento'
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a close -d 'cerrarla (y el issue)'
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a issue -d 'crear o actualizar el issue en GitLab'
complete -c contingencia -f -n "not __fish_seen_subcommand_from $sub" -a pdf -d 'informe en PDF'
complete -c contingencia -f -n '__fish_seen_subcommand_from new log end' -l hora -r -d 'HH:MM'
