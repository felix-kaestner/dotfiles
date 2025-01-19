complete -c kc -a "cluster-name" -d "Display cluster name"

function kc --wraps kubectl --description 'alias kc=kubectl'
    switch $argv[1]
        case cluster-name
            command kubectl config view --minify -o jsonpath='{.clusters[].name}'
        case '*'
            command kubectl $argv
    end
end
