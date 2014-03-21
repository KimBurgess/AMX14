program_name='sony-evihd7v'

#if_not_defined __SONY_EVIHD7V__
#define __SONY_EVIHD7V__


#include 'common'
#include 'amx-device-control'


// Comms
/*
Communication speed: 9,600 bps/38,400 bps
• Data bits : 8
• Start bit : 1
• Stop bit : 1
• Non parity
Flow control using XON/XOFF and RTS/CTS, etc., is
not supported
*/

/*
define_function sonyEvihd7v (dev cam)
{
	// 
	sendCommand (cam, "")
}
*/



define_function sonyEvihd7vEnablePower (dev cam)
{
	//8x 01 04 00 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vDisablePower (dev cam)
{
	//8x 01 04 00 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomStop (dev cam)
{
	//  8x 01 04 07 00 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomTeleStandard (dev cam)
{
	//  8x 01 04 07 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomWideStandard (dev cam)
{
	// 8x 01 04 07 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomTeleVariable (dev cam, integer speed)
{
	// 8x 01 04 07 2p FF		 p=0 (Low) to 7 (High)
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomTeleWideVariable (dev cam, integer speed)
{
	// 8x 01 04 07 3p FF		 p=0 (Low) to 7 (High)
	sendCommand (cam, "")
}

define_function sonyEvihd7vZoomDirect (dev cam)
{
	// 8x 01 04 47 0p 0q 0r 0s FF		pqrs: Zoom Position
	sendCommand (cam, "")
}

define_function sonyEvihd7vSetDZoomLimit (dev cam)
{
	// 8x 01 04 26 0p FF		p=0 (x1), 1 (x1.5), 2 (x2), 3 (x4)
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusStop (dev cam)
{
	// 8x 01 04 08 00 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusFarStandard (dev cam)
{
	//  8x 01 04 08 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusNearStandard (dev cam)
{
	//  8x 01 04 08 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFarVariable (dev cam)
{
	//  8x 01 04 08 2p FF		p=0 (Low) to 7 (High)
	sendCommand (cam, "")
}

define_function sonyEvihd7vNearVariable (dev cam)
{
	// 8x 01 04 08 3p FF		 p=0 (Low) to 7 (High)
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusDirect (dev cam)
{
	// 8x 01 04 48 0p 0q 0r 0s FF		pqrs: Focus Position
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusAuto (dev cam)
{
	// 8x 01 04 38 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusManual (dev cam)
{
	// 8x 01 04 38 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusAutoManualToggle (dev cam)
{
	// 8x 01 04 38 10 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusOnePushTriggerAf (dev cam)
{
	// 8x 01 04 18 01 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusInfinity (dev cam)
{
	// 8x 01 04 18 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vFocusNearLimit (dev cam)
{
	//  8x 01 04 28 0p 0q 0r 0s FF		pqrs: Focus Near Limit Position		*The lower 1 byte (rs) is fixed at 00.
	sendCommand (cam, "")
}

/*
 * VV: Pan speed 0 x01 (low speed) to 0 x18 (high speed)
 * WW: Tilt Speed 0 x 01 (low speed) to 0 x14 (high speed)
 * YYYY: Pan Position FA60 to 05A0 (center 0000)
 * ZZZZ: Tilt Position FE98 to 0168 (center 0000)
*/

define_function sonyEvihd7vPtzUp (dev cam)
{
	// 8x 01 06 01 VV WW 03 01 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzDown (dev cam)
{
	// 8x 01 06 01 VV WW 03 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzLeft (dev cam)
{
	// 8x 01 06 01 VV WW 01 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzRight (dev cam)
{
	// 8x 01 06 01 VV WW 02 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzUpLeft (dev cam)
{
	// 8x 01 06 01 VV WW 01 01 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzUpRight (dev cam)
{
	// 8x 01 06 01 VV WW 02 01 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzDownLeft (dev cam)
{
	// 8x 01 06 01 VV WW 01 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzDownRight (dev cam)
{
	// 8x 01 06 01 VV WW 02 02 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzStop (dev cam)
{
	// 8x 01 06 01 VV WW 03 03 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzAbsolutePosition (dev cam)
{
	// 8x 01 06 02 VV WW 0Y 0Y 0Y 0Y 0Z 0Z 0Z 0Z FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzRelativePosition (dev cam)
{
	// 8x 01 06 03 VV WW 0Y 0Y 0Y 0Y 0Z 0Z 0Z 0Z FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzHome (dev cam)
{
	//  8x 01 06 04 FF
	sendCommand (cam, "")
}

define_function sonyEvihd7vPtzReset (dev cam)
{
	// 8x 01 06 05 FF
	sendCommand (cam, "")
}






















#end_if