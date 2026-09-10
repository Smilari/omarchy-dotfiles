# Guardar en ~/.config/fish/completions/vm.fish (NO en functions/)
complete -c vm    -f -a '(__vm_list | string split -f1 " ")'
complete -c vmx   -f -a '(__vm_list | string split -f1 " ")'
complete -c vmfs  -f -a '(__vm_list | string split -f1 " ")'
complete -c vmfs-u -f -a '(__vm_list | string split -f1 " ")'
