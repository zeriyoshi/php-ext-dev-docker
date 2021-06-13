COMPOSE=docker-compose -p $(shell basename $(CURDIR))
EXTNAME=extname

.PHONY: build
build:
	$(COMPOSE) build

.PHONY: up
up:
	$(COMPOSE) up -d --build dev

.PHONY: down
down:
	$(COMPOSE) down --remove-orphans

.PHONY: bash
bash:
	$(COMPOSE) exec dev /bin/bash -l

.PHONY: test-nts
test-nts: build
	$(COMPOSE) run dev /bin/bash -c "make clean && phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && USE_ZEND_ALLOC=0 TEST_PHP_ARGS=-m make test"

.PHONY: test-zts
test-zts: build
	$(COMPOSE) run dev /bin/bash -c "make clean && phpize-zts && ./configure --with-php-config=/usr/local/bin/php-config-zts && make && USE_ZEND_ALLOC=0 TEST_PHP_ARGS=-m make test"

.PHONY: test
test: build test-nts test-zts

.PHONY: init
init: build
	$(COMPOSE) run dev /bin/bash -c "cd '/php-src/ext' && php ext_skel.php --ext ${EXTNAME} && cp -R /php-src/ext/${EXTNAME}/. /php-src/ext/src"
