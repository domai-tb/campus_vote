package util

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"errors"
	"fmt"
	"log"
	"math/big"
	"net"
	"os"
	"time"
)

func GenerateTLSCerts(ballotBoxes []string, boxDir string, committeeDir string) error {

	// pubKeyCA, privKeyCA, err := ed25519.GenerateKey(rand.Reader)
	privKeyCA, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		return err
	}

	caTemplate := x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject: pkix.Name{
			Country:            []string{"DE"},
			Province:           []string{"NRW"},
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Wahlauschuss %d", time.Now().Year())},
			CommonName:         "CampusVote API CA",
		},
		EmailAddresses:        []string{"wahlausschuss@stupa-bochum.de"},
		NotBefore:             time.Now(),
		NotAfter:              time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:              x509.KeyUsageCertSign,
		BasicConstraintsValid: true,
		IsCA:                  true,
	}

	// Create the certificate
	certCABytes, err := x509.CreateCertificate(rand.Reader, &caTemplate, &caTemplate, privKeyCA.Public(), privKeyCA)
	if err != nil {
		return err
	}

	// parse certificate
	certCA, err := x509.ParseCertificate(certCABytes)
	if err != nil {
		return err
	}

	// Save the certificate
	os.MkdirAll(committeeDir, 0755)
	certOut, err := os.Create(committeeDir + "/api-ca.crt")
	if err != nil {
		return err
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certCABytes})
	certOut.Close()

	ballotBoxes = append(ballotBoxes, "Election Committee")
	for _, box := range ballotBoxes {

		// Filepath
		certDir := ""
		if box == "Election Committee" {
			certDir = committeeDir
		} else {
			certDir = boxDir + "/" + box + "/campusvote-certs"
			os.MkdirAll(certDir, 0755)
		}

		log.Println(box + " : " + certDir)

		// Save the certificate
		certOut, err := os.Create(certDir + "/api-ca.crt")
		if err != nil {
			return err
		}
		pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certCABytes})
		certOut.Close()

		// -------------------

		privKey, err := rsa.GenerateKey(rand.Reader, 4096)
		if err != nil {
			return err
		}

		pubkeyHash := sha1.Sum(x509.MarshalPKCS1PublicKey(&privKey.PublicKey))

		// generate a random serial number
		serialNumberLimit := new(big.Int).Lsh(big.NewInt(1), 128)
		serialNumber, err := rand.Int(rand.Reader, serialNumberLimit)
		if err != nil {
			return errors.New("failed to generate serial number: " + err.Error())
		}

		serverTemplate := x509.Certificate{
			SerialNumber: serialNumber,
			Subject: pkix.Name{
				Country:            []string{"DE"},
				Province:           []string{"NRW"},
				Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
				OrganizationalUnit: []string{fmt.Sprintf("%s - Server %d", box, time.Now().Year())},
				CommonName:         fmt.Sprintf("%s.stupa-bochum.de", box),
			},
			IPAddresses:           []net.IP{net.ParseIP("127.0.0.1")},
			EmailAddresses:        []string{"wahlausschuss@stupa-bochum.de"},
			NotBefore:             time.Now(),
			NotAfter:              time.Now().Add(364 * 24 * time.Hour),
			BasicConstraintsValid: true,
			Issuer:                certCA.Issuer,
			SubjectKeyId:          pubkeyHash[:],
		}

		certServer, err := x509.CreateCertificate(rand.Reader, &serverTemplate, certCA, privKey.Public(), privKeyCA)
		if err != nil {
			return err
		}

		// Save the certificate
		keyOut, err := os.Create(certDir + "/api-server.crt")
		if err != nil {
			return err
		}
		pem.Encode(keyOut, &pem.Block{Type: "CERTIFICATE", Bytes: certServer})
		certOut.Close()

		// Save the private key
		keyOut, err = os.Create(certDir + "/api-server.key")
		if err != nil {
			return err
		}

		pkcs8PrivKey, err := x509.MarshalPKCS8PrivateKey(privKey)
		if err != nil {
			return err
		}
		pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: pkcs8PrivKey})

		keyOut.Chmod(0600)
		keyOut.Close()

		// -------------------

		privKey, err = rsa.GenerateKey(rand.Reader, 4096)
		if err != nil {
			return err
		}

		pubkeyHash = sha1.Sum(x509.MarshalPKCS1PublicKey(&privKey.PublicKey))

		// generate a random serial number
		serialNumber, err = rand.Int(rand.Reader, serialNumberLimit)
		if err != nil {
			return errors.New("failed to generate serial number: " + err.Error())
		}

		clientTemplate := x509.Certificate{
			SerialNumber: serialNumber,
			Subject: pkix.Name{
				Country:            []string{"DE"},
				Province:           []string{"NRW"},
				Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
				OrganizationalUnit: []string{fmt.Sprintf("%s - Client %d", box, time.Now().Year())},
				CommonName:         box,
			},
			IPAddresses:           []net.IP{net.ParseIP("127.0.0.1")},
			EmailAddresses:        []string{"wahlausschuss@stupa-bochum.de"},
			NotBefore:             time.Now(),
			NotAfter:              time.Now().Add(364 * 24 * time.Hour),
			BasicConstraintsValid: true,
			Issuer:                certCA.Issuer,
			SubjectKeyId:          pubkeyHash[:],
		}

		certClient, err := x509.CreateCertificate(rand.Reader, &clientTemplate, certCA, privKey.Public(), privKeyCA)
		if err != nil {
			return err
		}

		// Save the certificate
		certOut, err = os.Create(certDir + "/api-client.crt")
		if err != nil {
			return err
		}
		pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certClient})
		certOut.Close()

		// Save the private key
		keyOut, err = os.Create(certDir + "/api-client.key")
		if err != nil {
			return err
		}

		pkcs8PrivKey, err = x509.MarshalPKCS8PrivateKey(privKey)
		if err != nil {
			return err
		}
		pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: pkcs8PrivKey})

		keyOut.Chmod(0600)
		keyOut.Close()

	}

	return nil
}
