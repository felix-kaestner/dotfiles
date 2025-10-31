function envsource --description 'Source environment variables from a .env file'
    if test (count $argv) -ne 1
        echo "Usage: envsource <path/to/env>"
        return 1
    end

    for line in (cat $argv | grep -v '^#')
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
    end
end
