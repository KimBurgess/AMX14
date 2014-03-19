module_name='huddleController'(dev vdvRms, dev vdvDisplay,
		dev dvEnzo, dev dvRx, dev dvTx, devchan dcBtn, devchan dcBtnFb)


#include 'logger';
#include 'string';
#include 'common';
#include 'util';
#include 'amx-device-control';
#include 'amx-controlports-api';
#include 'amx-controlports-control';
#include 'amx-enzo-api';
#include 'amx-enzo-control';
#include 'amx-modero-api';
#include 'amx-modero-control';
#include 'huddleDisplayManager';
#include 'huddleSourceManager';
#include 'huddleOSDManager';
#include 'huddleDXLinkListener';
#include 'huddleControlPortsListener';


/**
 * Gets a unique instance id for this module.
 */
define_function char[8] getInstanceId()
{
	stack_var long id;

	id = 1;
	id = id * 31 + vdvRms.number;
	id = id * 31 + vdvDisplay.number;
	id = id * 31 + dvEnzo.number;
	id = id * 31 + dvRx.number;
	id = id * 31 + dvTx.number;
	id = id * 31 + dcBtn.device.number;
	id = id * 31 + dcBtn.device.number;

	return itohex(id);
}

/**
 * Sets the button feedback to display for the appropriate system state.
 */
define_function updateButtonFeedbackState()
{
	if ((getAvailableSourceCount() > 1) || (getActiveSource() != SOURCE_ENZO))
	{
		log(AMX_DEBUG, 'Enabling button feedback');
		channelOn(dcBtnFb.device, dcBtnFb.channel);
	}
	else
	{
		log(AMX_DEBUG, 'Disabling button feedback');
		channelOff(dcBtnFb.device, dcBtnFb.channel);
	}
}

/**
 * Handle a change to the pushbutton state.
 */
define_function handlePushbuttonEvent(char isPushed)
{
	log(AMX_DEBUG, "'pushbutton event [', bool_to_string(isPushed), ']'");

	if (isPushed)
	{
		cancel_wait 'signal returned';
	}
	else
	{
		cycleActiveSource();
	}
}

/**
 * Handle an update to the detected signal status of one of our system sources.
 */
define_function handleSignalStatusEvent(char sourceId, char signalStatus[])
{
	log(AMX_DEBUG, "'Signal event for ', getSourceName(sourceId), ' [',
			signalStatus, ']'");

	setSourceAvailable(sourceId, signalStatus == DXLINK_SIGNAL_STATUS_VALID_SIGNAL);

	// If signal drops from the active source (e.g. laptop is unplugged or goes
	// to sleep throw up an alert using Enzo).
	if (signalStatus == DXLINK_SIGNAL_STATUS_NO_SIGNAL &&
			sourceId == getActiveSource())
	{
		log(AMX_INFO, 'Signal lost from active source');

		showOSD('disconnected');

		wait_until (isSourceAvailable(sourceId)) 'signal returned'
		{
			log(AMX_DEBUG, 'Signal to active source returned. Switching back to display');
			hideOSD();
		}
	}

	updateButtonFeedbackState();
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

setLogPrefix("'huddleController[', getInstanceId(), ']'");
