PROTO_DIR = ../protos
CERTS_DIR = ../certs
PROTO_OPTS = \
	--go_out=.. --go-grpc_out=.. \
	--proto_path=$(PROTO_DIR) \
	--dart_out=grpc:../gui/lib/generated

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
	protoc $(PROTO_OPTS) api.proto

certs:
	@echo -e "$PGenerate TLS certificates for mTLS connection$N"
	./gen_certs.sh

client:
	evans \
		--proto $(PROTO_DIR)/api.proto \
		--host 127.0.0.1 \
		--port 21797 \
		--tls \
		--cacert $(CERTS_DIR)/ca-cert.pem \
		--cert $(CERTS_DIR)/client-cert.pem \
		--certkey $(CERTS_DIR)/client-key.pem