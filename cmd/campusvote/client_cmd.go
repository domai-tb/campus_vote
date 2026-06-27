package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"strconv"

	"github.com/schollz/progressbar/v3"
	"github.com/spf13/cobra"

	"github.com/domai-tb/campus_vote/pkg/api"
)

func getClientCmd() *cobra.Command {
	// client command
	var checkCmd = &cobra.Command{
		Use:   "check 'csv file / list of student IDs'",
		Short: "Match a given voter database to the systems stored database.",
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

			// Write the results to CSV
			path := filepath.Dir(args[0])
			validationFilePath := filepath.Join(path, "campus_vote_validation.csv")
			validationFile, err := os.Create(validationFilePath)
			if err != nil {
				panic(err)
			}
			defer validationFile.Close()
			writer := csv.NewWriter(validationFile)
			defer writer.Flush()

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

			// Iterate over givven voter file and write results
			writer.Write([]string{"Matrikelnummer", "Status Nr.", "Status Bedeutung"})
			for _, student := range csvData[1:] {
				voter, _ := client.GetVoterByStudentID(student[0])

				writer.Write([]string{
					student[0],
					strconv.FormatUint(uint64(voter.GetStatus()), 10),
					getStatusMessage(voter.GetStatus()),
				})

				bar.Add(1)
			}
		},
	}

	// Flags
	checkCmd.Flags().StringP(
		"certs", "c", "~/.cache/campus_vote/.committe/campusvote-certs/", "The directory of the API certificates.",
	)

	return checkCmd
}

func getStatusMessage(status uint32) string {
	switch status {
	case 0:
		return "Wahlberechtigt"
	case 1:
		return "Hat bereits einen Wahlzettel bekommen!"
	case 2:
		return "Hat bereits gewählt."
	default:
		return "Konnte nicht gefunden werden."
	}
}
