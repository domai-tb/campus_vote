CAMPUS_VOTE_DATA  = $$(pwd)/node
CAMPUS_VOTE_BUILD = $$(pwd)/build

GO_BUILD_LINUX       = GOOS=linux GOARCH=amd64 go build
GO_BUILD_LINUX_ARM   = GOOS=linux GOARCH=arm64 go build
GO_BUILD_WINDOWS     = GOOS=windows GOARCH=amd64 go build
GO_BUILD_WINDOWS_ARM = GOOS=windows GOARCH=arm64 go build
GO_BUILD_MACOS	     = GOOS=darwin GOARCH=amd64 go build
GO_BUILD_MACOS_ARM   = GOOS=darwin GOARCH=arm64 go build

CMD_BALLOTBOX   = cmd/ballotbox.go
BUILD_BALLOTBOX = $(CAMPUS_VOTE_BUILD)/ballotbox/BallotBox

.all: clean build
build: ballotbox
run: run-ballotbox-linux-amd64

clean: 
	rm -rf $(CAMPUS_VOTE_DATA)
	rm -rf $(CAMPUS_VOTE_BUILD)

ballotbox:
	@echo "=== Compiling BallotBox for every OS ==="
	@mkdir -p $(CAMPUS_VOTE_BUILD)/ballotbox
	$(GO_BUILD_LINUX) -o $(BUILD_BALLOTBOX).linux.amd64.bin $(CMD_BALLOTBOX)
	$(GO_BUILD_LINUX_ARM) -o $(BUILD_BALLOTBOX).linux.arm64.bin $(CMD_BALLOTBOX)
	$(GO_BUILD_WINDOWS) -o $(BUILD_BALLOTBOX).win.amd64.exe $(CMD_BALLOTBOX)
	$(GO_BUILD_WINDOWS_ARM) -o $(BUILD_BALLOTBOX).win.arm64.exe $(CMD_BALLOTBOX)
	$(GO_BUILD_MACOS) -o $(BUILD_BALLOTBOX).macos.amd64.bin $(CMD_BALLOTBOX)
	$(GO_BUILD_MACOS_ARM) -o $(BUILD_BALLOTBOX).macos.arm64.bin $(CMD_BALLOTBOX)

run-ballotbox-linux-amd64: ballotbox
	@echo "=== Campus Vote Init ==="
	@mkdir -p $(CAMPUS_VOTE_DATA)
	TMHOME=$(CAMPUS_VOTE_DATA) tendermint init
	cp ./tendermint.toml ./node/config/config.toml
	@echo "=== Run BallotBox ==="
	$(CAMPUS_VOTE_BUILD)/ballotbox/BallotBox.linux.amd64.bin \
		-config ./node/config/config.toml	 \
		-badger ./node/badger