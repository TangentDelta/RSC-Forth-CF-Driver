0 VARIABLE CFBUFF 1FE ALLOT

: CFINFO ( --- . DISPLAYS INFORMATION ABOUT THE CF CARD )
  CFWAIT
  EC CFBASE 7 + C!  ( IDENTIFY )
  CFWAIT

  CFBUFF
  BEGIN
    DUP CFBASE C@ SWAP C! 1 +
    ?CFDRQ
  UNTIL
  DROP

  CR ." SERIAL NUMBER: "
  A 0 DO ( SWAP THE BYTES OF THE SERIAL NUMBER STRING )
    CFBUFF 14 +  ( MOVE TO THE POSITION OF THE STRING )
    I 2 * +  ( SET THE OFFSET )
    BYTESWAP ( SWAP THE TWO BYTES )
  LOOP

  CFBUFF 14 + 14 TYPE ( PRINT OUT THE SERIAL NUMBER )


  CR ." MODEL: "
  14 0 DO ( SWAP THE BYTES OF THE MODEL NUMBER STRING )
    CFBUFF 36 +  ( MOVE TO THE POSITION OF THE STRING )
    I 2 * +  ( SET THE OFFSET )
    BYTESWAP ( SWAP THE TWO BYTES )
  LOOP
  
  CFBUFF 36 + 28 TYPE ( PRINT OUT THE MODEL NUMBER )

  CR ." LBA BLOCKS: "
  CFBUFF 72 + @ ( GET LSW )
  CFBUFF 74 + @ ( GET MSW )
  <# #S #> TYPE CR
;