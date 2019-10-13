

/******************************************************************************
* file: max_weight.s
* author: ARUN A. M. 
* Roll No.: CS18M510
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Find the 32 bit number and its max weight (having the maximum number of 1 bit) from the given list of 32bit numbers
  */

  @ BSS section
      .bss

  @ DATA SECTION
      .data
data_start: .word 0x205A15E3 @(0010 0000 0101 1010 0001 0101 1101 0011 – 13)
            .word 0x7786932D @(‭0111 0111 1000 0110 1001 0011 0010 1101‬ - 17)
            .word 0x256C8700 @(0010 0101 0110 1100 1000 0111 0000 0000 – 11)
            .word 0x4FD63278 @(‭0100 1111 1101 0110 0011 0010 0111 1000 - 17‬)
            .word 0x387FFF69 @(‭0011 1000 0111 1111 1111 1111 0110 1001‬ - 22)
            .word 0x22561AB1 @(‭0010 0010 0101 0110 0001 1010 1011 0001‬ - 13)
data_end:   .word 0x295468F2 @(0010 1001 0101 0100 0110 1000 1111 0010 – 14)

NUM: .word 0
WEIGHT: .word 0

  @ TEXT section
      .text

.globl _main


_main:
    @Load the addresses of data start and end
    LDR r0, =data_start
    LDR r1, =data_end

    @Set the Number and its Max weight as 0
    MOV r2, #0 @TEMP NUM
    MOV r9, #0 @TEMP WEIGHT

@Iterate over the given list of words between data_start and data_end

LOOP_LIST:
    @Check for end of data list by comparing the data_start and data_end addresses
    @If data_start > data_end, then jump to exit and store the output values 
    CMP r0, r1
    BGT END

    @Load the 32bit word into r3 and create a copy in r4
    LDR r3, [r0]
    MOV r4, r3
    MOV r5, #32 @Set r5 as 32 for 32bit decrement Counter
    MOV r8, #0  @Set r8 as 0 for counting the 1bit in 32bit

@Check the weight or number of 1s in the 32bit word
CHECK_BITS:
    MOV r6, #1  @Set r6 as 1 for masking lsb
    
    @Check if the lsb of r3 is 1, if so add 1 to counter r8
    AND r7, r3, r6  
    CMP r7, #1
    ADDEQ r8, r8, #1

    @Shift Right the 32bit word r3 and decrement the 32bit counter r5 by 1, if not zero i.e still remaining r5 bits to be checked 
    @Then loop CHECK_BITS for checking the remaining 1s 
    MOV r3, r3, LSR #1
    SUBS r5,r5,#1
    BNE CHECK_BITS  
    
    @Iterated through the 32bit number, so add 4 to data_start address in r0 to move to next data word
    ADD r0, r0, #4
    CMP r8, r9  @If the current calculated weight r8 of number r0 is less than the max weight r9, then loop again 
    BLT LOOP_LIST
    
    @Set the current calculated weight r8 of number r0 as max weight r9 
    @if r0 has higher weight r8 compared to current max number r2 with max weight r9 
    MOV r2, r4
    MOV r9, r8
    B LOOP_LIST @Iterate through remaining numbers

END:
    @Load the addresses of NUM and WEIGHT to r4 and r5 and save the number r2 having the maximum weight r9 in the list to those addresses
    LDR r4, =NUM
    LDR r5, =WEIGHT
    STR r2, [r4]
    STR r9, [r5]
    SWI 0x11
    .end

    


