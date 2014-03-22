module_name='huddleController'(dev vdvRms, dev vdvDisplay,
		dev dvEnzo, dev dvRx, dev dvTx, devchan dcBtn, devchan dcBtnFb,
		dev dvTp, dev dvSchedulingTp)


// Utility includes
#include 'logger';
#include 'string';
#include 'common';
#include 'util';

// Device control libraries
#include 'amx-device-control';
#include 'amx-enzo-control';

// Rms guff
#include 'RmsApi';
#include 'RmsSchedulingApi';

// System components
#include 'huddleDisplayManager';
#include 'huddleSourceManager';
#include 'huddleEnzoContentManager';
#include 'huddleOSDManager';
#include 'huddleDXLinkListener';
#include 'huddleControlPortsListener';
#include 'huddleEnzoListener';
#include 'huddleModeroListener';
#include 'huddleRmsListener';
#include 'huddleUIManager';


define_module

'RmsDuetMonitorMonitor' mdlRmsMonitor(vdvRms, vdvDisplay, dvRx);
'RmsGenericNetLinxDeviceMonitor' mdlRmsEnzo(vdvRms, dvEnzo);
'RmsTouchPanelMonitor' mdlRmsTp(vdvRms, dvTp);
'RmsTouchPanelMonitor' mdlRmsSchedulingTp(vdvRms, dvSchedulingTp);


define_variable

volatile char sessionActive;


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
	id = id * 31 + dvTp.number;
	id = id * 31 + dvSchedulingTp.number;

	return itohex(id);
}

/**
 * Starts up the huddle space.
 */
define_function startSession()
{
	log(AMX_INFO, 'Starting huddle session');

	sessionActive = true;

	hideAuthScreen();

	refreshSourceLauncherVisibility()

	setDisplayPower(true);
	setActiveSource(SOURCE_ENZO);

	// TODO start time and check that enzo is activated / source is present
}

/**
 * End the current usage session.
 */
define_function endSession()
{
	log(AMX_INFO, 'Ending huddle session');

	sessionActive = false;

	showAuthScreen();

	setActiveSource(SOURCE_ENZO);
	enzoSessionEnd(dvEnzo);
	setDisplayPower(false);
}

define_function char isSessionActive()
{
	return sessionActive;
}

/**
 * Handle anything involved to turn on / prep the system at the start of a
 * reservation.
 */
define_function handleBookingStart(RmsEventBookingResponse booking)
{
	log(AMX_DEBUG, 'Booking starting for huddle location');
	if (!isSessionActive())
	{
		startSession();
	}
}

/**
 * System cleanup following a booking end.
 */
define_function handleBookingEnd(RmsEventBookingResponse booking)
{
	log(AMX_DEBUG, 'Booking ending for huddle location');
	if (isSessionActive())
	{
		endSession();
	}
}

/**
 * Handle an enzo login
 */
define_function handleEnzoLoginEvent()
{
	log(AMX_DEBUG, 'Enzo login detected');
}

/**
 * Handle Enzo post logout actions
 */
 define_function handleEnzoLogoutEvent()
 {
	log(AMX_DEBUG, 'Enzo logout detected');

	// TODO start timer for session end and room release
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
define_function handleSignalStatusEvent(char sourceId, char hasSignal)
{
	log(AMX_DEBUG, "'Signal event for ', getSourceName(sourceId), ' [',
			bool_to_string(hasSignal), ']'");

	setSourceAvailable(sourceId, hasSignal);

	// If signal drops from the active source (e.g. laptop is unplugged or goes
	// to sleep throw up an alert using Enzo).
	if (hasSignal == false && sourceId == getActiveSource())
	{
		log(AMX_INFO, 'Signal lost from active source');

		if (deviceIsOnline(dvTp))
		{
			showOSD('disconnect-extended');
		}
		else
		{
			showOSD('disconnected');
		}

		wait_until (isSourceAvailable(sourceId)) 'signal returned'
		{
			log(AMX_DEBUG, 'Signal to active source returned. Switching back to display');
			hideOSD();
		}
	}

	// Autoswitch to a hot plugged source if the user is sitting on the enzo
	// standby screen.
	if (getActiveSource() == SOURCE_ENZO &&
			getEnzoSessionActive() == false &&
			isSessionActive() == true &&
			hasSignal == true)
	{
		setActiveSource(sourceId);
	}

	updateButtonFeedbackState();

	setContentLauncherVisbible(getSourceKey(sourceId), hasSignal);
}

/**
 * Handle a change to the availability state of one of our enzo content sources.
 */
define_function handleEnzoContentSourceStatusEvent(integer sourceId, char isAvailable)
{
	log(AMX_DEBUG, "'Enzo source status event for ',
			getEnzoContentSourceName(sourceId), ' [',
			bool_to_string(isAvailable), ']'");

	setContentLauncherVisbible(getEnzoContentSourceKey(sourceId), isAvailable);

	hideFileBrowser();
}


define_start

setLogPrefix("'huddleController[', getInstanceId(), ']'");
