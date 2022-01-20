function project
  tab --disconnect
end

function random_color
    echo "$argv" | sha256sum | cut -f1 -d' ' | tr -d '\n' | tail -c3
end

function fish_prompt
    set -l prompt_symbol '$'
    set -l prompt_symbol_color (set_color green)
    fish_is_root_user; and set prompt_symbol '#'
    fish_is_root_user; and set prompt_symbol_color (set_color red)

    set tab_name $TAB
    if [ "$tab_name" != "Projects/" ]
      set tab_name (string replace Projects/ "" $tab_name)
    end
    set tab_name (string trim --right --chars "/" $tab_name)

    # WORKAROUND `string sub` does not ignore the colors
    set -l firstlinecolor ( echo -s \
       (set_color normal) \
       (set_color (random_color $tab_name)) \
       (set_color normal) )

    set git_info ""
    if [ (string sub -l 9 "$TAB") = "Projects/" ]; and [ $TAB != "Projects/" ]
       set git_info ( \
         __fish_git_prompt_show_informative_status=1 \
         __fish_git_prompt_showcolorhints=1 \
         __fish_git_prompt_color=yellow \
         fish_git_prompt
       )" "
    end

    set -l firstline ( echo -s (set_color normal) \
       "---- > " \
       (set_color (random_color $tab_name)) \
       $tab_name \
       (set_color normal) \
       " < " \
       (string repeat -n (tput cols) '-')
    )
    echo -s (string sub -l (math (tput cols) + (string length $firstlinecolor)) $firstline)

    echo -s " " (set_color blue) (prompt_pwd) \
    $git_info \
    $prompt_symbol_color $prompt_symbol (set_color normal) " "
end

set -g fzf_history_opts "--preview-window=down:3:wrap"

function kubectl
    for i in (seq (math (count $argv) - 1))
        set oyaml (echo $argv[$i..(math $i + 1)])
        if [ $oyaml = "-o yaml" ]
            command kubectl $argv | bat --language=yaml
            return $status
        end
    end
    command kubectl $argv
end

set -x AWS_PAGER 'bat --language=json'
set -x EDITOR vim
