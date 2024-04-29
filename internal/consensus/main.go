package consensus

import (
	"bytes"

	"github.com/dgraph-io/badger"
	abcitypes "github.com/tendermint/tendermint/abci/types"
)

type KVStoreApplication struct {
	db           *badger.DB
	currentBatch *badger.Txn
}

func NewKVStoreApplication(db *badger.DB) *KVStoreApplication {
	return &KVStoreApplication{
		db: db,
	}
}

var _ abcitypes.Application = (*KVStoreApplication)(nil)

func (app *KVStoreApplication) isValid(tx []byte) (code uint32) {
	// check format
	parts := bytes.Split(tx, []byte("="))
	if len(parts) != 2 {
		return 1
	}

	key, value := parts[0], parts[1]

	// check if the same key=value already exists
	err := app.db.View(func(txn *badger.Txn) error {
		item, err := txn.Get(key)
		if err != nil && err != badger.ErrKeyNotFound {
			return err
		}
		if err == nil {
			return item.Value(func(val []byte) error {
				if bytes.Equal(val, value) {
					code = 2
				}
				return nil
			})
		}
		return nil
	})
	if err != nil {
		panic(err)
	}

	return code
}

func (app *KVStoreApplication) DeliverTx(req abcitypes.RequestDeliverTx) abcitypes.ResponseDeliverTx {
	// code := app.isValid(req.Tx)
	// if code != 0 {
	// 	return abcitypes.ResponseDeliverTx{Code: code}
	// }

	// parts := bytes.Split(req.Tx, []byte("="))
	// key, value := parts[0], parts[1]

	// err := app.currentBatch.Set(key, value)
	// if err != nil {
	// 	panic(err)
	// }

	// return abcitypes.ResponseDeliverTx{Code: 0}
	return abcitypes.ResponseDeliverTx{}
}

func (app *KVStoreApplication) CheckTx(req abcitypes.RequestCheckTx) abcitypes.ResponseCheckTx {
	// code := app.isValid(req.Tx)
	// return abcitypes.ResponseCheckTx{Code: code, GasWanted: 1}
	return abcitypes.ResponseCheckTx{}
}

func (app *KVStoreApplication) Commit() abcitypes.ResponseCommit {
	// app.currentBatch.Commit()
	// return abcitypes.ResponseCommit{Data: []byte{}}
	return abcitypes.ResponseCommit{}
}

func (app *KVStoreApplication) Query(reqQuery abcitypes.RequestQuery) (resQuery abcitypes.ResponseQuery) {
	// resQuery.Key = reqQuery.Data
	// err := app.db.View(func(txn *badger.Txn) error {
	// 	item, err := txn.Get(reqQuery.Data)
	// 	if err != nil && err != badger.ErrKeyNotFound {
	// 		return err
	// 	}
	// 	if err == badger.ErrKeyNotFound {
	// 		resQuery.Log = "does not exist"
	// 	} else {
	// 		return item.Value(func(val []byte) error {
	// 			resQuery.Log = "exists"
	// 			resQuery.Value = val
	// 			return nil
	// 		})
	// 	}
	// 	return nil
	// })
	// if err != nil {
	// 	panic(err)
	// }
	// return
	return abcitypes.ResponseQuery{}
}

func (app *KVStoreApplication) BeginBlock(req abcitypes.RequestBeginBlock) abcitypes.ResponseBeginBlock {
	// app.currentBatch = app.db.NewTransaction(true)
	return abcitypes.ResponseBeginBlock{}
}