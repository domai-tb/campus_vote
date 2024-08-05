# Colors
R = \033[0;31m# Red
B = \033[0;34m# Blue
G = \033[0;32m# Greem
Y = \033[0;33m# Yellow
P = \033[0;35m# Purple
C = \033[0;36m# Cyan
N = \033[0m# No Color

rust-init:
	@echo -e "$PCreate $C'appinit'$P crate $N"
	@cd ../gui/ && \
	flutter_rust_bridge_codegen integrate \
		--no-enable-integration-test \
		--rust-crate-name appinit \
		--rust-crate-dir ../appinit
	@rm -rf ../gui/test_driver
	@echo -e "$PLoad $Bflutter_rust_bridge$P config$N"
	cp ../conf/flutter_rust_bridge.yaml ../gui/flutter_rust_bridge.yaml

localization:
	@cd ../gui/ && \
	flutter gen-l10n --format

run:
	@cd ../gui/ && \
	flutter run