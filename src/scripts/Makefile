# For Dev and Testing purpose
.PHONY: dock-run dock-build cat-log

dock-run:
	@echo "Launch docker run"
	docker run --rm -it devbox:ubuntu-22.04

dock-build:
	@echo "Build docker image"
	docker build -t devbox:ubuntu-22.04 .

cat-log:
	@echo "Logging cat tmp"
	cat /tmp/toolbox.log
