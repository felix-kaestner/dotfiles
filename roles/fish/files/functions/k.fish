function k --wraps kubectl --description 'alias k=kubectl'
    switch $argv[1]
        case dbg
            set -l pod $argv[2]
            set -l container (k containers $pod)
            switch (count $container)
                case 0
                    echo "No running container found in pod $pod" >&2
                    return 1
                case 1
                    set container $container[1]
                case '*'
                    set container (printf "%s\n" $container | fzf --height ~100% --header 'Select a container to debug' --prompt 'Container> ' || return 130)
            end
            command kubectl debug -ti --profile=general --image=busybox:1.37.0 --target="$container" $argv[2..-1]
        case dashboard
            if not command kubectl get namespace kubernetes-dashboard &>/dev/null; or not command kubectl get service -n kubernetes-dashboard kubernetes-dashboard-web &>/dev/null
                echo "Kubernetes dashboard deployment not found. Please follow the instructions on https://github.com/kubernetes/dashboard?tab=readme-ov-file#installation." >&2
                return 1
            end
            command kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 &>/dev/null &
            set -l pid $last_pid
            function cleanup --on-signal INT --on-signal TERM --inherit-variable pid
                kill -9 $pid
                functions -e cleanup
                return 130
            end
            echo "Serving dashboard on https://localhost:8443. Press Ctrl+C to stop port-forwarding and exit."
            open "https://localhost:8443"
            wait $pid
        case cluster-name
            command kubectl config view --minify -o jsonpath='{.clusters[].name}'
        case containers
            command kubectl get pod $argv[2..-1] -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}'
        case '*'
            command kubectl $argv
    end
end
