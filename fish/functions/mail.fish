function mail --description 'Correo de trabajo vía Graph (solo lectura). Uso: mail sync | list | read <clave> | search <palabras> | ticket <ID> | tickets'
    if not set -q OPS_BASE
        echo "OPS_BASE no está definido"
        return 1
    end
    python3 $OPS_BASE/tools/mail.py $argv
end
