function sv --wraps python3 --description 'alias sv=python3 -m http.server'
    command python3 -m http.server $argv
end
