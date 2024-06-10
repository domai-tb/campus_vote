# CockRoachDB
CRDB_ROOT_DIR = ../cockroach
CRDB_CERTS_DIR = $(CRDB_ROOT_DIR)/certs

# Colors
R = \033[0;31m	# Red
B = \033[0;34m	# Blue
G = \033[0;32m	# Greem
Y = \033[0;33m	# Yellow
P = \033[0;35m	# Purple
C = \033[0;36m	# Cyan
N = \033[0m		# No Color

cockroach-create-cluster: check-requirements clean
	@mkdir -p  $(CRDB_CERTS_DIR)
	@echo -e "$PCreate the CA (Certificate Authority) certificate and key pair$N"
	cockroach cert create-ca \
		--certs-dir=$(CRDB_CERTS_DIR) \
		--ca-key=$(CRDB_ROOT_DIR)/ca.key \
		--key-size 4096 \
		--lifetime 336h0m0s
	@echo -e "$PCreate the certificate and key pair for local node$N"
	cockroach cert create-node \
		--certs-dir=$(CRDB_CERTS_DIR) \
		--ca-key=$(CRDB_ROOT_DIR)/ca.key \
		--key-size 4096 \
		--lifetime 335h0m0s \
		127.0.0.1
	@echo -e "$PCreate a client certificate and key pair for the root user$N"
	cockroach cert create-client \
		--certs-dir=$(CRDB_CERTS_DIR) \
		--ca-key=$(CRDB_ROOT_DIR)/ca.key \
		--key-size 4096 \
		--lifetime 335h0m0s \
		root

cockroach-start-node: check-requirements
	@echo -e "$PStart the local node$N"
	cockroach start \
		--certs-dir=$(CRDB_CERTS_DIR) \
		--store=$(CRDB_ROOT_DIR)/node \
		--listen-addr=127.0.0.1:26257 \
		--http-addr=127.0.0.1:8080 \
		--join=127.0.0.1:26257 \
		--cluster-name=stupa-bochum

cockroach-init-cluster: check-requirements
	@echo -e "$PTry to initialize cockroach node$N"
	cockroach init \
		--certs-dir=$(CRDB_CERTS_DIR) \
		--host=127.0.0.1:26257 \
		--cluster-name=stupa-bochum

check-requirements:
	@if ! command -v cockroach; then \
	    echo -e "$RCockRoachDB is not installed. Please install it.$N\n"; \
		echo -e "Checkout:  https://www.cockroachlabs.com/docs/stable/install-cockroachdb-linux.html\n"; \
	    exit 1; \
	fi

cockroach-sql:
	cockroach sql --certs-dir=$(CRDB_CERTS_DIR) --host=127.0.0.1:26257

clean:
	rm -rf $(CRDB_ROOT_DIR)