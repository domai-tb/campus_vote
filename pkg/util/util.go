package helper

import (
	"crypto/ed25519"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"fmt"
	"math/big"
	"os"
	"time"
)

func GenerateTLSCerts() {

	pubKeyCA, privKeyCA, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		panic(err)
	}

	caTemplate := x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject: pkix.Name{
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Wahlauschuss %d", time.Now().Year())},
		},
		NotBefore:             time.Now(),
		NotAfter:              time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:              x509.KeyUsageCertSign,
		BasicConstraintsValid: true,
		IsCA:                  true,
	}

	serverTemplate := x509.Certificate{
		SerialNumber: big.NewInt(2),
		Subject: pkix.Name{
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Urne 1 %d - Server", time.Now().Year())},
		},
		NotBefore:             time.Now(),
		NotAfter:              time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
	}

	// Create the certificate
	certCABytes, err := x509.CreateCertificate(rand.Reader, &caTemplate, &caTemplate, pubKeyCA, privKeyCA)
	if err != nil {
		panic(err)
	}
	// Save the certificate
	certOut, err := os.Create("CA.pem")
	if err != nil {
		panic(err)
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certCABytes})
	certOut.Close()

	certCA, err := x509.ParseCertificate(certCABytes)
	if err != nil {
		panic(err)
	}

	// -------------------

	pubKey, _, err := ed25519.GenerateKey(rand.Reader)
	if err != nil {
		panic(err)
	}

	certServer, err := x509.CreateCertificate(rand.Reader, &serverTemplate, certCA, pubKey, privKeyCA)
	if err != nil {
		panic(err)
	}
	// Save the certificate
	certOut, err = os.Create("server.pem")
	if err != nil {
		panic(err)
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certServer})
	certOut.Close()

}
