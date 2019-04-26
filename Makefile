all: build push

build:
	docker build -t siliconavengers/dump_to_s3 .
	@echo "Successfully built dump_to_s3"

push:
	docker tag siliconavengers/dump_to_s3 siliconavengers/dump_to_s3:latest
	docker push siliconavengers/dump_to_s3:latest
