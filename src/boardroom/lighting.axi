program_name='lighting'

#include 'amx-device-control'

define_device

/*
 * --------------------
 * CBus devices
 *
 * Programmer needs to declare these devices in the main code
 *  - device ID's can be different
 * --------------------
 */

//dvLightingSystem = 0:3:0 // This device should be used as the physical device by the COMM module

//vdvLightingSystem = 41003:1:0  // The COMM module should use this as its duet device


/*
 * --------------------
 * Lighting constants
 * --------------------
 */

define_constant

// lighting levels by percentage 
INTEGER LIGHTING_LEVEL_0_PERCENT    = 0
INTEGER LIGHTING_LEVEL_10_PERCENT   = 25
INTEGER LIGHTING_LEVEL_20_PERCENT   = 51
INTEGER LIGHTING_LEVEL_30_PERCENT   = 76
INTEGER LIGHTING_LEVEL_40_PERCENT   = 102
INTEGER LIGHTING_LEVEL_50_PERCENT   = 127
INTEGER LIGHTING_LEVEL_60_PERCENT   = 153
INTEGER LIGHTING_LEVEL_70_PERCENT   = 178
INTEGER LIGHTING_LEVEL_80_PERCENT   = 204
INTEGER LIGHTING_LEVEL_90_PERCENT   = 230
INTEGER LIGHTING_LEVEL_100_PERCENT  = 255

VOLATILE CHAR CBusAddr[20][20] = 
{
    '00:38:21',   // Lighting group 1 
    '00:38:1F',   // Lighting group 2
    '00:CA:03:01', // Trigger group 3, action 1 -- preset    
    '00:CA:04:02'  // Trigger group 4, action 2 -- preset      	 	
}

char cLightAddressBoardroom[]		= '00:38:00'

/*
 * --------------------
 * Lighting variables level codes
 * --------------------
 */

define_variable

// virtual device array to pass to module
dev vdvLights[] = {vdvLightingSystem}

#warn '@PROGRAMMERS NOTE: lighting - Need to edit the IP address for the Lighting System'
// ip address of Lighting interface
char strIPAddressLightingSystem[15] = '192.168.4.21'


char cLightStatus[255]

// Dynalite Lighting System Module
//define_module 'Clipsal_CBus_Comm_dr1_0_0' comm(vdvLightingSystem, dvLightingSystem)

define_module 'CBus_Comm' mCbusNetLinx (vdvLightingSystem, dvLightingSystem, cLightStatus)


/*
 * --------------------
 * Lighting Functions
 * --------------------
 */


define_function lightsPassThroughData (char strData[])
{
	sendCommand (vdvLightingSystem,"'PASSTHRU-',strData")
}

define_function lightsSetLevelAll(integer lightingLevel)
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMLEVEL-255:1:ALL,',itoa(lightingLevel)")
}

define_function lightsSetLevel (char strLightAddress[], integer lightingLevel)
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel)")
}

define_function lightsSetLevelWithFade (char strLightAddress[], integer lightingLevel, integer fadeRateInSeconds)
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel),',',itoa(fadeRateInSeconds)")
}

define_function lightsToggle (char strLightAddress[])
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',TOGGLE'")
}

define_function lightsOn (char strLightAddress[])
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',ON'")
}

define_function lightsOff (char strLightAddress[])
{
	sendCommand (vdvLightingSystem,"'LIGHTSYSTEMSTATE-',strLightAddress,',OFF'")
}

define_function lightsEnableRampUp (char strLightAddress[])
{
	sendCommand (vdvLightingSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',UP'")
}

define_function lightsEnableRampDown (char strLightAddress[])
{
	sendCommand (vdvLightingSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',DOWN'")
}

define_function lightsDisableRamp (char strLightAddress[])
{
	sendCommand (vdvLightingSystem, "'LIGHTSYSTEMRAMP-',strLightAddress,',STOP'")
}


/*
 * --------------------
 * Events
 * --------------------
 */

define_event

data_event[vdvLightingSystem]
{
	online:
	{
		// for Duet module
		/*sendCommand (vdvLightingSystem,"'PROPERTY-IP_Address,',strIPAddressLightingSystem")
		sendCommand (vdvLightingSystem, "'PROPERTY-PORT,10001'")
		sendCommand (vdvLightingSystem, "'REINIT'")*/
		
		// for NetLinx module
		sendCommand (vdvLightingSystem, "'PROPERTY-IPADDRESS,',strIPAddressLightingSystem")
		sendCommand (vdvLightingSystem, "'PROPERTY-IPPORT,10001'")
		WAIT 50
			sendCommand (vdvLightingSystem, "'PROPERTY-SYNCH,3'")
	}
}
