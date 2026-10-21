function myq --description 'SQL en uno o varios MySQL por SSH. Uso: myq [-f] "<sql>"|archivo.sql host...'
    set -l force 0
    if test (count $argv) -gt 0; and test "$argv[1]" = -f
        set force 1
        set -e argv[1]
    end

    if test (count $argv) -lt 2
        echo 'uso: myq [-f] "<sql>" | archivo.sql   host [host...]'
        echo '  -f  salta la confirmación de escritura en PRD'
        echo 'ej:  myq "USE sigehos; SELECT COUNT(*) FROM auth_user" prd-bbdd-master'
        echo '     myq "SHOW SLAVE STATUS\\G" prd-bbdd-slave'
        echo '     myq consultas/migracion.sql hml-bbdd01 | copy'
        return 1
    end

    set -l sql $argv[1]
    test -f "$sql"; and set sql (cat $sql | string collect)
    set -l hosts $argv[2..-1]

    # Busca escritura en TODO el SQL, no solo en la primera sentencia:
    # un .sql de los devs puede traer el DELETE en el medio.
    set -l escritura (string match -ragi \
        '\b(UPDATE|DELETE|INSERT|REPLACE|DROP|ALTER|TRUNCATE|CREATE|GRANT|REVOKE|SET +PASSWORD)\b' \
        -- $sql)

    set -l en_prd (string match -r '^prd.*' -- $hosts)
    if test (count $en_prd) -gt 0 -a (count $escritura) -gt 0 -a $force -eq 0
        set_color -o red
        echo "⚠  SQL con ESCRITURA sobre PRODUCCIÓN: $en_prd"
        set_color normal
        echo "   detectado: "(string upper -- (string join ', ' -- $escritura))
        echo "   líneas:"
        string split -n \n -- $sql \
            | string match -rgi '^(.*\b(?:UPDATE|DELETE|INSERT|REPLACE|DROP|ALTER|TRUNCATE|CREATE|GRANT|REVOKE)\b.*)$' \
            | head -5 | sed 's/^/     /'
        read -P "   escribí SI para continuar: " confirmacion
        if test "$confirmacion" != SI
            echo "cancelado"
            return 1
        end
    end

    set -l fallidos
    for h in $hosts
        set_color -o; echo "===== $h ====="; set_color normal
        if not printf '%s\n' $sql | ssh $h 'if sudo -n test -f /root/.my.cnf; then sudo -n -H mysql -t; else sudo -n mysql --defaults-file=/etc/mysql/debian.cnf -t; fi' 2>&1
            set -a fallidos $h
        end
        echo
    end

    if test (count $fallidos) -gt 0
        set_color yellow
        echo "fallaron: $fallidos"
        set_color normal
        return 1
    end
end
