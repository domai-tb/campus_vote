package main

import (
	"fmt"
	"os"
	"time"

	"github.com/spf13/cobra"

	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
)

func main() {
	var ballotBoxes []string

	var rootCmd = &cobra.Command{
		Use:   "campusvote",
		Short: "Campus Vote CLI",
		Run: func(cmd *cobra.Command, args []string) {
			username, _ := cmd.Flags().GetString("cockroach-username")
			host, _ := cmd.Flags().GetString("cockroach-host")
			port, _ := cmd.Flags().GetInt("cockroach-port")
			database, _ := cmd.Flags().GetString("cockroach-database")
			rootCert, _ := cmd.Flags().GetString("cockroach-rootCert")
			clientCert, _ := cmd.Flags().GetString("cockroach-clientCert")
			clientKey, _ := cmd.Flags().GetString("cockroach-clientKey")
			electionYear, _ := cmd.Flags().GetInt("campus_vote-electionYear")
			ballotBoxes, _ = cmd.Flags().GetStringSlice("campus_vote-ballotbox")

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
			}
			fmt.Println("Configuration:", config)

			cvdb := storage.New(config, "123456")
			api.New(*cvdb)
		},
	}

	// CockRoachDB flags
	rootCmd.Flags().StringP("cockroach-username", "u", "root", "The CockRoachDB username")
	rootCmd.Flags().StringP("cockroach-host", "a", "127.0.0.1", "The CockRoachDB host to connect")
	rootCmd.Flags().IntP("cockroach-port", "p", 26257, "The CockRoachDB port to connect")
	rootCmd.Flags().StringP("cockroach-database", "n", "defaultdb", "The CockRoachDB database to use")
	rootCmd.Flags().StringP("cockroach-rootCert", "r", "", "The CockRoachDB's TLS Root-CA certificate file path")
	rootCmd.Flags().StringP("cockroach-clientCert", "c", "", "The CockRoachDB's TLS client certificate file path")
	rootCmd.Flags().StringP("cockroach-clientKey", "k", "", "The CockRoachDB's TLS client key file path")

	// Campus Vote flags
	rootCmd.Flags().StringSliceP(
		"campus_vote-ballotbox", "b", []string{},
		"The ballot boxes to vote (comma-separated list)",
	)
	rootCmd.Flags().IntP("campus_vote-electionYear", "y", time.Now().Year(), "The year where the election is ongoing")

	// Mark required flags
	rootCmd.MarkFlagRequired("cockroach-rootCert")
	rootCmd.MarkFlagRequired("cockroach-clientCert")
	rootCmd.MarkFlagRequired("cockroach-clientKey")
	rootCmd.MarkFlagRequired("campus_vote-ballotbox")

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
