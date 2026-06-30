if status is-interactive
    fastfetch

    # Better history search (up arrow = prefix search)
    bind \e\[A history-search-backward
    bind \e\[B history-search-forward

    # Aliases
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first'
    alias cat='bat'
    alias grep='rg'
    alias paru='paru --skipreview'
    alias vim='nvim'

    # Dotfiles function (persisted via funcsave normally, but fine here too)
    function dotfiles
        git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
    end

    # Useful for CachyOS/paru workflows
    function update
        paru -Syu
    end
end

# Environment
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERM xterm-kitty

starship init fish | source
