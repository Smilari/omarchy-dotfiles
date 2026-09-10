function cls --description 'Limpia pantalla Y scrollback, dentro o fuera de tmux'
    # \033[2J borra la pantalla, \033[3J borra el scrollback, \033[H sube el cursor
    printf '\033[2J\033[3J\033[H'
    # tmux mantiene su propio buffer aparte del de la terminal
    if set -q TMUX
        tmux clear-history
    end
end
