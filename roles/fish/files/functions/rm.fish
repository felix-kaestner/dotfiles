function rm --wraps rm --description 'Remove directory entries; uses trash on MacOS'
    if test (uname) = Darwin
        argparse --min-args=1 -x f,i 'd' 'f' 'i' 'r' -- $argv; or return
        for f in $argv
            if not test -e $f
                echo "Error: File or directory '$f' does not exist." >&2
                return 1
            end

            if test -d $f; and not set -ql _flag_d; and not set -ql _flag_r
                echo "Error: Cannot delete directory '$f' with rm. Use 'rm -d $f' instead." >&2
                return 1
            end

            if set -ql _flag_i; or not test -w $f; and not set -ql _flag_f
                read -l -P "rm: remove '$f'? " answer
                if not string match -iq 'y*' -- $answer
                    continue
                end
            end

            command trash -s $f
        end
    else
        command rm $argv
    end
end
