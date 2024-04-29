CAMPUS_VOTE_DATA  = $$(pwd)/node
CAMPUS_VOTE_BUILD = $$(pwd)/build

GO_BUILD_LINUX   = GOOS=linux GOARCH=amd64 go build
GO_BUILD_WINDOWS = GOOS=windows GOARCH=amd64 go build

.all: clean build
build: build-ballotbox
run: run-ballotbox

clean: 
	rm -rf $(CAMPUS_VOTE_DATA)
	rm -rf $(CAMPUS_VOTE_BUILD)

build-ballotbox:
	@echo "=== Compiling BallotBox for every OS ==="
	@mkdir -p $(CAMPUS_VOTE_BUILD)/ballotbox
	$(GO_BUILD_LINUX) -o $(CAMPUS_VOTE_BUILD)/ballotbox cmd/ballotbox.go
	$(GO_BUILD_WINDOWS) -o $(CAMPUS_VOTE_BUILD)/ballotbox cmd/ballotbox.go

run-ballotbox: build-ballotbox
	@echo "=== Campus Vote Init ==="
	@mkdir -p $(CAMPUS_VOTE_DATA)
	TMHOME=$(CAMPUS_VOTE_DATA) tendermint init
	cp ./tendermint.toml ./node/config/config.toml
	@echo "=== Run BallotBox ==="
	$(CAMPUS_VOTE_BUILD)/ballotbox/ballotbox \
		-config ./node/config/config.toml	 \
		-badger ./node/badger