CAMPUSVOTE_CMD = ../cmd/campus_vote/main.go
CAMPUSVOTE_CMD_NAME = campusvote

BUILD_PATH_DEBUG = ../build/debug/

BUILD_PATH_RELEASE_LINUX = ../gui/linux/campus_vote/
BUILD_PATH_RELEASE_WINDOWS = ../gui/windows/campus_vote/
BUILD_PATH_RELEASE_MACOS = ../gui/macos/campus_vote/

GO_FLAGS_RELEASE = -a -buildmode=exe -ldflags "-s -w" -gcflags=all="-l -B"
GO_FLAGS_DEBUG = -a -race -cover -buildmode=default

GO_BUILD_LINUX = GOOS=linux GOARCH=amd64 go build
GO_BUILD_WINDOWS = GOOS=windows GOOARCH=amd64 go build
GO_BUILD_MACOS = GOOS=darwin GOARCH=arm64 go build

build-release: clean-release
	@mkdir -p $(BUILD_PATH_RELEASE_LINUX) $(BUILD_PATH_RELEASE_WINDOWS) $(BUILD_PATH_RELEASE_MACOS)
	$(GO_BUILD_LINUX) $(GO_FLAGS_RELEASE) -o $(BUILD_PATH_RELEASE_LINUX)$(CAMPUSVOTE_CMD_NAME) $(CAMPUSVOTE_CMD)
	$(GO_BUILD_WINDOWS) $(GO_FLAGS_RELEASE) -o $(BUILD_PATH_RELEASE_WINDOWS)$(CAMPUSVOTE_CMD_NAME).exe $(CAMPUSVOTE_CMD)
	$(GO_BUILD_MACOS) $(GO_FLAGS_RELEASE) -o $(BUILD_PATH_RELEASE_MACOS)$(CAMPUSVOTE_CMD_NAME) $(CAMPUSVOTE_CMD)

build-debug: clean-debug
	@mkdir -p $(BUILD_PATH_DEBUG)
	$(GO_BUILD_LINUX) $(GO_FLAGS_DEBUG) -o $(BUILD_PATH_DEBUG)$(CAMPUSVOTE_CMD_NAME) $(CAMPUSVOTE_CMD)

clean-release:
	@rm -f $(BUILD_PATH_RELEASE_LINUX)* >> /dev/null
	@rm -f $(BUILD_PATH_RELEASE_WINDOWS)* >> /dev/null
	@rm -f $(BUILD_PATH_RELEASE_MACOS)* >> /dev/null

clean-debug:
	@rm -f $(BUILD_PATH_DEBUG)* >> /dev/null