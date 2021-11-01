
# RSC-Forth CF Card Mass Storage Driver

## Description

Provides a user mass storage driver for RSC-Forth that allows it to access a compact flash card.

## Files

* `forth_cf.f` - The main driver
* `cfinfo.f` - Compact Flash card information
* `tests.f` - Misc. testing words

## Hardware Requirements

* A computer capable of running Rockwell RSC-Forth
* A compact flash card mapped into memory somewhere

The development work on this driver was done primarily using the Glitch Works R65X1Q single-board computer available here: <https://www.tindie.com/products/glitchwrks/glitch-works-r6501qr6511q-single-board-computer/>

The compact flash adapter used is a stack-on expansion board also provided by Glitch Works. It is available here: <https://www.tindie.com/products/glitchwrks/glitch-works-compactflash-adapter-for-glitchbus/>

## How To Install

1. Modify the `IOPAGE` constant in `forth_cf.f` to match your hardware setup. **For a GW-R65X1Q-SBC, the default value does not need to be modified.**
2. Set up your terminal emulator software to provide around 25ms character delay and 100ms new line delay. **This may need to be tweaked depending on the board**
3. Paste the modified `forth_cf.f` file into the Forth prompt. The statement at the end of the file automatically activates the driver.
4. Run the word `CFINIT` to initialize the CF card

Please Note: **This is not a permanent install.** Whenever RSC-Forth is cold started, you will need to install the driver again.

At this point the driver should be functional. Chapter 12 of the RSC-Forth user manual provides instructions on using mass storage for reading/writing screens, large data storage, etc. The manual can be found here: <http://www.smallestplcoftheworld.org/RSC-FORTH_User%27s_Manual.pdf>

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
