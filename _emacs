#compdef emacs

# TRAMP state
typeset -g TRAMP_METHOD
typeset -g TRAMP_PREFIX
typeset -g TRAMP_PATH
typeset -g TRAMP_HOST

_tramp_parse() {
    local cur=$1

    TRAMP_METHOD=
    TRAMP_PREFIX=
    TRAMP_PATH=
    TRAMP_HOST=

    if [[ $cur == /doas::* ]]; then
        TRAMP_METHOD=doas
        TRAMP_PREFIX=/doas::
        TRAMP_PATH=${cur#/doas::}
        return 0
    fi

    if [[ $cur =~ '^/ssh:([^:]+):(.*)$' ]]; then
        TRAMP_METHOD=ssh
        TRAMP_HOST=$match[1]
        TRAMP_PREFIX="/ssh:${TRAMP_HOST}:"
        TRAMP_PATH="/${match[2]}"
        return 0
    fi

    return 1
}

_tramp_complete_doas() {
    words[CURRENT]=$TRAMP_PATH
    PREFIX=$TRAMP_PATH
    IPREFIX=$TRAMP_PREFIX

    _path_files
}

_tramp_complete_ssh() {
    _message "SSH completion not implemented yet"
}

_emacs() {
    local cur=${words[CURRENT]}

    if _tramp_parse "$cur"; then
        case $TRAMP_METHOD in
            doas)
                _tramp_complete_doas
                return
                ;;
            ssh)
                _tramp_complete_ssh
                return
                ;;
        esac
    fi

    _files
}

_emacs "$@"
