# De2Drums

## Overview
De2Drums is a sample based drum machine programmed in verilog for the DE2-115 FPGA board. De2Drums includes an eight step sequencer, four drum samples, display through VGA, and control from board switches and keys.

## Instructions
Note: Before programming the board, you may want to flip on SW17 (far left switch) or it will produce a static tone.
      This is a feature of the audio controller (not a bug) =)
      
After successfully programming the board the monitor should display a smiley face, denoting that it is ready. HEX0 and HEX1
should both be zero, this is the neutral state. Press KEY2 once and HEX0 should display a 1.

1. Loading BPM
When HEX0 is displaying a 1, you are now in the BPM loading state. Using SW0-SW7, select what BPM you want the drum machine
to play at (based on binary counting with SW7 as most significant bit). BPM should be a value between 1-255, if you do select
0, it will default to 60 BPM. When you are ready to set your BPM, hit KEY2 and HEX0 should now display 2.

2. Loading Instruments
When HEX0 is displaying a 2, 3, 4, or 5, you are now in the instrument loading state. SW0-7 represent the beats at which you
want each instrument to play. You will load the bits for each instrument one at a time. For example, having SW0, 2, 4, 6 set
to 1 and everything else set to 0 means that this instrument will play a sound on every quarter note. Conversely, having
SW1, 3, 5, 7 set to 1 and everything else set to 0 means that this instrument will play a sound on every eighth note. Press
KEY2 to load the bits into each instrument and HEX0 will increment by 1. Continue until all 4 instruments are loaded. When all
4 instruments are loaded, it will start playing.

3. Playing
When the drums are playing, HEX1 will increment and cycle from 1-8. This denotes the beat at which the instruments are playing.
In addition, the display should have have a 4x8 array of squares. Each row represents each instruments (instrument 1 at the top)
and each square from left to right represent each beat. The moving (red/blue) colour bar represents what beat is currently
playing. Here are what each colour represent.

White - the instrument has this bit set to 0 (it will not play when we hit this timing)

Green - the instrument has this bit set to 1 (it will play only when we hit this timing)

Blue - we are currently on this beat but the instrument is not playing

Red - we are currently on this beat and the instrument is playing

4. Resetting (Optional)
If at any time you wish to reset (during any stage including the loading states), simply press KEY1. This will revert 
everything back to the initial state. The screen should also reset and display the smiley once it is ready.

## Module Explanation
### De2Drums.v
The De2Drums.v file is the top most level of the drum machine program and is comprised of the De2Drums module which takes all of
the used DE2-115 inputs and sends to the required DE2-115 outputs. The role of De2Drums is to encapsulate the modules that form 
the function of the drum machine, and route signals from each of them to where they need to go. We also instantiate a sample 
module for each of the instruments we want to include as playable.

### Control.v
Control.v contains the control module which is tasked with generating load signals, play signals, and maintaining a loop for
timing during play back. The control module works off of two clocks, the first of which is the DE2-115 board's 50MHz clock, and 
the second of which is the slow clock generated inside of our project. Loading states for instruments require the faster clock, 
where as the slow clock is the foundation of our variable bpm setting and essential to ensure correct timing of the play 
signals. Instrument loading and instrument timing are both powered by two state tables, but in the case of the first instrument
table, we loop until we no longer have a play signal.

### DataPath.v
The DataPath.v file is composed entirely of the datapath module, whose responsibility is to accept user's bpm input, selection 
of timing for instruments, and when to send signals to other modules during playback. The datapath module is centered around two
always blocks. The first of which handles input selection, and the second sends instrument cue signals during play back.

### audio.v
The audio.v file contains the audio module, which is where De2Drums interfaces with the audio controller and audio video
configuration modules. The goal of the module is to instantiate all necessary inputs and outputs, be they built into the board,
or exist exclusively with in our project, to get our audio signal to the DE2-115 board’s line output. For example, anything
written in all caps such as AUD_ADCDAT (audio analog to digital converter data) is  built into the board, where anything else
exists with in the project.

The mix_down input is our audio signal coming out of the mixer module, and is sent to the audio controller module directly. The 
wires audio_in_available, read_audio_in, audio_out_allowed, write_audio_out are all for permission signals to play or receive 
audio. These permissions are combined and sent to the audio controller module.

### adder_zero.v, adder_one.v, and full_adder.v
The adder_zero.v file contains the adder_zero module, and is the first of the adder_components of our mixer module. The goal of 
adder_zero is to take in two 8-bit audio signals and add them together to get a 9-bit audio signal that contains both sounds.
This is accomplished by a series of full adders summing the audio signals bit by bit with the final carry over bit becoming the
most significant bit of the new signal.

The adder_one.v file contains the adder_one module which works in much the same way as the adder_zero module. However, being the
second stage of our mixer module, adder_one is combining two 9-bit signals to get a new ten bit signal.

Our full_adder.v file contains the full_adder module used by both adder_zero and adder_one modules. It is a typical 
implementation of a full adder, where on the positive edge of the DE2-115 board’s 50MHz clock, the carry over bit is set to the
result of OR-ing together the results of a AND b, a AND carry over in, and b AND carry over in. Also on the positive clock edge,
sum is set to the result of XOR-ing a, b, and carry over in. Where a and b are input one and two respectively.

### counter.v, bpm.v, and sample_clock.v
counter.v is comprised of the counter module which counts up from 0 to 8191 on a clock signal of 48KHz to gather the addresses
which correspond to lines of data in our ROM files. The counter module comes with conditions however, it starts counting when it 
receives a signal that an instrument is to be played, restarting if the count is interrupted by an other signal. If counter 
reaches the maximum, it stops counting and sets its value to 0. Finally if play signal stops, it stops counting and resets its
value to 0.

Our bpm.v file holds the bpm module, who performs the action of a clock divider based around variable bpm input choices. The 
module takes in from the DE2-115 board's switches fed through other modules, and then counts until it reaches the appropriate 
values. Further, if no value is provided, it counts from a default. The bpm module also has a custom slower that always ticks 
based on variable bpm selected.

The sample_clock.v file contains the sample_clock module, which just performs one action. The module is a clock divider to take 
the DE2-115 board's 50MHz clock down to a 48KHz clock to match the audio ROM's sample rates.

### mixer.v
The mixer.v file contains the mixer module which combines the audio signals from all of our samples into a single signal to be 
sent to the audio controller. The combining of signals is accomplished through an array of cascading adders where at each stage
the size of signals being combined increases by one bit. Each adder combines a pair of signals into one signal, so for our four 
samples we require two stages where eight samples would require three stages, and so on. However, audio output for the DE2-115 
board expects a 32-bit signal where ours is onl 10 -bit after the adders. So in a final step we concatenate enough zeroes to the
end of our resulting signal to bring it up to a play back level that is audible, but does not distort when all four samples are 
played at once.

### sample.v
sample.v contains the sample module whole purpose is to retrieve the audio information of the audio ROM files. This is 
accomplished in three steps. The first of which is to instantiate a counter module which returns numbers in order that 
correspond to lines of information in our ROMs. These addresses are retrieved at the sample rate of our audio, 48KHz. Second, we 
instantiate the ROM modules for each of our samples, and read from them the information on the line matching our current 
address. Each sample has a dedicated wire which they pass their data to the third step where in we set to output the sample’s 
data that corresponds to the select value provided.

### instrument.hex, and instrument_rom.v
The audio sample ROMs are located in the Rom folder, and each of which follow the same format, so we will cover them in general.
The ROMs come in two parts. The first of which is are the <instrument>.hex files, each of which are Intel formatted text files 
which contain the data from 8-bit down sampled .wav files and processed by Quartus to create files to read them. The said files
are the <instrument>_rom.v files which are automatically generated by Quartus, and when the module found within is given a 
numeric value address which corresponds to a line in the <instrument>.hex file and the DE2-115 board's clock returns the 
information for the sample.

### hex_display.v
hex_display.v contains a modules which decodes 4-bit input into 7 segment hex display values.

### vga_signals.v
The vga_signals.v contains the vga_signals module whose goal is to control what is shown on the monitor, specifically to draw 
the wait screen when no sound is playing, and the display grid with animation when sound is playing. The module is centered 
around two state machines that draw each square with 4x4 pixels based on a 4-bit counter for the first machine, and the second 
determines what output is generated based on which square is being drawn. Further, the module includes an extensive set of 
checks for square number, timing, instruments selected, etc.
