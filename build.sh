set -ev

docker pull homeassistant/amd64-builder

docker run --rm --privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.docker:/root/.docker \
	-v "$(pwd)":/data \
	homeassistant/amd64-builder \
	-t telegraf \
	--all \
	--test
