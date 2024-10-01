PROTO_DIR = ../protos
CERTS_DIR =  ~/.cache/de.stupabochum.campus_vote/.committee/campusvote-certs
PROTO_OPTS = \
	--go_out=.. --go-grpc_out=.. \
	--proto_path=$(PROTO_DIR) \
	--dart_out=grpc:../gui/lib/core/api/generated

# Colors
R = \033[0;31m	# Red
B = \033[0;34m	# Blue
G = \033[0;32m	# Greem
Y = \033[0;33m	# Yellow
P = \033[0;35m	# Purple
C = \033[0;36m	# Cyan
N = \033[0m		# No Color

.all: proto

proto:
	@echo -e "$PCompiling API's ProtoBuf$N"
	protoc $(PROTO_OPTS) common.proto vote.proto chat.proto google/protobuf/timestamp.proto

certs:
	@echo -e "$PGenerate TLS certificates for mTLS connection$N"
	./gen_certs.sh

client:
	@evans repl \
		--tls \
		--port 21797 \
		--host 127.0.0.1 \
		--path ..,$(PROTO_DIR) \
		--proto $(PROTO_DIR)/vote.proto \
		--proto $(PROTO_DIR)/chat.proto \
		--cacert $(CERTS_DIR)/api-ca.crt \
		--cert $(CERTS_DIR)/api-client.crt \
		--certkey $(CERTS_DIR)/api-client.key
