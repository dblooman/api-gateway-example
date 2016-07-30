package main

import (
	"encoding/json"

	"github.com/apex/go-apex"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

// DynamoResp json
type DynamoResp struct {
	ID        string `json:"Id"`
	AlarmName string `json:"alarm_name"`
	Message   string `json:"message"`
}

func main() {
	apex.HandleFunc(func(event json.RawMessage, ctx *apex.Context) (interface{}, error) {

		svc := dynamodb.New(session.New())

		params := &dynamodb.ScanInput{
			TableName: aws.String("portyard"),
		}

		resp, err := svc.Scan(params)

		if err != nil {
			return "error", err
		}

		dynresp := []DynamoResp{}

		for _, items := range resp.Items {
			data := DynamoResp{
				ID:        *items["Id"].S,
				Message:   *items["message"].S,
				AlarmName: *items["alarm_name"].S,
			}

			dynresp = append(dynresp, data)
		}
		return dynresp, err
	})
}
