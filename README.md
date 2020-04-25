# What?

These files contain the work I've done so far to open up the 12587603 operating system for reverse engineering.

The .idc script can be loaded into IDA Pro to booststrap your own efforts.

If you don't have IDA Pro, you can use the .asm file.

There's also a 'template' XDF that might be helpful if you want to create new objects in an existing XDF. It will not be very useful to end users / tuners because there is no information yet to convert the ROM values to real-world units. 

When Ghidra has CPU32 support (especially the table-lookup opcodes) I intend to port everything to a format that Ghidra supports.

# Why?

To pave the way to fun stuff like 2-step rev limiteres, flat-foot shifting, forced induction, rev-matched downshifting, and whatever else people dream up.

# Why 12587603?

Initially, because this is a "universal donor" P59 / 1mb operating system. It is available in every combination of transmission type and throttle type, so it should be usable in any GM vehicle or swap.

More recently, because an anonymous hero sent a table of ROM addresses and labels for what appears to be everything in the calibration segment. This should speed things up quite a bit.

# How ?

To help bootstrap this, I wrote a script that turns an XDF file into IDC, for import into IDA.

Then I wrote a script that uses the PID numbers and function pointers in the firmware to label the functions that handle PID requests - this allows you to label RAM addresses for many PID-related variables with some confidence.

Then I got the aforementioned dumpster-dive data and wrote a script to turn it into IDC as well, to label the constants in the calibration segment.

All of the raw data and custom scripts are in the Resources subdirectory.
