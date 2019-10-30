set -ev
docker run -it --rm --privileged --name hassio-telegraf \
        -v ~/.docker:/root/.docker \
	-v "$(pwd)"/telegraf:/docker \
	hassioaddons/build-env:latest \
	--target hassio-telegraf \
	--git \
	--all \
	--from "homeassistant/{arch}-base" \
	--author "Robert Dunne <robe_dunne@hotmail.com"
