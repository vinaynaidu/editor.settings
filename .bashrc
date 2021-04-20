# Aliases
# --------------
alias gls="git log --pretty=oneline"
alias gchm="git checkout master"
alias gds="git diff --cached"
alias gmt="git mergetool"
alias gch="git checkout"
alias gb="git branch"
alias gpl="git pull"
alias gd="git diff"
alias gl="git log"
alias gp="git push"
alias gs="git status"
alias ga="git add --all"
alias gc="commit_with_id"
alias gmm="git merge master"
alias ls="ls -al --color=auto"
alias gchd="git checkout develop"
alias gll="git log --all --oneline --graph --decorate"
# Git prune: Delete all merged branches, except master or dev branch (local only)
alias gpr="git branch --merged | egrep -v \"(^\*|master|dev|develop)\" | xargs git branch -d"

# Angular
alias ngn="ng new --style=scss" # I always forget to set scss flag
alias ngc="ng g c"
alias ngs="ng g s"
alias ngm="ng g m"

# Npm
alias npl="npm list -g --depth=0"
alias npll="npm list --depth=0"
alias npm-get="npm pack" # Get package tarball tarball from registry, put it in current working directory

# Grunt
alias grb="grunt bam"
alias grl="grunt lite"
alias grs="grunt serve"

# lein
alias lein="~/lein.bat"
alias lr="lein run"

# Misc
alias c="clear"
alias ex="explorer ." # Open explorer in current folder
alias cc="while true; do head -c200 /dev/urandom | od -An -w50 -x | grep -E --color \"([[:alpha:]][[:digit:]]){2}\"; sleep 0.5; done"


# Alias section end

# User functions
# --------------

# Create directory and cd into it. CD into directory if it already exists
mkcd() {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Git commit and push
gcp() {
  commit_with_id "$1" "push";
}

# Automatically prepends current branch ID to git commit message
# Use "push" as second arg to commit and push
# branch name shoule be feature/11111-any-name-here. Supports bugfix too
commit_with_id()
{
	# 1. Get branch name
	branch_name=$(git symbolic-ref --short -q HEAD)
	branch_matcher='(feature|bugfix)/(\d+)-';
	id_matcher='(\d+)'

	# 2. Check if current branch is in recognised format
	matched=$(echo "$branch_name" | grep -o -P "$branch_matcher");

	if [ $matched ] ; then
		# Is a feature branch, add feature id to commit
		feature_id=$(echo "$matched" | grep -o -P "$id_matcher" | head -n1);

		# echo "committing with id: $feature_id"
		git commit -a -m "#$feature_id - $1"

	else
		# Not a branch with id, commit as norm
		git commit -a -m "$1"
	fi

	# 3. git push if requested
	if [ "$2" == "push" ] ; then
		# echo "performing git push"
		git push
	fi
}

# Exctacts archives of different types
extract() {
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
up() {
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
  find . -name "$1" -not -path "*node_modules*"
}

# Recursively remove files by pattern. USE CAUTION
remove() {
  find . -name "$1" -not -path "*node_modules*" -exec rm -vf {} \;
}

# Create branch and checkout into it
gfb() {
  gb $1 && gch $1
}

# Print all aliases.
halp() {
  # /d/Development/codelab/c#/AliasPrint/AliasPrint/bin/Debug/AliasPrint.exe
  # ./devTools/scripts/alias_print.sh

  FILENAME="$HOME/.bashrc"

  # Colors
  Red='\033[0;31m'
  Black='\033[0;30m'
  Green='\033[0;32m'
  Brown='\033[0;33m'
  Blue='\033[0;34m'
  Purple='\033[0;35m'
  Cyan='\033[0;36m'
  LightGray='\033[0;37m'
  DarkGray='\033[1;30m'
  LightRed='\033[1;31m'
  LightGreen='\033[1;32m'
  Yellow='\033[1;33m'
  LightBlue='\033[1;34m'
  LightPurple='\033[1;35m'
  LightCyan='\033[1;36m'
  White='\033[1;37m'
  NC='\033[0m' # No colour

  while read -r LINE; do

      if [[ "$LINE" == *"# Alias section end"* ]]; then
        # Quit after alias sections
        break
      fi

      if [[ "$LINE" == "#"* ]]; then
        # Comments
        echo -e "${DarkGray}$LINE"

    elif [[ "$LINE" == "alias"* ]]; then
      # Aliases - extract parts for colours. Eg:
      # alias gs="git status"
      # Where gs = alias
      # git status = command

      # Command=$(echo $LINE | cut -d'=' -f 2)
      # Alias=$(echo $LINE | cut -d'=' -f 1 | cut -d' ' -f 2)

      IFS="=" read Alias Command <<< "${LINE#alias }"

      echo -e "${NC}alias ${Brown}$Alias${DarkGray}=${LightBlue}$Command"

      else
        # Uninteresting line
        echo -e "${NC}$LINE"
      fi

  done < "$FILENAME"
}
