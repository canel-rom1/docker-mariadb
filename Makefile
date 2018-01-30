prefix ?= canelrom1
name   ?= mariadb
tag    ?= $(shell date +%y.%m.%d)

port   ?= 3306

env_file   = ./environment.conf
build_path = ./mariadb

all: run

run_args = -d --name $(name) --publish $(port):3306
run:
	test -f $(env_file) \
		&& docker run $(run_args) --env-file=$(env_file) $(prefix)/$(name):latest \
		|| docker run $(run_args) $(prefix)/$(name):latest

build: $(build_path)/Dockerfile
	docker images -q $(prefix)/$(name):latest >> ./mariadb/.imagesid
	docker build -t $(prefix)/$(name):$(tag) $(build_path)
	docker tag $(prefix)/$(name):$(tag) $(prefix)/$(name):latest 

stop:
	docker stop $(name)

rm: stop
	docker rm $(name)

clean-old-images: 
	docker rmi `tac ./mariadb/.imagesid`
	rm -f ./mariadb/.imagesid

clean-docker:
	docker rmi $(prefix)/$(name):$(tag)

clean-docker-latest:
	docker rmi $(prefix)/$(name):latest

clean: clean-docker-latest clean-docker clean-old-images

monitor:
	docker exec -it $(name) bash

log:
	docker logs $(name)


# vim: ft=make
