ARCH=amd64
COMPOSE=docker-compose -p $(shell basename $(CURDIR))
EXTNAME=extname

.PHONY: build
build:
	$(COMPOSE) build ${ARCH}

.PHONY: build-all
build-all:
	$(COMPOSE) build

.PHONY: up
up:
	$(COMPOSE) up -d --build ${ARCH}

.PHONY: down
down:
	$(COMPOSE) down --remove-orphans

.PHONY: bash
bash:
	$(COMPOSE) exec ${ARCH} /bin/bash -l

.PHONY: test-nts
test-nts: build
	$(COMPOSE) run ${ARCH} /bin/bash -c "make clean || true && phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && USE_ZEND_ALLOC=0 TEST_PHP_ARGS=-m make test"

.PHONY: test-zts
test-zts: build
	$(COMPOSE) run ${ARCH} /bin/bash -c "make clean || true && phpize-zts && ./configure --with-php-config=/usr/local/bin/php-config-zts && make && USE_ZEND_ALLOC=0 TEST_PHP_ARGS=-m make test"

.PHONY: test
test: build test-nts test-zts

.PHONY: test-all
test-all: build-all
	make test ARCH=amd64
	make test ARCH=i386

.PHONY: init
init: build
	$(COMPOSE) run ${ARCH} /bin/bash -c "cd '/php-src/ext' && php ext_skel.php --ext ${EXTNAME} && cp -R /php-src/ext/${EXTNAME}/. /php-src/ext/src"
