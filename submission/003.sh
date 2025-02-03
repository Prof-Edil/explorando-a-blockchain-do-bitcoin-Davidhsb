# How many new outputs were created by block 123,456?

# Obtém o hash do bloco
BLOCK_HASH=$(bitcoin-cli getblockhash 123456)

# Obtém os detalhes do bloco com as transações
BLOCK_DATA=$(bitcoin-cli getblock $BLOCK_HASH)

TXIDS=$(echo $BLOCK_DATA | jq -r '.tx[]')

BLOCK_OUTPUTS=0

for tx in $TXIDS; do
  TX_DATA=$(bitcoin-cli getrawtransaction $tx true)

  TX_OUTPUTS_LENGTH=$(echo $TX_DATA | jq '.vout | length')

  BLOCK_OUTPUTS=$((BLOCK_OUTPUTS + TX_OUTPUTS_LENGTH))
done

echo $BLOCK_OUTPUTS
