# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`


TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

RAW_TX=$(bitcoin-cli getrawtransaction "$TXID" true)

PUBKEYS=$(echo "$RAW_TX" | jq -r '.vin[].scriptSig.asm' | awk '{print $2}' | grep -E '^[a-fA-F0-9]{66}$')

PUBKEYS_JSON=$(echo "$PUBKEYS" | jq -R -s 'split("\n") | map(select(. != ""))')

MULTISIG=$(bitcoin-cli createmultisig 1 "$PUBKEYS_JSON")

echo "$MULTISIG" | jq -r '.address'

