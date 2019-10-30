set -ev

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This build is a pull request, abort!"
    exit 0
fi

docker run -it --rm --privileged --name hassio-telegraf \
        -v ~/.docker:/root/.docker \
	-v "$(pwd)":/docker \
	hassioaddons/build-env:latest \
	--target telegraf \
	--tag-latest \
	--push \
	--all \
	--image "sabuto/{arch}-hassio-telegraf" \
	--from "homeassistant/{arch}-base" \
	--author "Robert Dunne <robe_dunne@hotmail.com" \
	--doc-url "${GITHUB_URL}" \
	--login "${DOCKER_USERNAME}" \
	--password "${DOCKER_PASSWORD}" \
	--parallel
