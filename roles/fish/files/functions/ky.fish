function ky --wraps 'kubectl get' --description 'Render kubectl YAML output with yq'
    set -l kubectl_args $argv
    set -l query

    if test (count $kubectl_args) -gt 0
        set -l last_arg $kubectl_args[-1]
        if string match -q '.*' -- "$last_arg"; and not string match -q './*' -- "$last_arg"; and not string match -q '../*' -- "$last_arg"
            set query "$last_arg"
            set -e kubectl_args[-1]
        end
    end

    for arg in $kubectl_args
        if string match -qr '^-o.+$|^(-o|--output)$|^--output=' -- "$arg"
            echo 'ky: output options are not allowed; ky always uses -o yaml' >&2
            return 2
        end
    end

    command kubectl get $kubectl_args -o yaml | command yq $query
end
