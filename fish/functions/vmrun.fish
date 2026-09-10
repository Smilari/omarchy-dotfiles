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

function vmrunx --description 'Ejecuta el mismo comando en varias VMs. Uso: vmrunx "<comando>" host1 host2 ...'
    if test (count $argv) -lt 2
        echo 'uso: vmrunx "<comando>" <alias> [alias...]'
        echo 'ej:  vmrunx "uptime" prd-his-0{1,2,3} | copy'
        return 1
    end
    set -l cmd $argv[1]
    for h in $argv[2..-1]
        echo "===== $h ====="
        ssh -n $h "$cmd" 2>&1
        echo
    end
end
