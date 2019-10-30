set -ev

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This build is a pull request, abort!"
    exit 0
fi

docker run --rm --privileged \
        -v ~/.docker:/root/.docker \
	-v "$(pwd)":/data \
	homeassistant/amd64-builder \
	--target telegraf \
	--git \
	--all \
	--release-tag \
	--docker-login \
	--image "sabuto/{arch}-hassio-telegraf"
