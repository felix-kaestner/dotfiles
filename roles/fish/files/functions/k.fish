function k --wraps kubectl --description 'alias k=kubectl'
    argparse --ignore-unknown 'd/device=' 's/device-serial=' 'a/aggregate=' 'r/routed-vlan=' 'e/evi=' 'v/vrf=' 'S/service=' 'g/support-group=' -- $argv; or return

    # Label Selectors from https://github.com/ironcore-dev/network-operator/blob/main/api/core/v1alpha1/groupversion_info.go
    set -l label_selector
    if set -ql _flag_device
        set -a label_selector "networking.metal.ironcore.dev/device-name=$_flag_device"
    end
    if set -ql _flag_device_serial
        set -a label_selector "networking.metal.ironcore.dev/device-serial=$_flag_device_serial"
    end
    if set -ql _flag_aggregate
        set -a label_selector "networking.metal.ironcore.dev/aggregate-name=$_flag_aggregate"
    end
    if set -ql _flag_routed_vlan
        set -a label_selector "networking.metal.ironcore.dev/routed-vlan-name=$_flag_routed_vlan"
    end
    if set -ql _flag_evi
        set -a label_selector "networking.metal.ironcore.dev/evi-name=$_flag_evi"
    end
    if set -ql _flag_vrf
        set -a label_selector "networking.metal.ironcore.dev/vrf-name=$_flag_vrf"
    end

    # Label Selectors from https://github.com/sapcc/helm-charts
    if set -ql _flag_service
        set -a label_selector "ccloud/service=$_flag_service"
    end
    if set -ql _flag_support_group
        set -a label_selector "ccloud/support-group=$_flag_support_group"
    end

    if test (count $label_selector) -gt 0
        set -l selector_string (string join ',' $label_selector)
        set argv -l $selector_string $argv
    end

    switch $argv[1]
        case dbg
            set -l pod $argv[2]
            set -l container (k containers $pod | fzf --select-1 --height ~100% --header 'Select a container to debug' --prompt 'Container> ' || return 130)
            command kubectl debug -ti --profile=general --share-processes --image=busybox:1.37.0 --target="$container" $argv[2..-1]
        case dashboard
            if not command kubectl get service -n kube-system headlamp &>/dev/null
                echo "Kubernetes dashboard deployment not found. Please follow the instructions on https://headlamp.dev/docs/latest/installation/in-cluster." >&2
                return 1
            end
            command kubectl -n kube-system port-forward svc/headlamp 8000:80 &>/dev/null &
            set -l pid $last_pid
            function cleanup --on-signal INT --on-signal TERM --inherit-variable pid
                kill -9 $pid
                functions -e cleanup
                return 130
            end
            echo "Serving dashboard on http://localhost:8000 Press Ctrl+C to stop port-forwarding and exit."
            open "http://localhost:8000"
            wait $pid
        case cluster-name
            command kubectl config view --minify -o jsonpath='{.clusters[].name}'
        case containers
            command kubectl get pod $argv[2..-1] -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}'
        case rf
            command kubectl patch $argv[2..-1] -p '[{"op":"remove","path":"/metadata/finalizers"}]' --type=json
        case pause
            command kubectl annotate $argv[2..-1] networking.metal.ironcore.dev/paused=true --overwrite
        case unpause
            command kubectl annotate $argv[2..-1] networking.metal.ironcore.dev/paused-
        case '*'
            command kubectl $argv
    end
end
