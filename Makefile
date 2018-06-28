.DEFAULT_GOAL := help

USER=$(shell id -u)
FULLNAME=$(shell cat /etc/passwd | grep $(USER) | awk -F ":" '{print $$5}')
LAST_IMAGE=$(shell docker images | grep gmail-mutt | awk '{print $$3}')
CONTAINER=joshuajleigh/gmail-mutt


image: ## build / rebuild the docker container
	docker build . -t gmail-mutt

mutt_from_scratch: image ## recreate the container (slower=more fun?)
	-@docker run --rm \
		--name="gmail-mutt" \
		--env="DISPLAY" \
		-e USERID=$(USER) \
		-e GMAIL_NAME="$(FULLNAME)" \
		-e GMAIL_LOGIN="joshua.j.leigh@gmail.com" \
		-v /etc/localtime:/etc/localtime \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v ~/Maildir/gmutt/headers:/home/user/.mutt/cache/headers \
		-v ~/Maildir/gmutt/bodies:/home/user/.mutt/cache/bodies \
		-it gmail-mutt

testing: ## starts in shell for testing, etc
	-@docker run --rm \
		-it --entrypoint="/bin/bash" \
		--env="DISPLAY" \
		-v /etc/localtime:/etc/localtime \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v ~/Maildir:/home/user/Maildir \
		-it gmail-mutt

vars:
	echo $(FULLNAME)
	echo $(USER)

push: image ## used to push newly created image to docker hub
	docker commit $(LAST_IMAGE) gmail-mutt
	docker tag gmail-mutt $(CONTAINER)
	docker push $(CONTAINER)

help:
	@printf "\033[0;32m Welcome to the gmail-mutt repo!\033[0m\n"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: mutt testing
