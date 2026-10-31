function __vm_logdir --description 'Carpeta donde vm graba las sesiones'
    if set -q VM_LOG_DIR
        echo $VM_LOG_DIR
    else if set -q OPS_BASE
        echo $OPS_BASE/logs/ssh
    else
        echo /tmp/vm-logs
    end
end
