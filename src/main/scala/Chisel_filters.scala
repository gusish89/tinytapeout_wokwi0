import chisel3._
import chisel3.util._
/**
 * Example design in Chisel.
 * A redesign of the Tiny Tapeout example.
 */

class ChiselFilters() extends Module {
  val io = IO(new Bundle {
    val ui_in = Input(UInt(8.W))      // Dedicated inputs 
    val uo_out = Output(UInt(8.W))    // Dedicated outputs 
    val uio_in = Input(UInt(8.W))     // IOs: Input path 
    val uio_out = Output(UInt(8.W))   // IOs: Output path
    val uio_oe = Output(UInt(8.W))    // IOs: Enable path (active high: 0=input, 1=output)
  })


  val inShift = RegInit(0.U(16.W)) // Register to hold the 16-bit input signal
  val inCount = RegInit(0.U(4.W)) // Counter to keep track of the number of bits received
  val outCount = RegInit(0.U(4.W)) // Counter to keep track of the number of bits outputted
  
  val filterOutput = RegInit(0.U(16.W)) // Register to hold the output of the filter after processing the input signal
  val prev_signal = RegInit(0.S(16.W)) // Register to hold the previous signal for the filter function
  val outActive = RegInit(false.B) // Flag to indicate when we are actively outputting bits from the filter output

  val filtersel = RegInit(0.U(1.W)) // Register to select between lowpass and highpass output, this is just an example and can be changed as needed
  val start = RegInit(true.B) // Flag to indicate when we have started receiving bits, this can be used to control when the filter starts processing the input signal
  io.uio_out := 0.U
  io.uio_oe  := 0.U
  io.uo_out:= 0.U

  val unusedInputs = io.ui_in(7, 2).orR | io.uio_in.orR
  dontTouch(unusedInputs)

  // io.uio_oe := 0.U
  // io.uo_out  := 0.U
  // io.uio_out := 0.U


when(start){
  filtersel := io.ui_in(1) // Select which filter to apply at start, and cannot be changed midway 
  start := false.B // Clear the start flag after the first cycle, this will allow the filter to start processing the input signal on the next cycles
}



def Filter(x: SInt, prev: SInt): (SInt, SInt) = {
  val delta = x - prev
  val err   = delta >> 6
  val lowpass  = prev + err
  val highpass = x - lowpass
  (lowpass, highpass)
}

/// Shifting in bits from input 
val nextShift = Cat(inShift(14, 0), io.ui_in(0)) // Shift in the new bit from the dedicated input into a 16-bit register
inShift := nextShift // Update the shift register with the new value, this will build up the 16-bit word over time as we receive bits from


val numComplete = (inCount === 15.U) // Check if we have received a complete 16-bit word
val (lowpass, highpass) = Filter(nextShift.asSInt, prev_signal)

val calculation = Wire(UInt(16.W))

when(filtersel === 1.U){ // Use the second bit of the input to select between lowpass and highpass output, this is just an example and can be changed as needed
  calculation := lowpass.asUInt
}.otherwise {
  calculation := highpass.asUInt
}


when(numComplete){
  inCount := 0.U // Reset the counter for the next word
  inShift := 0.U // Clear the shift register for the next word
}.otherwise {
  inCount := inCount + 1.U // Increment the counter to receive the next bit
}

when(numComplete){
   io.uo_out := Cat(0.U(7.W), calculation(15)) // Output as soon we have recived the full 16bits 
   filterOutput := Cat(calculation(14,0), 0.U) // Shift next bit up so its ready to be outputted when it arrvies 
   outCount  := 1.U // Start counting the output bits
   outActive := true.B
   prev_signal := lowpass // Update the previous signal with the current input word for the next iteration of the filter

}.elsewhen(outActive){
  io.uo_out := Cat(0.U(7.W), filterOutput(15)) // Output the most significant bit of the filter output to the dedicated output, we can change this to output the lowpass or highpass result as needed
  filterOutput := Cat(filterOutput(14,0), 0.U)
  when(outCount === 15.U) {
    outActive := false.B // Reset the output active flag for the next word
    outCount := 0.U // Reset the output counter for the next word
  }.otherwise {
    outCount := outCount + 1.U // Increment the output counter to shift out the next bit

  }

}

  }

object ChiselFilters extends App {
  emitVerilog(new ChiselFilters(), Array("--target-dir", "src"))
}












