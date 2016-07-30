package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
)

// message comment
type message struct {
	Value string `json:"value"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {
		var m message

		data := []byte(`{"value":"Hello World!"}`)

		if err := json.Unmarshal(data, &m); err != nil {
			return nil, err
		}

		return m, nil
	})
}
