function br --description 'Launch a timer to take a break for 10 minutes and notify when done'
    if not type -q timer
        echo "br: 'timer' executable not found. Please refer to https://github.com/caarlos0/timer" >&2
        return 1
    end

    timer 10m -n "Break"
    if test $status -eq 0
        _notify "Break is over!" "Get back to work 🫡"
    end
end
