if status is-interactive
    set fish_color_command blue
    set fish_color_normal black
    set fish_color_keyword blue --bold
    set fish_color_quote green

    zoxide init fish | source
end

fish_add_path ~/.local/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -gx EDITOR nvim

alias vi nvim
