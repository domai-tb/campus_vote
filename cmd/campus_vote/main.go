package main

import (
	"fmt"
	"os"
	"time"

	"github.com/spf13/cobra"

	"github.com/domai-tb/campus_vote/pkg/api"
	"github.com/domai-tb/campus_vote/pkg/core"
	"github.com/domai-tb/campus_vote/pkg/storage"
	util "github.com/domai-tb/campus_vote/pkg/util"
)

func main() {
	var ballotBoxes []string

	var rootCmd = &cobra.Command{
		Use:   "campusvote",
		Short: "Campus Vote CLI",
	}

	// Campus Vote API
	var startCmd = &cobra.Command{
		Use:   "start",
		Short: "Start Campus Vote API server",
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

			cvdb := storage.New(config, "123456")
			api.New(*cvdb)
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

	// Generate command
	var generateCmd = &cobra.Command{
		Use:   "gen",
		Short: "Generate TLS specific keys, certificates and so on",
	}

	var genTLSCmd = &cobra.Command{
		Use:   "tls",
		Short: "Perform TLS Certificate generation",
		Run: func(cmd *cobra.Command, args []string) {
			ballotBoxes, _ := cmd.Flags().GetStringSlice("ballotbox")
			boxDir, _ := cmd.Flags().GetString("ballotbox_directory")
			committeeDir, _ := cmd.Flags().GetString("committee_directory")

			if err := util.GenerateTLSCerts(ballotBoxes, boxDir, committeeDir); err != nil {
				panic(err)
			}
		},
	}

	// TLS Flags
	genTLSCmd.Flags().StringSliceP("ballotbox", "b", []string{}, "The ballot boxes to vote (comma-separated list)")
	genTLSCmd.Flags().StringP("ballotbox_directory", "d", ".", "The directory to generate all ballot box certificates.")
	genTLSCmd.Flags().StringP("committee_directory", "c", ".", "The directory to generate committee certificates.")

	genTLSCmd.MarkFlagRequired("ballotbox")
	genTLSCmd.MarkFlagRequired("ballotbox_directory")
	genTLSCmd.MarkFlagRequired("committee_directory")

	// Add utility commands
	generateCmd.AddCommand(genTLSCmd)

	// Add subcommands to root command
	rootCmd.AddCommand(startCmd, generateCmd)

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
