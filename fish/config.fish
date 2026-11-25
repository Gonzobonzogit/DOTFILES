
#Activate Gonzo theme
if status is-interactive
  starship init fish | source
end


#Aliases
alias ll='lsd -lah'
alias lsa='lsd -a'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gcl='git clone'
alias gb='git branch -M'
alias gstash='git stash'
alias gitrepo='git remote'
alias gp='git push -U'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias pls='sudo'
alias shell-update='source ~/.config/fish/config.fish'
alias sysUpdate='sudo pacman -Syu'
alias ollamaReset='pkill ollama && ollama serve'
alias addpac='sudo pacman -S'
alias search='sudo pacman -Ss'
alias searchAUR='paru -Ss'
alias rmpac='sudo pacman -R'
alias aurRM='paru -R'
alias rsh='source ~/.config/fish/config.fish'
alias root='sudo -i'
alias flash='sudo dd'


