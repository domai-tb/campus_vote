package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strconv"

	"github.com/schollz/progressbar/v3"
	"github.com/spf13/cobra"

	"github.com/domai-tb/campus_vote/pkg/api"
	util "github.com/domai-tb/campus_vote/pkg/util"
)

func getGenCmd() *cobra.Command {
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

	// Create Voter DB
	var voterDBCmd = &cobra.Command{
		Use:   "voter 'csv file / list of student IDs'",
		Short: "Create voter database based on given CSV file.",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {

			if len(args) != 1 {
				panic("exactly one argument")
			}

			// Open CSV file
			csvFile, err := os.Open(args[0])
			if err != nil {
				panic(fmt.Errorf("could not open CSV file: %v", err))
			}
			defer csvFile.Close()

			// Read the CSV data
			reader := csv.NewReader(csvFile)
			reader.FieldsPerRecord = -1 // Allow variable number of fields
			csvData, err := reader.ReadAll()
			if err != nil {
				panic(err)
			}

			// Create connection to API
			certDir, _ := cmd.Flags().GetString("certs")
			rootCert := filepath.Join(certDir, "api-ca.crt")
			clientCert := filepath.Join(certDir, "api-client.crt")
			clientKey := filepath.Join(certDir, "api-client.key")

			client, err := api.NewClient(rootCert, clientCert, clientKey)
			if err != nil {
				panic(err)
			}

			// Create progressbar
			bar := progressbar.Default(int64(len(csvData[1:])))

			// Iterate over givven voter file
			for _, student := range csvData[1:] {
				id, err := strconv.ParseInt(student[0], 10, 64)
				if err != nil {
					log.Printf("failed parse student id: %v", err)
				}

				statusCode, _ := client.CreateVoter(&api.Voter{
					StudentId: &api.StudentId{Num: id},
					Firstname: student[1],
					Lastname:  student[2],
					BallotBox: student[3],
					Faculity:  student[4],
					Shk:       student[5],
				})

				if err != nil {
					log.Printf("could not create voter with id %v - %v", id, err)
				} else if statusCode.Status != 0 {
					log.Printf("could not create voter with id %v - %v", id, statusCode.Msg)
				}

				bar.Add(1)
			}
		},
	}

	// Flags
	voterDBCmd.Flags().StringP(
		"certs", "c", "~/.cache/campus_vote/.committe/campusvote-certs/", "The directory of the API certificates.",
	)

	// Add utility commands
	generateCmd.AddCommand(genTLSCmd, voterDBCmd)

	return generateCmd
}
