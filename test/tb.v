`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
end



  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  
  // Replace tt_um_example with your module name:
  ChiselFilters  uut (
      .clock      (clk),
      .reset      (~rst_n),
      .io_ui_in   (ui_in),
      .io_uo_out  (uo_out),
      .io_uio_in  (uio_in),
      .io_uio_out (uio_out),
      .io_uio_oe  (uio_oe)
  );

endmodule
