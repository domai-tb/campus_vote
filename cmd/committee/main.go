package main

import (
	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

func main() {
	cvdb := storage.New(*core.DefaultCampusVoteConf(), "123456")
	api.New(*cvdb)
}
