# PHP Extension Development Toolkit

Toolkit for PHP Extension development with Docker and VSCode.
Includes Valgrind memory check and ZTS support.

## Usage

### Initialize

Checkout your desired `php-src` versions in `vendor/php-src`.
Default: `PHP-8.0` (PHP 8.0.x development branch)

```bash
$ cd vendor/php-src
$ git checkout PHP-8.0.7
```

**IMPORTANT**
`php-src` directory is copying only then building container, if you changed version MUST rebuild container.

### Create

Install `docker` and `make` on your machine.

Run in your terminal:

```bash
$ make init EXTNAME=yourextensionname
```

Start building container image, generate extension skeleton into `./src`

### Develop

#### CLI

Run in your terminal to start development container:

```bash
$ make up
```

Attach development container:

```bash
$ make bash
```

Stop and remove development container:

```bash
$ make down
```

#### VSCode

Install `Remote - Containers` extension into your VSCode and select `Reopen container`

### Test

Run in your terminal:

```bash
$ make test
```

And it can running separately:

```bash
$ make test-nts # Testing non-thread-safe (NTS) only
$ make test-zts # Testing thread-safe (ZTS) only
```
