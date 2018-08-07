VERSION=$(shell git describe --tags)
NOMBRE="mgit_elixir"

N=[0m
G=[01;32m
Y=[01;33m
B=[01;34m


comandos:
	@echo ""
	@echo "${B}Comandos disponibles para ${Y}${NOMBRE}${N} (versión: ${VERSION})"
	@echo ""
	@echo "  ${Y}Generales de la aplicación${N}"
	@echo ""
	@echo "    ${G}iniciar${N}               Instala todas las dependencias."
	@echo "    ${G}ejecutar${N}              Ejecuta la aplicación de forma local."
	@echo "    ${G}test${N}                  Ejecuta los tests."
	@echo "    ${G}test_live${N}             Ejecuta los tests de forma contínua."
	@echo "    ${G}version${N}               Incrementa la versión."
	@echo ""


iniciar: crear_fixture
	mix deps.get

test:
	mix test

test_live:
	mix test.watch --stale

ejecutar:
	mix run

version:
	yarn release

crear_fixture:
	rm -rf fixture
	mkdir fixture
	git clone https://github.com/trifulca/mgit_elixir.git fixture/mgit_elixir


.PHONY: test
