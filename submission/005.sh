# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"


RAW_TX=$(bitcoin-cli getrawtransaction "$TXID" true)

PUBKEYS=()
for script in $(echo "$RAW_TX" | jq -r '.vin[].txid'); do
    VIN_RAW=$(bitcoin-cli getrawtransaction "$script" true)
    PUBKEY=$(echo "$VIN_RAW" | jq -r '.vout[].scriptPubKey.asm' | awk '{print $2}')
    if [[ "$PUBKEY" =~ ^[a-fA-F0-9]{66}$ ]]; then
        PUBKEYS+=("$PUBKEY")
    fi
done

PUBKEYS_JSON=$(jq -n --argjson keys "$(printf '%s\n' "${PUBKEYS[@]}" | jq -R . | jq -s .)" '$keys')

MULTISIG=$(bitcoin-cli createmultisig 1 "$PUBKEYS_JSON")

echo $MULTISIG | jq -r '.address'
