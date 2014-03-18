program_name='huddleControlPortListener'


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK;
#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK;


define_variable

volatile dev dvIoPorts[1];


#include 'amx-controlports-api';
#include 'amx-controlports-listener';


define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcBtn.device && ioChanCde == dcBtn.channel)
	{
		handlePushbuttonEvent(true);
	}
}

define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcBtn.device && ioChanCde == dcBtn.channel)
	{
		handlePushbuttonEvent(false);
	}
}


define_event

data_event[dcBtn.device]
{
	online:
	{
		amxIoSetInputState(dcBtn.device, dcBtn.channel, IO_ACTIVE_STATE_LOW);
		amxIoSetInputState(dcBtnFb.device, dcBtnFb.channel, IO_ACTIVE_STATE_LOW);
	}
}


define_start

dvIoPorts[1] = dcBtn.DEVICE;
set_length_array(dvIoPorts, 1);

rebuild_event();
