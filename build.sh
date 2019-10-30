set -ev
docker run -it --rm --privileged --name hassio-telegraf \
        -v ~/.docker:/root/.docker \
	-v "$(pwd)":/docker \
	hassioaddons/build-env:latest \
	--target telegraf \
	--git \
	--all \
	--image "sabuto/{arch}-hassio-telegraf" \
	--from "homeassistant/{arch}-base" \
	--author "Robert Dunne <robe_dunne@hotmail.com" \
	--doc-url "${GITHUB_URL}"
