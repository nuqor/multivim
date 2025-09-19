default:
  just -l

docker-build:
  docker-buildx build . -t nvim-test

docker-run:
  docker run -it --rm \
    --mount type=bind,src=./multivim,dst=/home/user/.config/nvim \
    nvim-test

docker-run-bash:
  docker run -it --rm \
    --mount type=bind,src=./multivim,dst=/home/user/.config/nvim \
    --entrypoint bash \
    nvim-test
