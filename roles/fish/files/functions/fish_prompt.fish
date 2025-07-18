function fish_kube_prompt --description 'Prompt function for k8s'
    # If kubectl isn't installed, there's nothing we can do
    # Return 1 so the calling prompt can deal with it
    if not command -sq kubectl
        return 1
    end

    if set -q U8S_CONTEXT; and set -q U8S_NAMESPACE
        echo -n " [⎈ $U8S_CONTEXT|$U8S_NAMESPACE]"
        return 0
    end

    set -l --path conf $KUBECONFIG
    if test (count $conf) -eq 0
        set -a conf "$HOME/.kube/config"
    end

    for file in $conf
        if test -r "$file"
            if not set -q __kubeconfig_timestamp; or test (date -r "$file" +%s) -gt "$__kubeconfig_timestamp"
                set -l ctx (kubectl config current-context 2>/dev/null)
                if test $status -eq 0
                    set -l ns (kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
                    if test -z "$ns"
                        set ns default
                    end
                    set -g __kube_prompt " [⎈ $ctx|$ns]"
                else
                    set -e __kube_prompt
                end
                set -g __kubeconfig_timestamp (date +%s)
            end
        end
    end

    echo -n $__kube_prompt
end

# Based on /usr/share/fish/functions/fish_prompt.fish:4
function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    or set -g fish_color_status red

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix λ
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    echo -s (functions -q fish_ccloud_prompt; and fish_ccloud_prompt) (set_color $color_cwd) (prompt_pwd) (set_color blue) (fish_kube_prompt) $normal (fish_vcs_prompt) $normal " " $prompt_status
    echo -n -s $suffix " "
end
