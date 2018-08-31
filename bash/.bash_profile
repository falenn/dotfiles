#
#
#
if [ -f ~/.bash_git ]; then
	. ~/.bash_git
fi


if [ ! -S ~/.ssh/ssh_auth_sock ]; then
	eval `ssh-agent`
	ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

# Fix terminal for linux
export TERM=linux

function docker() {
	sudo docker $@
}

function docker-compose() {
	sudo docker-compose $@
}

alias d='docker'
alias dc='docker-compose'
alias k='kubectl'

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

