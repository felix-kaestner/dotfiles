function kg --description 'Terminate the GPG agent'
    gpg-connect-agent updatestartuptty /bye >/dev/null
end
