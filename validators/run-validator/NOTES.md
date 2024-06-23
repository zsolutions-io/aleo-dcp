# Notes

```bash
snarkos developer execute \
  --private-key $PRIVATE_KEY \
  --query https://api.explorer.aleo.org/v1 \
  --priority-fee 0 \
  --broadcast https://api.explorer.aleo.org/v1/testnet/transaction/broadcast \
  --network 1 \
  credits.aleo \
  transfer_public_to_private \
    aleo1wamjqlka7d0gazlxdys6n8e8zeee3ymedwvw8elvh7529kwd45rq0plgax \
    15000000u64

>
record1qyqsqrnce0z2ap4j84t207hj368jlmjmvxn2t829tmu40z3d9n5p72swqyxx66trwfhkxun9v35hguerqqpqzqqrqvlk62v4wr8ed5slvnvm3rkgsl0kjypdcd0dj88v588kr377qgysnk2madjdanvtn5h3v77ygkpmh9ddyrrk48dghu5nypdut7zpqtgtgw6

>
"{owner: aleo1wamjqlka7d0gazlxdys6n8e8zeee3ymedwvw8elvh7529kwd45rq0plgax.private,microcredits: 15000000u64.private,_nonce: 7470890124803124826188242195496733531353789695378683653633616209990594922761group.public}"
```

snarkos developer execute \
  --private-key $PRIVATE_KEY \
  --query <https://api.explorer.aleo.org/v1> \
  --priority-fee 0 \
  --broadcast <https://api.explorer.aleo.org/v1/testnet/transaction/broadcast> \
  --network 1 \
  credits.aleo \
  transfer_private \
    "{owner: aleo1wamjqlka7d0gazlxdys6n8e8zeee3ymedwvw8elvh7529kwd45rq0plgax.private,microcredits: 15000000u64.private,_nonce: 7470890124803124826188242195496733531353789695378683653633616209990594922761group.public}" \
    aleo1wamjqlka7d0gazlxdys6n8e8zeee3ymedwvw8elvh7529kwd45rq0plgax \
    1000000u64
