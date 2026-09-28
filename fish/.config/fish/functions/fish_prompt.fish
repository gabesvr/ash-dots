# Prompt em duas linhas:  ~/pasta  (branch)
#                         ❯
function fish_prompt
    set -l last $status
    set -l arrow (set_color cyan)'❯'
    test $last -ne 0; and set arrow (set_color red)'❯'

    set -l git ''
    if set -l branch (command git branch --show-current 2>/dev/null)
        set git (set_color brblack)" $branch"
    end

    echo
    echo (set_color brblack)(prompt_pwd)$git
    echo -n $arrow(set_color normal)' '
end
