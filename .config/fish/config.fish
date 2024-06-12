if status is-interactive
    set fish_color_command blue
    set fish_color_normal black
    set fish_color_keyword blue --bold
    set fish_color_quote green

    zoxide init fish | source
end

fish_add_path ~/.local/bin
if test -d ~/.deno/bin
    fish_add_path ~/.deno/bin
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
if test -d "$BUN_INSTALL"
    set --export PATH $BUN_INSTALL/bin $PATH
end

set -gx EDITOR nvim

alias vi nvim

# pnpm
if test "$(uname)" = Linux
    set -gx PNPM_HOME "/home/alan/.local/share/pnpm"
end

if set -q PNPM_HOME; and not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
