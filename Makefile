INSTALL_DIR=build
CONFIG_DIR=config
YAML_FILE=https://raw.githubusercontent.com/MieuxVoter/mv-api-spec/master/mv-openapi.yaml

.DEFAULT_GOAL := all

.PHONY: all
all: clients server
	
.PHONY: server
server: ${INSTALL_DIR}/python-flask

.PHONY: clients
clients: ${INSTALL_DIR}/typescript-fetch ${INSTALL_DIR}/python

${INSTALL_DIR}/%:
	mkdir -p ${INSTALL_DIR}
	CONFIG_FILE=${CONFIG_DIR}/$*.yaml
	if [ -f ${CONFIG_DIR}/$*.yaml ]; then\
		docker run --rm -v "${PWD}:/local" \
			openapitools/openapi-generator-cli generate \
			-i ${YAML_FILE} \
			-g $* \
			-o /local/${INSTALL_DIR}/$* \
			-c /local/${CONFIG_DIR}/$*.yaml;\
	else\
		docker run --rm -v "${PWD}:/local" \
			openapitools/openapi-generator-cli generate \
			-i ${YAML_FILE} \
			-g $* \
			-o /local/${INSTALL_DIR}/$*; \
	fi

.PHONY: clean
clean:
	rm -rf ${INSTALL_DIR}
