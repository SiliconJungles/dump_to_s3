all: build

build:
	docker build -t siliconavengers/dump_to_s3 .
	@echo "Successfully built dump_to_s3"
