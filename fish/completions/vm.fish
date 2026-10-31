# Alias SSH: segunda columna de __vm_list (la primera es el entorno).
function __vm_alias
    __vm_list | awk '{print $2}'
end
complete -c vm     -f -a '(__vm_alias)'
complete -c vmx    -f -a '(__vm_alias)'
complete -c vmfs   -f -a '(__vm_alias)'
complete -c vmrun  -f -n '__fish_is_first_arg' -a '(__vm_alias)'
complete -c vmrunx -f -n 'not __fish_is_first_arg' -a '(__vm_alias)'
complete -c vmrunx -f -s p -d 'en paralelo'
complete -c gf     -f -a '(__vm_alias | string match -r "^(prd-his|prd-3ros|.*java).*")'
complete -c myq    -f -n 'not __fish_is_first_arg' -a '(__vm_alias | string match "*bbdd*")'
complete -c vmfs-u -f -a '(findmnt -rn -t fuse.sshfs -o TARGET | string match "$HOME/mnt/*" | string replace "$HOME/mnt/" "")'
complete -c vmlog  -f -a '(path basename (__vm_logdir)/*)'
