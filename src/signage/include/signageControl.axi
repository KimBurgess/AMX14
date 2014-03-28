program_name='signageControl'


#include 'amx-is-xpress-control.axi';


define_constant

char ipAddressXpressPlayerUpper[50]        		= '192.168.4.128'
char ipAddressXpressPlayerLower[50]        		= '192.168.4.129'

char xpressPlayerSideBarVariableNameToUpdate[100] 	= 'menu'
char xpressPlayerVariableValueQr[100]   		= 'qr_code'
char xpressPlayerVariableValueArrows[100]   		= 'way_finding'

char xpressPlayerCTOvariableNameToUpdate[100]			= 'arrow1'
char xpressPlayerUIvariableNameToUpdate[100]			= 'arrow2'
char xpressPlayerRMSVariableNameToUpdate[100]			= 'arrow3'
char xpressPlayerContentDeliveryVariableNameToUpdate[100]	= 'arrow4'
char xpressPlayerHuddleVariableNameToUpdate[100]		= 'arrow5'

char xpressPlayerGroupOrangeColor[100]	= 'rgb(240,83,50)'
char xpressPlayerGroupGreenColor[100]	= 'rgb(0,139,43)'
char xpressPlayerGroupPurpleColor[100]	= 'rgb(130,41,128)'
char xpressPlayerGroupYellowColor[100]	= 'rgb(222,203,23)'
char xpressPlayerGroupBlueColor[100]	= 'rgb(92,75,207)'
char xpressPlayerGroupNone[100]		= 'None'

char locationCTOid[50] 			= 'cto'
char locationUIid[50]			= 'ui'
char locationRMSid[50]			= 'rms'
char locationContentDeliveryid[50] 	= 'content_delivery'
char locationHuddlesid[50] 		= 'huddles'

char groupColorOrangeid[50] = 'Orange'
char groupColorGreenid[50] = 'Green'
char groupColorPurpleid[50] = 'Purple'
char groupColorYellowid[50] = 'Yellow'
char groupColorBlueid[50] = 'Blue'
char groupColorNoneid[50] = 'None'

define_variable

persistent char ipAddressXpressPlayerUpper[] = '192.168.4.128';
persistent char ipAddressXpressPlayerLower[] = '192.168.4.129';


define_function upadetArrowColor(char location[], char group[])
{

    STACK_VAR char varLocationToUpdate[50]
    STACK_VAR char varNewColor[50]
    SWITCH (location)
    {
	case locationCTOid:
	{
	    varLocationToUpdate = xpressPlayerCTOvariableNameToUpdate
	}
	case locationUIid:
	{
	    varLocationToUpdate = xpressPlayerUIvariableNameToUpdate
	}
	case locationRMSid:
	{
	    varLocationToUpdate = xpressPlayerRMSVariableNameToUpdate
	}
	case locationContentDeliveryid:
	{
	    varLocationToUpdate = xpressPlayerContentDeliveryVariableNameToUpdate
	}
	case locationHuddlesid:
	{
	    varLocationToUpdate = xpressPlayerHuddleVariableNameToUpdate
	}
    }
    SWITCH (group)
    {
	case groupColorOrangeid:
	{
	    varNewColor = xpressPlayerGroupOrangeColor
	}
	case groupColorGreenid:
	{
	    varNewColor = xpressPlayerGroupGreenColor
	}
	case groupColorPurpleid:
	{
	    varNewColor = xpressPlayerGroupPurpleColor
	}
	case groupColorYellowid:
	{
	    varNewColor = xpressPlayerGroupYellowColor
	}
	case groupColorBlueid:
	{
	    varNewColor = xpressPlayerGroupBlueColor
	}
	case groupColorNoneid:
	{
	    varNewColor = xpressPlayerGroupNone
	}
    }
    SEND_STRING 0, "varLocationToUpdate,' ',varNewColor"
    xpressUpdateVariable (dvUpperPlayer, ipAddressXpressPlayerUpper, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, varLocationToUpdate, varNewColor)
    xpressUpdateVariable (dvLowerPlayer, ipAddressXpressPlayerLower, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, varLocationToUpdate, varNewColor)
}

define_function activateQRcode()
{
    xpressUpdateVariable (dvUpperPlayer, ipAddressXpressPlayerUpper, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerSideBarVariableNameToUpdate, xpressPlayerVariableValueQr)
    xpressUpdateVariable (dvLowerPlayer, ipAddressXpressPlayerLower, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerSideBarVariableNameToUpdate, xpressPlayerVariableValueQr)

}

define_function activateWayFinding()
{
    xpressUpdateVariable (dvUpperPlayer, ipAddressXpressPlayerUpper, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerSideBarVariableNameToUpdate, xpressPlayerVariableValueArrows)
    xpressUpdateVariable (dvLowerPlayer, ipAddressXpressPlayerLower, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerSideBarVariableNameToUpdate, xpressPlayerVariableValueArrows)

}
