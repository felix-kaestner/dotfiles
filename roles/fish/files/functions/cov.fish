function cov --description 'Go Test Coverage'
    # https://github.com/sapcc/go-makefile-maker
    if test -f Makefile.maker.yaml; and test -f Makefile
        command make build/cover.html
        open build/cover.html
        return
    end

    command go test -coverprofile=c.out ./...
    command go tool cover -html=c.out
end
