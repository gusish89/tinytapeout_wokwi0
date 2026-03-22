module ChiselFilters(
  input        clock,
  input        reset,
  input  [7:0] io_ui_in,
  output [7:0] io_uo_out,
  input  [7:0] io_uio_in,
  output [7:0] io_uio_out,
  output [7:0] io_uio_oe
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] inShift; // @[Chisel_filters.scala 18:24]
  reg [3:0] inCount; // @[Chisel_filters.scala 19:24]
  reg [3:0] outCount; // @[Chisel_filters.scala 20:25]
  reg [15:0] filterOutput; // @[Chisel_filters.scala 22:29]
  reg [15:0] prev_signal; // @[Chisel_filters.scala 23:28]
  reg  outActive; // @[Chisel_filters.scala 24:26]
  reg  filtersel; // @[Chisel_filters.scala 26:26]
  reg  start; // @[Chisel_filters.scala 27:22]
  wire  unusedInputs = |io_ui_in[7:2] | |io_uio_in; // @[Chisel_filters.scala 32:41]
  wire  _GEN_1 = start ? 1'h0 : start; // @[Chisel_filters.scala 40:12 27:22 42:9]
  wire [15:0] nextShift = {inShift[14:0],io_ui_in[0]}; // @[Cat.scala 33:92]
  wire  numComplete = inCount == 4'hf; // @[Chisel_filters.scala 60:28]
  wire [15:0] _T = {inShift[14:0],io_ui_in[0]}; // @[Chisel_filters.scala 61:44]
  wire [15:0] delta = $signed(_T) - $signed(prev_signal); // @[Chisel_filters.scala 48:17]
  wire [9:0] err = delta[15:6]; // @[Chisel_filters.scala 49:21]
  wire [15:0] _GEN_16 = {{6{err[9]}},err}; // @[Chisel_filters.scala 50:23]
  wire [15:0] lowpass = $signed(prev_signal) + $signed(_GEN_16); // @[Chisel_filters.scala 50:23]
  wire [15:0] _calculation_T = $signed(prev_signal) + $signed(_GEN_16); // @[Chisel_filters.scala 66:26]
  wire [15:0] _calculation_T_1 = $signed(_T) - $signed(lowpass); // @[Chisel_filters.scala 68:27]
  wire [15:0] calculation = filtersel ? _calculation_T : _calculation_T_1; // @[Chisel_filters.scala 65:24 66:15 68:15]
  wire [3:0] _inCount_T_1 = inCount + 4'h1; // @[Chisel_filters.scala 76:22]
  wire [7:0] _io_uo_out_T_1 = {7'h0,calculation[15]}; // @[Cat.scala 33:92]
  wire [15:0] _filterOutput_T_1 = {calculation[14:0],1'h0}; // @[Cat.scala 33:92]
  wire [7:0] _io_uo_out_T_3 = {7'h0,filterOutput[15]}; // @[Cat.scala 33:92]
  wire [15:0] _filterOutput_T_3 = {filterOutput[14:0],1'h0}; // @[Cat.scala 33:92]
  wire [3:0] _outCount_T_1 = outCount + 4'h1; // @[Chisel_filters.scala 93:26]
  wire  _GEN_5 = outCount == 4'hf ? 1'h0 : outActive; // @[Chisel_filters.scala 89:27 90:15 24:26]
  wire [7:0] _GEN_7 = outActive ? _io_uo_out_T_3 : 8'h0; // @[Chisel_filters.scala 30:12 86:22 87:13]
  wire  _GEN_9 = outActive ? _GEN_5 : outActive; // @[Chisel_filters.scala 86:22 24:26]
  wire  _GEN_14 = numComplete | _GEN_9; // @[Chisel_filters.scala 79:18 83:14]
  assign io_uo_out = numComplete ? _io_uo_out_T_1 : _GEN_7; // @[Chisel_filters.scala 79:18 80:14]
  assign io_uio_out = 8'h0; // @[Chisel_filters.scala 28:14]
  assign io_uio_oe = 8'h0; // @[Chisel_filters.scala 29:14]
  always @(posedge clock) begin
    if (reset) begin // @[Chisel_filters.scala 18:24]
      inShift <= 16'h0; // @[Chisel_filters.scala 18:24]
    end else if (numComplete) begin // @[Chisel_filters.scala 72:18]
      inShift <= 16'h0; // @[Chisel_filters.scala 74:11]
    end else begin
      inShift <= nextShift; // @[Chisel_filters.scala 57:9]
    end
    if (reset) begin // @[Chisel_filters.scala 19:24]
      inCount <= 4'h0; // @[Chisel_filters.scala 19:24]
    end else if (numComplete) begin // @[Chisel_filters.scala 72:18]
      inCount <= 4'h0; // @[Chisel_filters.scala 73:11]
    end else begin
      inCount <= _inCount_T_1; // @[Chisel_filters.scala 76:11]
    end
    if (reset) begin // @[Chisel_filters.scala 20:25]
      outCount <= 4'h0; // @[Chisel_filters.scala 20:25]
    end else if (numComplete) begin // @[Chisel_filters.scala 79:18]
      outCount <= 4'h1; // @[Chisel_filters.scala 82:14]
    end else if (outActive) begin // @[Chisel_filters.scala 86:22]
      if (outCount == 4'hf) begin // @[Chisel_filters.scala 89:27]
        outCount <= 4'h0; // @[Chisel_filters.scala 91:14]
      end else begin
        outCount <= _outCount_T_1; // @[Chisel_filters.scala 93:14]
      end
    end
    if (reset) begin // @[Chisel_filters.scala 22:29]
      filterOutput <= 16'h0; // @[Chisel_filters.scala 22:29]
    end else if (numComplete) begin // @[Chisel_filters.scala 79:18]
      filterOutput <= _filterOutput_T_1; // @[Chisel_filters.scala 81:17]
    end else if (outActive) begin // @[Chisel_filters.scala 86:22]
      filterOutput <= _filterOutput_T_3; // @[Chisel_filters.scala 88:16]
    end
    if (reset) begin // @[Chisel_filters.scala 23:28]
      prev_signal <= 16'sh0; // @[Chisel_filters.scala 23:28]
    end else if (numComplete) begin // @[Chisel_filters.scala 79:18]
      prev_signal <= lowpass; // @[Chisel_filters.scala 84:16]
    end
    if (reset) begin // @[Chisel_filters.scala 24:26]
      outActive <= 1'h0; // @[Chisel_filters.scala 24:26]
    end else begin
      outActive <= _GEN_14;
    end
    if (reset) begin // @[Chisel_filters.scala 26:26]
      filtersel <= 1'h0; // @[Chisel_filters.scala 26:26]
    end else if (start) begin // @[Chisel_filters.scala 40:12]
      filtersel <= io_ui_in[1]; // @[Chisel_filters.scala 41:13]
    end
    start <= reset | _GEN_1; // @[Chisel_filters.scala 27:{22,22}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  inShift = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  inCount = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  outCount = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  filterOutput = _RAND_3[15:0];
  _RAND_4 = {1{`RANDOM}};
  prev_signal = _RAND_4[15:0];
  _RAND_5 = {1{`RANDOM}};
  outActive = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  filtersel = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  start = _RAND_7[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
