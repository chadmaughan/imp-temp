#!/bin/bash
#curl -v -X POST http://localhost:9393 --data @example.json -H "Content-Type: application/json"
curl -v -X POST http://cmm-imp-temp.herokuapp.com --data @example.json -H "Content-Type: application/json"
