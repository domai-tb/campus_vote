package main

import (
	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

func main() {
	cvdb := storage.New(*storage.DefaultDBConfig(), "123456")
	api.New(*cvdb)
}
