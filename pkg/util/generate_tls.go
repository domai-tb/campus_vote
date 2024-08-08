package helper

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"fmt"
	"math/big"
	"net"
	"os"
	"time"
)

func GenerateTLSCerts() {

	// pubKeyCA, privKeyCA, err := ed25519.GenerateKey(rand.Reader)
	privKeyCA, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		panic(err)
	}

	caTemplate := x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject: pkix.Name{
			Country:            []string{"DE"},
			Province:           []string{"NRW"},
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Wahlauschuss %d", time.Now().Year())},
			CommonName:         "*.stupa-bochum.de",
		},
		EmailAddresses: []string{"wahlausschuss@stupa-bochum.de"},
		NotBefore:      time.Now(),
		NotAfter:       time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:       x509.KeyUsageCertSign,
		// BasicConstraintsValid: true,
		IsCA: true,
	}

	// Create the certificate
	// certCABytes, err := x509.CreateCertificate(rand.Reader, &caTemplate, &caTemplate, pubKeyCA, privKeyCA)
	certCABytes, err := x509.CreateCertificate(rand.Reader, &caTemplate, &caTemplate, privKeyCA.Public(), privKeyCA)
	if err != nil {
		panic(err)
	}

	// parse certificate
	certCA, err := x509.ParseCertificate(certCABytes)
	if err != nil {
		panic(err)
	}

	// Save the certificate
	certOut, err := os.Create("certs/api-ca.crt")
	if err != nil {
		panic(err)
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certCABytes})
	certOut.Close()

	// -------------------

	serverTemplate := x509.Certificate{
		SerialNumber: big.NewInt(2),
		Subject: pkix.Name{
			Country:            []string{"DE"},
			Province:           []string{"NRW"},
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Urne 1 %d - Server", time.Now().Year())},
			CommonName:         "*.stupa-bochum.de",
		},
		IPAddresses:    []net.IP{net.ParseIP("127.0.0.1")},
		EmailAddresses: []string{"wahlausschuss@stupa-bochum.de"},
		NotBefore:      time.Now(),
		NotAfter:       time.Now().Add(365 * 24 * time.Hour),
		// KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		// ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
		// PublicKeyAlgorithm:    x509.Ed25519,
		Issuer: certCA.Issuer,
	}

	// pubKey, privKey, err := ed25519.GenerateKey(rand.Reader)
	privKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		panic(err)
	}

	// certServer, err := x509.CreateCertificate(rand.Reader, &serverTemplate, certCA, pubKey, privKeyCA)
	certServer, err := x509.CreateCertificate(rand.Reader, &serverTemplate, certCA, privKey.Public(), privKeyCA)
	if err != nil {
		panic(err)
	}

	// Save the certificate
	keyOut, err := os.Create("certs/api-server.crt")
	if err != nil {
		panic(err)
	}
	pem.Encode(keyOut, &pem.Block{Type: "CERTIFICATE", Bytes: certServer})
	certOut.Close()

	// Save the private key
	keyOut, err = os.Create("certs/api-server.key")
	if err != nil {
		panic(err)
	}

	// pkcs8PrivKey, err := x509.MarshalPKCS8PrivateKey(privKey)
	// if err != nil {
	// 	panic(err)
	// }
	// pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: pkcs8PrivKey})
	pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(privKey)})

	keyOut.Close()

	// -------------------

	clientTemplate := x509.Certificate{
		SerialNumber: big.NewInt(3),
		Subject: pkix.Name{
			Country:            []string{"DE"},
			Province:           []string{"NRW"},
			Organization:       []string{"Studierendenparlament der Ruhr-Universität Bochum"},
			OrganizationalUnit: []string{fmt.Sprintf("Urne 1 %d - Client", time.Now().Year())},
			CommonName:         "*.stupa-bochum.de",
		},
		IPAddresses:    []net.IP{net.ParseIP("127.0.0.1")},
		EmailAddresses: []string{"wahlausschuss@stupa-bochum.de"},
		NotBefore:      time.Now(),
		NotAfter:       time.Now().Add(365 * 24 * time.Hour),
		// KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		// ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageClientAuth},
		BasicConstraintsValid: true,
		// PublicKeyAlgorithm:    x509.Ed25519,
		Issuer: certCA.Issuer,
	}

	// pubKey, privKey, err = ed25519.GenerateKey(rand.Reader)
	privKey, err = rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		panic(err)
	}

	// certClient, err := x509.CreateCertificate(rand.Reader, &clientTemplate, certCA, pubKey, privKeyCA)
	certClient, err := x509.CreateCertificate(rand.Reader, &clientTemplate, certCA, privKey.Public(), privKeyCA)
	if err != nil {
		panic(err)
	}

	// Save the certificate
	certOut, err = os.Create("certs/api-client.crt")
	if err != nil {
		panic(err)
	}
	pem.Encode(certOut, &pem.Block{Type: "CERTIFICATE", Bytes: certClient})
	certOut.Close()

	// Save the private key
	keyOut, err = os.Create("certs/api-client.key")
	if err != nil {
		panic(err)
	}

	// pkcs8PrivKey, err = x509.MarshalPKCS8PrivateKey(privKey)
	// if err != nil {
	// 	panic(err)
	// }
	// pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: pkcs8PrivKey})
	pem.Encode(keyOut, &pem.Block{Type: "PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(privKey)})

	keyOut.Close()
}
