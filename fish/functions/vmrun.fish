function vmrun --description 'Ejecuta un comando en una VM y trae la salida local. Uso: vmrun <alias> <comando...>'
    if test (count $argv) -lt 2
        echo "uso: vmrun <alias> <comando>"
        echo "ej:  vmrun prd-his-01 'systemctl status glassfish' | copy"
        return 1
    end
    set -l host $argv[1]
    set -l cmd (string join ' ' -- $argv[2..-1])
    ssh $host "$cmd"
end

function vmrunx --description 'Ejecuta el mismo comando en varias VMs. Uso: vmrunx [-p] "<comando>" host1 host2 ...'
    set -l paralelo 0
    if test "$argv[1]" = -p
        set paralelo 1
        set -e argv[1]
    end
    if test (count $argv) -lt 2
        echo 'uso: vmrunx [-p] "<comando>" <alias> [alias...]'
        echo '  -p  corre en todos a la vez; la salida sale igual, agrupada por host y en orden'
        echo 'ej:  vmrunx -p "uptime" prd-his-0{1,2,3,5,6,7,8,9} | copy'
        return 1
    end
    set -l cmd $argv[1]
    set -l hosts $argv[2..-1]
    if test $paralelo -eq 0
        for h in $hosts
            echo "===== $h ====="
            ssh -n $h "$cmd" 2>&1
            echo
        end
        return
    end
    set -l tmp (mktemp -d)
    for h in $hosts
        # BatchMode: si un host pidiera contraseña, falla en vez de quedar colgado en segundo plano.
        ssh -n -o BatchMode=yes $h "$cmd" >$tmp/$h 2>&1 &
    end
    wait
    for h in $hosts
        echo "===== $h ====="
        cat $tmp/$h
        echo
    end
    rm -rf $tmp
end
