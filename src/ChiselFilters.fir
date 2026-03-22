circuit ChiselFilters :
  module ChiselFilters :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip ui_in : UInt<8>, uo_out : UInt<8>, flip uio_in : UInt<8>, uio_out : UInt<8>, uio_oe : UInt<8>}

    reg inShift : UInt<16>, clock with :
      reset => (reset, UInt<16>("h0")) @[Chisel_filters.scala 18:24]
    reg inCount : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Chisel_filters.scala 19:24]
    reg outCount : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Chisel_filters.scala 20:25]
    reg filterOutput : UInt<16>, clock with :
      reset => (reset, UInt<16>("h0")) @[Chisel_filters.scala 22:29]
    reg prev_signal : SInt<16>, clock with :
      reset => (reset, asSInt(UInt<16>("h0"))) @[Chisel_filters.scala 23:28]
    reg outActive : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Chisel_filters.scala 24:26]
    reg filtersel : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Chisel_filters.scala 26:26]
    reg start : UInt<1>, clock with :
      reset => (reset, UInt<1>("h1")) @[Chisel_filters.scala 27:22]
    io.uio_out <= UInt<1>("h0") @[Chisel_filters.scala 28:14]
    io.uio_oe <= UInt<1>("h0") @[Chisel_filters.scala 29:14]
    io.uo_out <= UInt<1>("h0") @[Chisel_filters.scala 30:12]
    when start : @[Chisel_filters.scala 37:12]
      node _filtersel_T = bits(io.ui_in, 1, 1) @[Chisel_filters.scala 38:24]
      filtersel <= _filtersel_T @[Chisel_filters.scala 38:13]
      start <= UInt<1>("h0") @[Chisel_filters.scala 39:9]
    node _nextShift_T = bits(inShift, 14, 0) @[Chisel_filters.scala 55:28]
    node _nextShift_T_1 = bits(io.ui_in, 0, 0) @[Chisel_filters.scala 55:45]
    node nextShift = cat(_nextShift_T, _nextShift_T_1) @[Cat.scala 33:92]
    inShift <= nextShift @[Chisel_filters.scala 56:9]
    node numComplete = eq(inCount, UInt<4>("hf")) @[Chisel_filters.scala 59:28]
    node _T = asSInt(nextShift) @[Chisel_filters.scala 60:44]
    node _delta_T = sub(_T, prev_signal) @[Chisel_filters.scala 47:17]
    node _delta_T_1 = tail(_delta_T, 1) @[Chisel_filters.scala 47:17]
    node delta = asSInt(_delta_T_1) @[Chisel_filters.scala 47:17]
    node err = shr(delta, 6) @[Chisel_filters.scala 48:21]
    node _lowpass_T = add(prev_signal, err) @[Chisel_filters.scala 49:23]
    node _lowpass_T_1 = tail(_lowpass_T, 1) @[Chisel_filters.scala 49:23]
    node lowpass = asSInt(_lowpass_T_1) @[Chisel_filters.scala 49:23]
    node _highpass_T = sub(_T, lowpass) @[Chisel_filters.scala 50:20]
    node _highpass_T_1 = tail(_highpass_T, 1) @[Chisel_filters.scala 50:20]
    node highpass = asSInt(_highpass_T_1) @[Chisel_filters.scala 50:20]
    wire calculation : UInt<16> @[Chisel_filters.scala 62:23]
    node _T_1 = eq(filtersel, UInt<1>("h1")) @[Chisel_filters.scala 64:16]
    when _T_1 : @[Chisel_filters.scala 64:24]
      node _calculation_T = asUInt(lowpass) @[Chisel_filters.scala 65:26]
      calculation <= _calculation_T @[Chisel_filters.scala 65:15]
    else :
      node _calculation_T_1 = asUInt(highpass) @[Chisel_filters.scala 67:27]
      calculation <= _calculation_T_1 @[Chisel_filters.scala 67:15]
    when numComplete : @[Chisel_filters.scala 71:18]
      inCount <= UInt<1>("h0") @[Chisel_filters.scala 72:11]
      inShift <= UInt<1>("h0") @[Chisel_filters.scala 73:11]
    else :
      node _inCount_T = add(inCount, UInt<1>("h1")) @[Chisel_filters.scala 75:22]
      node _inCount_T_1 = tail(_inCount_T, 1) @[Chisel_filters.scala 75:22]
      inCount <= _inCount_T_1 @[Chisel_filters.scala 75:11]
    when numComplete : @[Chisel_filters.scala 78:18]
      node _io_uo_out_T = bits(calculation, 15, 15) @[Chisel_filters.scala 79:42]
      node _io_uo_out_T_1 = cat(UInt<7>("h0"), _io_uo_out_T) @[Cat.scala 33:92]
      io.uo_out <= _io_uo_out_T_1 @[Chisel_filters.scala 79:14]
      node _filterOutput_T = bits(calculation, 14, 0) @[Chisel_filters.scala 80:35]
      node _filterOutput_T_1 = cat(_filterOutput_T, UInt<1>("h0")) @[Cat.scala 33:92]
      filterOutput <= _filterOutput_T_1 @[Chisel_filters.scala 80:17]
      outCount <= UInt<1>("h1") @[Chisel_filters.scala 81:14]
      outActive <= UInt<1>("h1") @[Chisel_filters.scala 82:14]
      prev_signal <= lowpass @[Chisel_filters.scala 83:16]
    else :
      when outActive : @[Chisel_filters.scala 85:22]
        node _io_uo_out_T_2 = bits(filterOutput, 15, 15) @[Chisel_filters.scala 86:42]
        node _io_uo_out_T_3 = cat(UInt<7>("h0"), _io_uo_out_T_2) @[Cat.scala 33:92]
        io.uo_out <= _io_uo_out_T_3 @[Chisel_filters.scala 86:13]
        node _filterOutput_T_2 = bits(filterOutput, 14, 0) @[Chisel_filters.scala 87:35]
        node _filterOutput_T_3 = cat(_filterOutput_T_2, UInt<1>("h0")) @[Cat.scala 33:92]
        filterOutput <= _filterOutput_T_3 @[Chisel_filters.scala 87:16]
        node _T_2 = eq(outCount, UInt<4>("hf")) @[Chisel_filters.scala 88:17]
        when _T_2 : @[Chisel_filters.scala 88:27]
          outActive <= UInt<1>("h0") @[Chisel_filters.scala 89:15]
          outCount <= UInt<1>("h0") @[Chisel_filters.scala 90:14]
        else :
          node _outCount_T = add(outCount, UInt<1>("h1")) @[Chisel_filters.scala 92:26]
          node _outCount_T_1 = tail(_outCount_T, 1) @[Chisel_filters.scala 92:26]
          outCount <= _outCount_T_1 @[Chisel_filters.scala 92:14]


