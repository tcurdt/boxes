IMAGES = busybox debian nginx upstream znc env-busybox env-go env-iojs env-node env-rust boot2docker registry
.PHONY: all $(IMAGES)

all: $(IMAGES)

$(IMAGES):
	cd $@ && docker build -t tcurdt/$@ . && docker push tcurdt/$@
