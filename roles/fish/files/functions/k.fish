complete -c k -a "cluster-name" -d "Print cluster name"
complete -c k -a "get-pod-names" -d "Print name(s) of the pod(s) matching the given label selector"
complete -c k -a "get-pod-containers" -d "Print name(s) of the container(s) within a pod"

function k --wraps kubectl --description 'alias k=kubectl'
    switch $argv[1]
        case cluster-name
            command kubectl config view --minify -o jsonpath='{.clusters[].name}'
        case get-pod-names
            command kubectl get pod $argv[2..-1] -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
        case get-pod-containers
            command kubectl get pod $argv[2..-1] -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}'
        case '*'
            command kubectl $argv
    end
end
