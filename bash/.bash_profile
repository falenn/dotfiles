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
  for host in c0 c1 c2 c3 gpu1
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

function docker() {
    sudo docker $@
}

function docker-compose() {
    sudo docker-compose $@
}

# Fix terminal for linux
export TERM=linux


alias d='docker'
alias dc='docker-compose'
alias k='kubectl'
alias l='ls'
alias ll='ls -la'
alias search='grep -Rn --exclude-dir={log,logs,tmp} --exclude={*.log,.*} . -e '
alias vault='sudo docker run -it --rm \
	-e VAULT_ADDR:VAULT_ADDR \
	--entrypoint="/bin/vault" \
	vault:0.9.3 login'

alias terraform='sudo docker run --network=host --rm -it \
	-v $(pwd):/app \
	-v /.terraform.d/plugins/lunx_amd64/:/plugins/ \
	-v /etc/pki/tls/certs/cacert.crt:/etc/pki/tls/certs/cacert.crt \
	-w /app \
	--log-driver=journald \
	hashicorp/terraform:0.11.3'

# point this script at any inventory file to execute any Ansible cmd on any host
# ex: ansible play playbooks/deploy.yml -i inventory/dev -e "some_var=some_val"
alias ansible='sudo docker run --rm -it \
  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
  -v $(pwd):/ansible_playbooks \
  -v /var/log/ansible/ansible.log \
  walokra/ansible-playbook "$@"'

# run this from within a project directory where the pom.xml exists
#  -v ~/.m2/settings.xml:/usr/share/maven/ref/settings-docker.xml 
# alias mvn='sudo docker run --rm -it \ 
#  -v /data/.m2:/root/.m2 \
#  -v /data/.m2/repository:/usr/share/maven/ref/repository \
#  -v $(pwd):/usr/src/mymaven \
#  -w /usr/src/mymaven \
#  maven \
#  mvn "$@"'


# User specific environment and startup programs
JAVA_HOME=$HOME/apps/java/current
CLASSPATH=$JAVA_HOME/lib/rt.jar:$JAVA_HOME/lib/tools.jar
GRADLE_HOME=$HOME/apps/gradle/current
MAVEN_HOME=$HOME/apps/maven/current
IDEA_HOME=$HOME/apps/intellij/current
PATH=$JAVA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$IDEA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin:$PATH


# run startup functions
hostStatus
export PATH
export CLASSPATH
