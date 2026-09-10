function gf --description 'Estado resumido de GlassFish. Uso: gf <alias>'
    if test (count $argv) -ne 1
        echo "uso: gf <alias>"
        return 1
    end
    ssh $argv[1] "systemctl is-active glassfish; \
        ps -eo args | grep -o -- '-instancename [^ ]*' | awk '{print \$2}' \
        | grep -v '\[' | sort | tr '\n' ' '; echo"
end
