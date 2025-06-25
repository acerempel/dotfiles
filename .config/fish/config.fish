if status is-interactive
    set fish_color_command blue
    set fish_color_normal black
    set fish_color_keyword blue --bold
    set fish_color_quote green

    zoxide init fish | source

    alias vi nvim
end

set -x MAN_POSIXLY_CORRECT 1

fish_add_path ~/.local/bin

if test -d ~/.deno/bin
    fish_add_path ~/.deno/bin
end

set tbtbs ~/.local/share/JetBrains/Toolbox/scripts
if test -d $jbtbs
    fish_add_path $jbtbs
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
if test -d "$BUN_INSTALL"
    fish_add_path "$BUN_INSTALL/bin"
end

set -gx EDITOR nvim

# pnpm
set -gx PNPM_HOME "/home/alan/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end
# pnpm end
