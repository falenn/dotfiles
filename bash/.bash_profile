# .bash_profile

if [ -f ~/.git-prompt.sh ]; then
        . ~/.git-prompt.sh
	PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
	GIT_PS1_SHOWUPSTREAM="auto"
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
else
	PS1='\[\033[02;32m\]\u@\H:\[\033[02;34m\]\w\$\[\033[00m\] '
fi

# Setup SSHAgent
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
        eval `ssh-agent`
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# fix term for tmux
export TERM=linux

# iterate through a list of hosts getting their status
# the variable passed in is the NAME of the array of hosts
function hostStatus() {
  for host in c0 c1 c2 c3 
  do
    result=`ping -c 1 $host < /dev/null 2>&1`
    printHostStatus $? $host
  done
}

function printHostStatus() {
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
  DOWN='\033[0;31m' # red
  UP='\033[0;36m'   # light cyan
  NC='\033[0m'      # no color
  if [ "$1" == "0" ]; then
    echo -e "[${UP}UP${NC}] $2"
  else
    echo -e "[${DOWN}DOWN${NC}] $2"
  fi
}

# Fix terminal for linux
export TERM=linux


alias l='ls'
alias ll='ls -la'
alias search='grep -Rn --exclude-dir={log,logs,tmp} --exclude={*.log,.*} . -e'
alias ibVFList="ip link show | egrep ib[0-9]+:"
alias ibPortCount="ip link show | egrep ib[0-9]+: | wc -l"

# User specific environment and startup programs
JAVA_HOME=$HOME/apps/java/current
CLASSPATH=$JAVA_HOME/lib/rt.jar:$JAVA_HOME/lib/tools.jar
GRADLE_HOME=$HOME/apps/gradle/current
MAVEN_HOME=$HOME/apps/maven/current
IDEA_HOME=$HOME/apps/intellij/current
PYENV_ROOT=$HOME/.pyenv
PATH=$PYENV_ROOT/bin:$JAVA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$IDEA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin:$PATH


# run startup functions
# hostStatus
export PATH
export CLASSPATH
export PYENV_ROOT

# Docker inclusion
if [ -f ~/.bash_docker ]; then
    . ~/.bash_docker
fi

# AWS inclusion
if [ -f ~/.bash_aws ]; then
    . ~/.bash_aws
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
