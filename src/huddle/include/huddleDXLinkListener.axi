PROGRAM_NAME='huddleDXLinkListener'


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK;
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK;


define_variable

volatile dev dvDxlinkTxDigitalVideoInPorts[1];
volatile dev dvDxlinkTxAnalogVidInPorts[1];


#include 'amx-dxlink-api';
#include 'amx-dxlink-listener';


define_function dxlinkNotifyTxVideoInputStatusAnalog (dev dxlinkTxAnalogVideoInput, char signalStatus[])
{
	if (dxlinkTxAnalogVideoInput == dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_ANALOG:dvTx.SYSTEM)
	{
		local_var char hasSignal;

		hasSignal = signalStatus == DXLINK_SIGNAL_STATUS_VALID_SIGNAL;

		// When some devices are plugged in / unplugged it can cause a couple of
		// signal status events in quick succession. This will buffer this and
		// ensure we're not attempting to handle these while the device
		// stabalises.
		wait 8 'Analog signal status buffer'
		{
			handleSignalStatusEvent(SOURCE_VGA, hasSignal);
		}
	}
}

define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	if (dxlinkTxDigitalVideoInput == dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_DIGITAL:dvTx.SYSTEM)
	{
		local_var char hasSignal;

		hasSignal = signalStatus == DXLINK_SIGNAL_STATUS_VALID_SIGNAL;

		// As above, this will help ensure we're not attempting to deal with
		// signal state changes as attached devices freak out during connect /
		// disconnect.
		wait 8 'Digital signal status buffer'
		{
			handleSignalStatusEvent(SOURCE_HDMI, hasSignal);
		}
	}
}


define_event

data_event[dvTx]
{

	online:
	{
		dxlinkDisableTxVideoInputAutoSelect(data.device);
	}

}


define_start

dvDxlinkTxDigitalVideoInPorts[1] = dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_DIGITAL:dvTx.SYSTEM;
set_length_array(dvDxlinkTxDigitalVideoInPorts, 1);

dvDxlinkTxAnalogVidInPorts[1] = dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_ANALOG:dvTx.SYSTEM;
set_length_array(dvDxlinkTxAnalogVidInPorts, 1);

rebuild_event();
