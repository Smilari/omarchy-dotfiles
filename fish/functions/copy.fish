function copy --description 'Copia stdin (o un archivo) al portapapeles. Uso: cmd | copy   /   copy archivo.txt'
    if isatty stdin
        if test (count $argv) -eq 0
            echo "uso: <comando> | copy    o    copy <archivo>"
            return 1
        end
        wl-copy < $argv[1]
        echo "copiado: $argv[1] ("(wc -l < $argv[1])" líneas)"
    else
        set -l tmp (mktemp)
        tee $tmp | wl-copy
        echo "── copiado al portapapeles ("(wc -l < $tmp)" líneas)" >&2
        rm -f $tmp
    end
end

function paste --description 'Pega el portapapeles a stdout'
    wl-paste
end
