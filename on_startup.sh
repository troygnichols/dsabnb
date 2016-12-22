export RAILS_ENV=development
docker-machine rm default
docker-machine create -d virtualbox default
eval $(docker-machine env default)
