set -ev

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This build is a pull request, abort!"
    exit 0
fi

docker login -u  "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

docker pull homeassistant/amd64-builder

docker run --rm --privileged \
	-v /var/run/docker.sock:/var/run/docker.sock \
        -v /home/travis/.docker:/root/.docker \
	-v "$(pwd)":/data \
	homeassistant/amd64-builder \
	--target telegraf \
	--all \
	--release-tag
