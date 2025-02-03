# Which tx in block 257,343 spends the coinbase output of block 256,128?



BLOCK_HASH_256128=$(bitcoin-cli getblockhash 256128)


COINBASE_TX=$(bitcoin-cli getblock "$BLOCK_HASH_256128" | jq -r '.tx[0]')


BLOCK_HASH_257343=$(bitcoin-cli getblockhash 257343)

TX_LIST=$(bitcoin-cli getblock "$BLOCK_HASH_257343" | jq -r '.tx[]')

for TX in $TX_LIST; do
    RAW_TX=$(bitcoin-cli getrawtransaction "$TX" true)
    MATCH=$(echo "$RAW_TX" | jq -r --arg COINBASE_TX "$COINBASE_TX" '.vin[] | select(.txid == $COINBASE_TX) | .txid')

    if [ -n "$MATCH" ]; then
        echo "A transação que gasta a coinbase do bloco 256,128 no bloco 257,343 é: $TX"
        exit 0
    fi
done

echo "Nenhuma transação encontrada que gasta a coinbase do bloco 256,128 no bloco 257,343."
