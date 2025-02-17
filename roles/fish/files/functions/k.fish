complete -c k -a "cluster-name" -d "Display cluster name"

function k --wraps kubectl --description 'alias k=kubectl'
    switch $argv[1]
        case cluster-name
            command kubectl config view --minify -o jsonpath='{.clusters[].name}'
        case '*'
            command kubectl $argv
    end
end
