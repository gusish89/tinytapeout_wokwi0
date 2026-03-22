<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The project processes a mono WAV audio signal sampled at 44.1 kHz. It receives the audio samples and passes them through either a low-pass or a high-pass filter, producing a filtered output signal.

## How to test
Provide the input audio stream one bit at a time on pin 0. Once the first 16-bit sample has been received, the design starts producing the corresponding filtered output. This means there is an initial delay of 15 clock cycles before valid output appears.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
