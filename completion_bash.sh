# I Have No Idea What I'm Doing - but it works!
# based on http://www.caliban.org/bash/ - especially _man()

_yakulo()
{
    local cur prev scriptpath

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    # default completion if parameter contains / or starts with . or ~
    if [[ "$cur" == */* ]] || [[ "$cur" == .* ]] || [[ "$cur" == ~* ]]; then
        _filedir
        return 0
    fi

    # default value, samev as in script itself
    scriptpath="~/.config/yakulo"

    # prefix is specified
    if [ -n "$cur" ]; then
        scriptpath="${scriptpath}/${cur}*"
    fi

    # redirect stderr for when path doesn't exist
    COMPREPLY=( $( eval command ls "$scriptpath" 2>/dev/null ) )
    # weed out directory path names and paths to man pages
    COMPREPLY=( ${COMPREPLY[@]##*/?(:)} )
    # weed out backup copies (~ ended)
    COMPREPLY=( ${COMPREPLY[@]##*~?(:)} )

    return 0
}

complete -F _yakulo $filenames yakulo
