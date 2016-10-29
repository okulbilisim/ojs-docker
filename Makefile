PROJECT := OJS
include secrets.env

default: test

build:
	@docker build \
			--build-arg GITHUB_TOKEN=${GITHUB_TOKEN} \
			-f ojs/Dockerfile -t ojs:fpm .
	@docker build -f nginx/Dockerfile -t  ojs:nginx .

development:
	@docker-compose -f docker-compose.$@.yaml --project-name $(PROJECT) up # -d

production:
	@docker-compose -f docker-compose.$@.yaml --project-name $(PROJECT) up -d

down:
	@docker-compose -f docker-compose.development.yaml --project-name $(PROJECT) down

workarounds:
	@sysctl -w vm.max_map_count=262144

test: build
	@docker run -it --env-file=secrets.env ojs pwd # sh -li

.PHONY: default build development down production workarounds