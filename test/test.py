# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

from ast import pattern

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

def bits_to_word_msb_first(bits):
    w = 0
    for b in bits:
        w = (w << 1) | b
    return w


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.uio_oe.value = 1

    


# ...existing code...
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")
    out_bits = []
    # Set the input values you want to test
    pattern = "1111000011110000101010101010101000000000000000000000000000"  # Example pattern to drive ui_in, change as needed
   
    for i,b in enumerate(pattern):
        dut.ui_in.value = (int(b) << 0) | (1 << 1)
        await ClockCycles(dut.clk, 1)
        out_bit = int(dut.uo_out.value) & 0x1   # your design drives output bit on uo_out[0]
        out_bits.append(out_bit)
        dut._log.info(f"Output frame: {dut.ui_in.value}")  
        

        
   

    ## The first outputs starts to be loaded out on the 15th clock cycle 
    for i in range(2):
        start = 15 + i*16
        frame = out_bits[start:start+16]  # Get the first 16 bits of output after the initial 16 input bits
        dut._log.info(f"Output frame: {frame}")   
        msb_word = bits_to_word_msb_first(frame)
        dut._log.info(f"MSB-first word: {msb_word}")
        # if i <1:    
        #     assert msb_word == 0xFFC3
        # if i == 1:
        #     assert msb_word == 0xFE6E  
            
        
  

   
   

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 30)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 0000000000000000
   

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
