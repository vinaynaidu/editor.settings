
# Aliases
# --------------
alias ls="ls -la"
alias gs="git status"
alias gb="git branch"
alias gp="git push"
# Git prune: Delete all merged branches, except master or dev branch (local only)
alias gpr="git branch --merged | egrep -v \"(^\*|master|dev|develop)\" | xargs git branch -d"


# User functions
# --------------

## create directory and cd into it
mkcd () {
  mkdir "$1"
  cd "$1"
}

# Exctacts archives of different types
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# Goes up N directories. No more cd ../../../../ but "up 4"
up () {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# Recursively find files by pattern
search() {
  # Exclude node modules folder
  find . -name "$1" -not -path *node_modules*
}

# Recursively remove files by pattern. USE CAUTION
remove() {
  find . -name "$1" -not -path "*node_modules*" -exec rm -vf {} \;
}
