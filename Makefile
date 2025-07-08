# For Dev and Testing purpose
.PHONY: cargo-build docker-run docker-build log


cargo-build:
	@echo "Launch cargo builder release"
	cd src-tauri && cargo build --release

bootstrap:
	@echo "Launching bootstrap"
	npm install && cargo-build

docker-run:
	@echo "Launch docker run"
	docker run --rm -it devbox:ubuntu-22.04

docker-build:
	@echo "Build docker image"
	docker build -t devbox:ubuntu-22.04 .

log:
	@echo "Logging cat tmp"
	cat /tmp/toolbox.log
