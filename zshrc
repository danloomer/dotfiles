source /etc/zsh/zshrc.default.inc.zsh

PLUGINS="$HOME/dotfiles/plugins"

alias jest='yarn test --no-graphql'

source "$PLUGINS/zsh-history-substring-search.zsh"

function dev-tmux() {
  if [[ "" == $1 || "restart" != $1* ]] && tmux has -t dev; then
    tmux attach -t dev
    return
  fi

  # kill old session
  tmux kill-session -t dev

  # create session
  tmux new -d -s dev -n shopify

  # setup shopify window
  tmux send-keys "cd shopify" Enter
  tmux send-keys "tail -f log/development.log" Enter
  tmux split-window -h
  tmux send-keys "cd shopify" Enter

  # setup web window
  tmux new-window -n web
  tmux send-keys "cd web" Enter
  tmux send-keys "tail -f log/development.log" Enter
  tmux split-window -h
  tmux send-keys "cd web" Enter

  # attach to session
  tmux -2 attach -d
}

function go-and-log() {
  goto $1
  tail -f log/development.log
}

function goto() {
  if [[ -z $1 ]]; then
    echo "Usage: goto <web|shopify>"
    echo "Can be partial goto w / goto s"
    return
  fi

  if [[ "shopify" == $1* ]]; then
    cd "$HOME/src/github.com/Shopify/shopify"
  elif [[ "web" == $1* ]]; then
    cd "$HOME/src/github.com/Shopify/web"
  else
    echo "unknown location, options are shopify or web"
    exit -1
  fi
}