# Requiere: VPN_PROFILE, VPN_DOMAINS, VPN_DNS_TEST
set -q VPN_PROFILE; or set -g VPN_PROFILE default
set -q VPN_DOMAINS; or set -g VPN_DOMAINS ""
set -q VPN_DNS_TEST; or set -g VPN_DNS_TEST example.internal

function __vpn_iface
    ip -o link show 2>/dev/null | grep -oP ': \Kppp\d+' | head -1
end

function vpn-up --description 'Levanta la VPN Forti y fija los dominios DNS internos'
    sudo systemctl start openfortivpn@$VPN_PROFILE

    # Esperar a que aparezca la interfaz ppp y tenga los DNS que empuja la VPN.
    for i in (seq 20)
        set -l iface (__vpn_iface)
        if test -n "$iface"
            set -l dns (resolvectl dns $iface 2>/dev/null | string replace -r '^[^:]*:' '' | string trim)
            if test -n "$dns"
                vpn-dns
                echo "VPN arriba"
                return 0
            end
        end
        sleep 1
    end
    echo "la VPN no terminó de levantar — revisá: journalctl -u openfortivpn@$VPN_PROFILE -n 30"
    return 1
end

function vpn-down --description 'Baja la VPN Forti'
    sudo systemctl stop openfortivpn@$VPN_PROFILE
    echo "VPN abajo"
end

function vpn-status --description 'Estado de la VPN, IP y DNS interno'
    set -l iface (__vpn_iface)
    echo -n "servicio: "; systemctl is-active openfortivpn@$VPN_PROFILE
    if test -z "$iface"
        echo "interfaz: sin ppp"
        return 1
    end
    echo -n "$iface:     "; ip -4 addr show $iface 2>/dev/null | grep -oP 'inet \K[\d.]+'
    echo -n "dominios: "; resolvectl domain $iface 2>/dev/null | cut -d: -f2-
    echo -n "dns test: "; resolvectl query $VPN_DNS_TEST 2>&1 | head -1
end

function vpn-dns --description 'Fija los dominios de búsqueda internos en la interfaz de la VPN'
    set -l iface (__vpn_iface)
    if test -z "$iface"
        echo "VPN no detectada"; return 1
    end
    sudo resolvectl domain $iface $VPN_DOMAINS
    echo "dominios internos fijados en $iface"
end
