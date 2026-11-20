set -l sub icinga host logs
complete -c ctx -f -n "not __fish_seen_subcommand_from $sub" -a icinga -d 'problemas abiertos en Icinga'
complete -c ctx -f -n "not __fish_seen_subcommand_from $sub" -a host -d 'Icinga + errores de Loki de un host'
complete -c ctx -f -n "not __fish_seen_subcommand_from $sub" -a logs -d 'logs de Loki de un servicio, cluster o host'
complete -c ctx -f -n '__fish_seen_subcommand_from host' -a '(__vm_list | awk "{print \$2}")'
complete -c ctx -f -n '__fish_seen_subcommand_from icinga logs' -l env -r -a 'prd hml qa dev todo'
complete -c ctx -f -n '__fish_seen_subcommand_from icinga logs' -l todos -d 'también lo atendido / todas las líneas'
complete -c ctx -f -n '__fish_seen_subcommand_from host logs' -l desde -r -d '15m, 4h, 1d'
complete -c ctx -f -n '__fish_seen_subcommand_from logs' -l buscar -r -d 'texto'
