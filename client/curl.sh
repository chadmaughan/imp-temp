#!/bin/bash
curl -v -X POST http://localhost:9393 --data @example.json -H "Content-Type: application/json"
