#
# Campus Vote Makefile
#
# !! DO NOT CHANGE !!

# Go build
GO_BUILD_LINUX   = xgo --targets=linux/amd64,linux/arm64
GO_BUILD_MACOS   = xgo --targets=darwin/*
GO_BUILD_WINDOWS = xgo --targets=windows/*

GO_BUILD_LIB_OPTS = -buildmode=c-shared

# Build directory for ibaries
LINUX_LIBS 	 = linux/campus_vote
MACOS_LIBS 	 = macos/campus_vote
WINDOWS_LIBS = windows/campus_vote

.all: clean lib-db

lib-db:
	@echo "=== compiling db libary ==="
	$(GO_BUILD_LINUX)	$(GO_BUILD_LIB_OPTS) -out $(LINUX_LIBS)/db/db ./db
	$(GO_BUILD_MACOS)	$(GO_BUILD_LIB_OPTS) -out $(MACOS_LIBS)/db/db ./db
	$(GO_BUILD_WINDOWS) $(GO_BUILD_LIB_OPTS) -out $(WINDOWS_LIBS)/db/db ./db

clean:
	rm -rf $(LINUX_LIBS)/db
	rm -rf $(MACOS_LIBS)/db
	rm -rf $(WINDOWS_LIBS)/db