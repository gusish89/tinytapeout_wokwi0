circuit ChiselTop :
  module ChiselTop :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip ui_in : UInt<8>, uo_out : UInt<8>, flip uio_in : UInt<8>, uio_out : UInt<8>, uio_oe : UInt<8>}

    io.uio_out <= UInt<1>("h0") @[ChiselTop.scala 16:14]
    io.uio_oe <= UInt<1>("h0") @[ChiselTop.scala 18:13]
    wire add : UInt<7> @[ChiselTop.scala 20:24]
    add <= UInt<7>("h0") @[ChiselTop.scala 20:24]
    node _add_T = add(io.ui_in, io.uio_in) @[ChiselTop.scala 21:19]
    node _add_T_1 = tail(_add_T, 1) @[ChiselTop.scala 21:19]
    add <= _add_T_1 @[ChiselTop.scala 21:7]
    reg cntReg : UInt<32>, clock with :
      reset => (reset, UInt<32>("h0")) @[ChiselTop.scala 24:23]
    reg ledReg : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[ChiselTop.scala 25:23]
    node _cntReg_T = add(cntReg, UInt<1>("h1")) @[ChiselTop.scala 26:20]
    node _cntReg_T_1 = tail(_cntReg_T, 1) @[ChiselTop.scala 26:20]
    cntReg <= _cntReg_T_1 @[ChiselTop.scala 26:10]
    node _T = eq(cntReg, UInt<25>("h17d7840")) @[ChiselTop.scala 27:16]
    when _T : @[ChiselTop.scala 27:32]
      cntReg <= UInt<1>("h0") @[ChiselTop.scala 28:12]
      node _ledReg_T = not(ledReg) @[ChiselTop.scala 29:15]
      ledReg <= _ledReg_T @[ChiselTop.scala 29:12]
    node _io_uo_out_T = cat(ledReg, add) @[ChiselTop.scala 31:23]
    io.uo_out <= _io_uo_out_T @[ChiselTop.scala 31:13]

