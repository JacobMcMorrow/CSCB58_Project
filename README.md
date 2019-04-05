# De2Drums

## Overview

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
