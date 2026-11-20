function __mail_tickets --description 'IDs de tickets de la copia local'
    set -l c $OPS_BASE/logs/mail/cache/mensajes.json
    test -f $c; or return
    python3 -c 'import json,re,sys
v=json.load(open(sys.argv[1]))["mensajes"].values()
ids=set()
for m in v:
    a=m.get("asunto","")
    x=re.search(r"\[#([A-Z0-9]{3}-[A-Z0-9]{3}-[A-Z0-9]{4})\]",a) or re.search(r"#+(RE-\d{6,8})",a)
    if x: ids.add(x.group(1))
print("\n".join(sorted(ids)))' $c
end
complete -c mail -f -n '__fish_use_subcommand' -a sync -d 'bajar lo nuevo a la copia local'
complete -c mail -f -n '__fish_use_subcommand' -a list -d 'mails recientes por tipo'
complete -c mail -f -n '__fish_use_subcommand' -a read -d 'un mail entero por su clave'
complete -c mail -f -n '__fish_use_subcommand' -a search -d 'buscar en el servidor'
complete -c mail -f -n '__fish_use_subcommand' -a ticket -d 'historia de un ticket NOC o MDA'
complete -c mail -f -n '__fish_use_subcommand' -a tickets -d 'tickets abiertos cruzados con la bitácora'
complete -c mail -f -n '__fish_seen_subcommand_from sync' -l dias -r
complete -c mail -f -n '__fish_seen_subcommand_from list' -l tipo -r -a 'asi asi-grupo mda mda-grupo grupo directo'
complete -c mail -f -n '__fish_seen_subcommand_from list' -l no-leidos
complete -c mail -f -n '__fish_seen_subcommand_from list search' -l desde -r -d 'AAAA-MM-DD, HH:MM, 3h, 2d'
complete -c mail -f -n '__fish_seen_subcommand_from list' -l encuestas -d 'mostrar las encuestas de ASI'
complete -c mail -f -n '__fish_seen_subcommand_from ticket' -a '(__mail_tickets)'
complete -c mail -f -n '__fish_seen_subcommand_from tickets' -l todos -d 'también los cerrados'
complete -c mail -f -n '__fish_seen_subcommand_from tickets' -l grupo -d 'también los del grupo'
complete -c mail -f -n '__fish_seen_subcommand_from tickets' -l tipo -r -a 'noc mda'
