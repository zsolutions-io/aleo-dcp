# Reconstruct Secret Program

Reconstruct a secret from shares.

It is meant to be executed offchain to recover a secret received from the protocol.

## Usage

### Example

To reconstruct 3 shares:

```bash
leo run reconstruct_secret_offchain "[
    {share_val:3142197879141985field,index:1field}, \
    {share_val:28673026215703456field,index:4field}, \
    {share_val:42551380561059241field,index:5field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field}, \
    {share_val:0field,index:0field} \
]"
```

## Author

Pierre-André LONG - <contact@aleo.store>
