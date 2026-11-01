function __teams_chats --description 'Nombres de chats de la última lista guardada por el flujo'
    set -l lista (path filter -f $OPS_BASE/logs/teams/cache/chats-*.json)[-1]
    test -n "$lista"; or return
    python3 -c 'import json,sys
d=json.load(open(sys.argv[1]))
for c in (d.get("value",[]) if isinstance(d,dict) else d):
    if c.get("topic"): print(c["topic"])' $lista
    set -l md $OPS_BASE/tools/teams-md.tsv
    test -f $md; and awk -F'\t' '!/^#/ && $2 != "" {print "MD " $1}' $md
end
complete -c teams -f -n '__fish_use_subcommand' -a sync -d 'bajar de OneDrive y mostrar qué llegó'
complete -c teams -f -n '__fish_use_subcommand' -a lista -d 'chats con mensajes recientes'
complete -c teams -f -n '__fish_use_subcommand' -a dump -d 'un chat a markdown'
complete -c teams -f -n '__fish_use_subcommand' -a buscar -d 'buscar en todos los chats'
complete -c teams -f -n '__fish_use_subcommand' -a md -d 'resolver teams-md.tsv y armar la condición del flujo'
complete -c teams -f -n '__fish_seen_subcommand_from sync' -s v -d 'un mensaje por línea'
complete -c teams -f -n '__fish_seen_subcommand_from dump' -a '(__teams_chats)'
complete -c teams -f -n '__fish_seen_subcommand_from buscar' -l en -r -a '(__teams_chats)' -d 'solo en este chat'
complete -c teams -f -n '__fish_seen_subcommand_from dump buscar' -l desde -r -d 'AAAA-MM-DD, HH:MM, 3h, 2d'
complete -c teams -f -n '__fish_seen_subcommand_from dump buscar' -l hasta -r
complete -c teams -f -n '__fish_seen_subcommand_from dump buscar' -l autor -r
complete -c teams -f -n '__fish_seen_subcommand_from lista' -l dias -r
