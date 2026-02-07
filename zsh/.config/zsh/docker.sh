# shellcheck shell=bash
# Adapted from https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb

############################################################################
#                                                                          #
#               ------- Useful Docker Aliases --------                     #
#                                                                          #
#     # Usage:                                                             #
#     daws <svc> <cmd> <opts> : aws cli in docker with <svc> <cmd> <opts>  #
#     dex <container>: execute a bash shell inside the RUNNING <container> #
#     di <container> : docker inspect <container>                          #
#     dip            : IP addresses of all running containers              #
#     dlab           : docker ps filtered by label                         #
#     dnames         : names of all running containers                     #
#     drmc           : remove all exited containers                        #
#     drmid          : remove all dangling images                          #
#     dsr <container>: stop then remove <container>                        #
#                                                                          #
############################################################################

function dnames-fn {
  for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
    docker inspect "${ID}" | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
  done
}

function dip-fn {
  echo "IP addresses of all named running containers"

  for DOC in $(dnames-fn); do
    IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "${DOC}")
    OUT+=${DOC}'\t'${IP}'\n'
  done
  echo -e "${OUT}" | column -t
  unset OUT
}

function dex-fn {
  docker exec -it "$1" "${2:-bash}"
}

function di-fn {
  docker inspect "$1"
}

function dsr-fn {
  docker stop "$1"
  docker rm "$1"
}

function drmc-fn {
  docker rm "$(docker ps --all -q -f status=exited)"
}

function drmid-fn {
  imgs=$(docker images -q -f dangling=true)
  [ -n "${imgs}" ] && docker rmi "${imgs}" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
  docker ps --filter="label=$1" --format="{{.ID}}"
}

function d-aws-cli-fn {
  docker run \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    amazon/aws-cli:latest "$1" "$2" "$3"
}

alias daws=d-aws-cli-fn
alias dex=dex-fn
alias di=di-fn
alias dip=dip-fn
alias dnames=dnames-fn
alias drmc=drmc-fn
alias drmid=drmid-fn
alias dsr=dsr-fn
