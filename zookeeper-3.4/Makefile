# To customize the repo/name/tag
# NAME=zk make -e 
# REPO=mycompany NAME=zk TAG=test make -e tag

DOCKER = docker
REPO   = asteris
NAME   = zookeeper

TAG = 3.4.6

build:
	$(DOCKER) build -t $(NAME) .

push:
	$(DOCKER) push $(REPO)/$(NAME):latest
	$(DOCKER) push $(REPO)/$(NAME):$(TAG)

tag:
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):latest
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):$(TAG)

clean: rm_containers rmi_images

rm_containers:
	$(DOCKER) ps -aq | xargs $(DOCKER) rm || true

rmi_images:
	$(DOCKER) rmi -f $(NAME) $(REPO)/$(NAME):latest $(REPO)/$(NAME):$(TAG) || true
