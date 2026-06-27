package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

func main() {

	var rootCmd = &cobra.Command{
		Use:   "campusvote",
		Short: "Campus Vote CLI",
	}

	// Add subcommands to root command
	rootCmd.AddCommand(
		getServerCmd(), // start API server
		getClientCmd(), // check database
		getGenCmd(),    // generate TLS certficates
	)

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
