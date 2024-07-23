package main

import (
	"time"

	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

func main() {
	cvdb := storage.New(core.CampusVoteConf{
		Username:     "root",
		Host:         "192.168.0.166",
		Port:         26257,
		Database:     "defaultdb",
		RootCert:     "/home/domai/.cache/de.stupabochum.campus_vote/.committee/cockroach-certs/ca.crt",
		ClientCert:   "/home/domai/.cache/de.stupabochum.campus_vote/.committee/cockroach-certs/client.root.crt",
		ClientKey:    "/home/domai/.cache/de.stupabochum.campus_vote/.committee/cockroach-certs/client.root.key",
		ElectionYear: time.Now().Year(),
		BallotBoxes:  []string{"MC", "MB"},
	}, "123456")
	api.New(*cvdb)
}
