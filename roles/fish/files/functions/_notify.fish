function _notify
    if test (count $argv) -lt 2
        echo "Usage: notify <title> <subtitle>"
        return 1
    end

    switch (uname -s)
        case 'Linux'
            if type -q notify-send
                notify-send "$argv[1]" "$argv[2]"
            else
                echo "notify: unknown notification system" >&2
                return 1
            end
        case 'Darwin'
            osascript -e "display notification \"$argv[1]\" with title \"$argv[2]\""
        case '*'
            echo "Unsupported operating system: $(uname -s)" >&2
            return 1
    end
end
