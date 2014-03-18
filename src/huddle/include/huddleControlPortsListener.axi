program_name='huddleControlPortListener'


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK;
#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK;


define_variable

volatile dev dvIoPorts[1];


#include 'amx-controlports-api';
#include 'amx-controlports-listener';


define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel)
	{
		handlePushbuttonEvent(true);
	}
}

define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel)
	{
		handlePushbuttonEvent(false);
	}
}


define_event

data_event[dcButton.device]
{
	online:
	{
		amxIoSetInputState(dcButton.device, dcButton.channel, IO_ACTIVE_STATE_LOW);
		amxIoSetInputState(dcButtonFb.device, dcButtonFb.channel, IO_ACTIVE_STATE_LOW);
	}
}


define_start

dvIoPorts[1] = dcButton.DEVICE;
set_length_array(dvIoPorts, 1);

rebuild_event();
