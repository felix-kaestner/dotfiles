function wo --description 'Launch a timer to work for 50 minutes and notify when done'
    if not type -q timer
        echo "wo: 'timer' executable not found. Please refer to https://github.com/caarlos0/timer" >&2
        return 1
    end

    timer 50m -n Work
    if test $status -eq 0
        _notify "Work Timer is up!" "Take a Break 😊"
    end
end
