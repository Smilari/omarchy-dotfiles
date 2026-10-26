function __vm_list --description 'Lista los alias SSH con entorno, descripción e IP'
    # Lee bloque a bloque (RS="") porque la IP aparece después del Host.
    awk '
        BEGIN { RS = ""; FS = "\n" }
        {
            env = ""; desc = ""; host = ""; ip = ""
            for (i = 1; i <= NF; i++) {
                l = $i
                if (l ~ /^# .*\|/) {
                    p = index(l, "|")
                    env  = substr(l, 3, p - 4)
                    desc = substr(l, p + 2)
                    gsub(/[[:space:]]+$/, "", env)
                    gsub(/^[[:space:]]+|[[:space:]]+$/, "", desc)
                } else if (l ~ /^Host /) {
                    split(l, a, " "); host = a[2]
                } else if (l ~ /^[[:space:]]*# ip: /) {
                    sub(/^[[:space:]]*# ip: /, "", l); ip = l
                } else if (l ~ /^[[:space:]]*HostName [0-9]+\./) {
                    split(l, a, " "); ip = a[2]
                }
            }
            if (env == "") env = "-"
            if (host != "") printf "%-4s %-30s %-34s %s\n", env, host, desc, ip
        }
    ' ~/.ssh/config.d/*.conf
end
