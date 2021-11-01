
# RSC-Forth CF Card Mass Storage Driver

## Description

Provides a user mass storage driver for RSC-Forth that allows it to access a compact flash card.

## Included Words

### BYTESWAP ( START-ADDR --- )

Swaps the byte at `START-ADDR` with the byte at `START-ADDR + 1`.

### CFWAIT ( --- )

Waits for the CF card to become ready, indicated by the `BSY` flag going clear.

### CFERR ( --- )

Prints "CF CARD ERROR!" if the CF card is in an error state.

### ?CFDRQ ( --- !DRQ )

Returns a boolean true when the CF card is not expecting any data transfers. Return false when the CF card is expecting data transferred to/from it.

### CFLBA! ( LBA. --- )

Takes a 32-bit unsigned double word and writes it to the CF card's LBA registers.

### CFREAD ( ADDR --- )

Reads into memory starting at ADDR from the CF card until the CF card no longer has data to transfer.

### CFWRITE ( ADDR --- )

Writes into memory starting at ADDR to the CF card until the CF card no longer expects data.

### CFINIT ( --- )

Initializes the compact flash card. This must be run prior to attempting data access!
The CF card is placed into LBA mode with 8-bit data transfers.

### CFR/W ( MEMADDR BLOCK# READ --- )

The mass storage driver for RSC-Forth. When `READ` is true, a read operation is performed. Otherwise, a write operation occurs.
The 1024-byte block, specified by `BLOCK#`, is transfered to/from the memory location starting at `MEMADDR`.
This mass storage driver interface is RSC-Forth specific as far as I can tell.
