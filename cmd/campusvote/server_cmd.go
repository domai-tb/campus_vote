package main

import (
	"time"

	"github.com/spf13/cobra"

	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

func getServerCmd() *cobra.Command {
	var ballotBoxes []string

	// Campus Vote API
	var startCmd = &cobra.Command{
		Use:   "start <flags> 'password'",
		Short: "Start Campus Vote API server",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {

			if len(args) != 1 {
				panic("exactly one argument")
			}

			username, _ := cmd.Flags().GetString("cockroach-username")
			host, _ := cmd.Flags().GetString("cockroach-host")
			port, _ := cmd.Flags().GetInt("cockroach-port")
			database, _ := cmd.Flags().GetString("cockroach-database")
			rootCert, _ := cmd.Flags().GetString("cockroach-rootCert")
			clientCert, _ := cmd.Flags().GetString("cockroach-clientCert")
			clientKey, _ := cmd.Flags().GetString("cockroach-clientKey")
			electionYear, _ := cmd.Flags().GetInt("campus_vote-electionYear")
			ballotBoxes, _ = cmd.Flags().GetStringSlice("campus_vote-ballotbox")
			apiRootCert, _ := cmd.Flags().GetString("campus_vote-rootCert")
			serverCert, _ := cmd.Flags().GetString("campus_vote-serverCert")
			serverKey, _ := cmd.Flags().GetString("campus_vote-serverKey")

			config := core.CampusVoteConf{
				Username:     username,
				Host:         host,
				Port:         int16(port),
				Database:     database,
				RootCert:     rootCert,
				ClientCert:   clientCert,
				ClientKey:    clientKey,
				ElectionYear: electionYear,
				BallotBoxes:  ballotBoxes,
				APIRootCert:  apiRootCert,
				ServerCert:   serverCert,
				ServerKey:    serverKey,
			}

			cvdb := storage.New(config, args[0])
			api.NewServer(*cvdb)
		},
	}

	// CockRoachDB flags
	startCmd.Flags().StringP("cockroach-username", "u", "root", "The CockRoachDB username")
	startCmd.Flags().StringP("cockroach-host", "a", "127.0.0.1", "The CockRoachDB host to connect")
	startCmd.Flags().IntP("cockroach-port", "p", 26257, "The CockRoachDB port to connect")
	startCmd.Flags().StringP("cockroach-database", "n", "defaultdb", "The CockRoachDB database to use")
	startCmd.Flags().StringP("cockroach-rootCert", "r", "", "The CockRoachDB's TLS Root-CA certificate file path")
	startCmd.Flags().StringP("cockroach-clientCert", "c", "", "The CockRoachDB's TLS client certificate file path")
	startCmd.Flags().StringP("cockroach-clientKey", "k", "", "The CockRoachDB's TLS client key file path")

	// Campus Vote flags
	startCmd.Flags().StringSliceP(
		"campus_vote-ballotbox", "b", []string{},
		"The ballot boxes to vote (comma-separated list)",
	)
	startCmd.Flags().IntP("campus_vote-electionYear", "y", time.Now().Year(), "The year where the election is ongoing")
	startCmd.Flags().StringP("campus_vote-rootCert", "m", "", "The CampusVote's TLS Root-CA certificate file path")
	startCmd.Flags().StringP("campus_vote-serverCert", "s", "", "The CampusVote's TLS client certificate file path")
	startCmd.Flags().StringP("campus_vote-serverKey", "o", "", "The CampusVote's TLS client key file path")

	// Mark required flags
	startCmd.MarkFlagRequired("cockroach-rootCert")
	startCmd.MarkFlagRequired("cockroach-clientCert")
	startCmd.MarkFlagRequired("cockroach-clientKey")
	startCmd.MarkFlagRequired("campus_vote-ballotbox")
	startCmd.MarkFlagRequired("campus_vote-rootCer")
	startCmd.MarkFlagRequired("campus_vote-serverCert")
	startCmd.MarkFlagRequired("campus_vote-serverKey")

	return startCmd
}
