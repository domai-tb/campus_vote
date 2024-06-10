# Custome GORM Driver for CockRoachDB

This package internal package is an adjustment of the official [GORM Postgres driver](https://github.com/go-gorm/postgres) to allow TLS specific configuration.
This adjusment is needed to provide a way to load the certificates from keychain / credential manager stored secrets.

---

# GORM PostgreSQL Driver

## Quick Start

```go
import (
  "gorm.io/driver/postgres"
  "gorm.io/gorm"
)

// https://github.com/jackc/pgx
dsn := "host=localhost user=gorm password=gorm dbname=gorm port=9920 sslmode=disable TimeZone=Asia/Shanghai"
db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
```

## Configuration

```go
import (
  "gorm.io/driver/postgres"
  "gorm.io/gorm"
)

db, err := gorm.Open(postgres.New(postgres.Config{
  DSN: "host=localhost user=gorm password=gorm dbname=gorm port=9920 sslmode=disable TimeZone=Asia/Shanghai", // data source name, refer https://github.com/jackc/pgx
  PreferSimpleProtocol: true, // disables implicit prepared statement usage. By default pgx automatically uses the extended protocol
}), &gorm.Config{})
```

Checkout [https://gorm.io](https://gorm.io) for details.
