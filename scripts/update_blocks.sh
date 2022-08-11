#!/bin/bash

FINASCAN_EXPLORER="https://finascan.io/"

FETCH_LAST_BLOCK_ENDPOINT="api/?module=block&action=eth_block_number"
BLOCK_DATA_ENDPOINT="graphiql"

function fetch_block_data() {
  url="$1""$BLOCK_DATA_ENDPOINT"
  BLOCK_NUMBER="$2"
  curl -H 'Content-Type: application/json' -X POST -d '{ "query": "query { block(number: '"$BLOCK_NUMBER"') { hash, totalDifficulty }}" }' "$url" > block_info.txt
  BLOCK_HASH=$(sed -E 's/.*"hash":"?([^,"]*)"?.*/\1/' block_info.txt)
  BLOCK_TOTAL_DIFFICULTY=$(sed -E 's/.*"totalDifficulty":"?([^,"]*)"?.*/\1/' block_info.txt)
  rm -rf block_info.txt
}

function fetch_last_block() {
  url="$1""$FETCH_LAST_BLOCK_ENDPOINT"
  curl "$url" -H "Accept: application/json" > block_data.txt
  BLOCK_NUMBER=$(($(sed -E 's/.*"result":"?([^,"]*)"?.*/\1/' block_data.txt)))
  rm -rf block_data.txt
  fetch_block_data "$1" "$BLOCK_NUMBER"
}

function update_finachain() {
  sed -i 's/\"PivotNumber\":.*/\"PivotNumber\": '"$BLOCK_NUMBER"',/g' "./specs/configs/finachain.cfg"
  sed -i 's/\"PivotHash\":.*/\"PivotHash\": "'"$BLOCK_HASH"'",/g' "./specs/configs/finachain.cfg"
  sed -i 's/\"PivotTotalDifficulty\":.*/\"PivotTotalDifficulty\": "'"$BLOCK_TOTAL_DIFFICULTY"'",/g' "./specs/configs/finachain.cfg"

  sed -i 's/\"PivotNumber\":.*/\"PivotNumber\": '"$BLOCK_NUMBER"',/g' "./specs/configs/finachain_validator.cfg"
  sed -i 's/\"PivotHash\":.*/\"PivotHash\": "'"$BLOCK_HASH"'",/g' "./specs/configs/finachain_validator.cfg"
  sed -i 's/\"PivotTotalDifficulty\":.*/\"PivotTotalDifficulty\": "'"$BLOCK_TOTAL_DIFFICULTY"'",/g' "./specs/configs/finachain_validator.cfg"
}

function fetch_finachain() {
  fetch_last_block "$FINASCAN_EXPLORER"
  update_finachain
}


fetch_finachain
