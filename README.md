
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
3. Paste the modified `forth_cf.f` file into the Forth prompt. The statement at the end of the file automatically activates the driver and initializes the CF card.

Please Note: **This is not a permanent install.** Whenever RSC-Forth is cold started, you will need to install the driver again.

At this point the driver should be functional. Chapter 12 of the RSC-Forth user manual provides instructions on using mass storage for reading/writing screens, large data storage, etc. The manual can be found here: <http://www.smallestplcoftheworld.org/RSC-FORTH_User%27s_Manual.pdf>

## Getting Started

You should probably start by wiping some fresh screens in order to test the CF card. Here is an example WIPE word:

```forth
HEX
: WIPE ( BLOCK-NO --- )
  BLOCK 400 BLANKS UPDATE FLUSH
;
```

To use this word, provide it with a screen number to completely wipe (fill with space characters). `10 WIPE` will wipe out screen 10 for use.

The contents of a screen can be listed with the `LIST` word.

```text
10 LIST<cr>
SCR # 16 
  0 
  1 
  2 
  3 
  4 
  5 
  6 
  7 
  8 
  9 
 10 
 11 
 12 
 13 
 14 
 15 
OK
```

RSC-Forth includes a very simple line editor, `>LINE`, that uses the last `LIST`ed screen. Provide it with the line number to edit on top of the stack and then type out the text that you would like to place on that line.

```text
3 >LINE THIS IS LINE 3!<cr>
OK
10 LIST<cr>
SCR # 16 
  0 
  1 
  2 
  3 THIS IS LINE 3!
  4 
  5 
  6 
  7 
  8 
  9 
 10 
 11 
 12 
 13 
 14 
 15 
OK
```

This should be enough to test the CF card.

## Included Words

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
