module_name='huddleController'(dev vdvComm, dev vdvRMS, dev vdvDisplay,
		dev dvEnzo, dev dvRXMonitor, dev dvTXTable, devchan dcButton,
		devchan dcButtonFb)


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
#include 'huddleSourceManager';
#include 'huddleDXLinkListener';
#include 'huddleControlPortsListener';


/**
 * Sets the button feedback to display for the appropriate system state.
 */
define_function updateButtonFeedbackState()
{
	if ((getAvailableSourceCount() > 1) || (getActiveSource() != SOURCE_ENZO))
	{
		log(AMX_DEBUG, 'Enabling button feedback');
		channelOn(dcButtonFb.device, dcButtonFb.channel);
	}
	else
	{
		log(AMX_DEBUG, 'Disabling button feedback');
		channelOff(dcButtonFb.device, dcButtonFb.channel);
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

		enzoAlert(dvEnzo,
				'Please reconnect your device to continue presenting, or, use the push-button to select another source.',
				ENZO_ALERT_TYPE_INFORMATION,
				'Device Disconnected',
				false,
				15);
		setDisplaySource(SOURCE_ENZO);

		wait_until (isSourceAvailable(sourceId)) 'signal returned'
		{
			log(AMX_DEBUG, 'Signal to active source returned. Switching back to display');
			setDisplaySource(getActiveSource());
			enzoAlertClose(dvEnzo);
		}
	}

	updateButtonFeedbackState();
}


define_event

data_event[dvTxTable]
{
	online:
	{
		dxlinkDisableTxVideoInputAutoSelect(data.device);
	}
}


define_start

setLogPrefix("'huddleController[', itoa(vdvComm.NUMBER), ']'");
