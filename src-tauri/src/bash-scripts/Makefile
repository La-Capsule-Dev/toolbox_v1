# For Dev and Testing purpose
.PHONY: run build log

run:
	@echo "Launch docker run"
	docker run --rm -it devbox:ubuntu-22.04

build:
	@echo "Build docker image"
	docker build -t devbox:ubuntu-22.04 .

log:
	@echo "Logging cat tmp"
	cat /tmp/toolbox.log
