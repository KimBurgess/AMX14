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
#include 'amx-modero-control';

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
#include 'huddleRmsListener';


define_module

'RmsDuetMonitorMonitor' mdlRmsMonitor(vdvRms, vdvDisplay, dvRx);
'RmsGenericNetLinxDeviceMonitor' mdlRmsEnzo(vdvRms, dvEnzo);
'RmsTouchPanelMonitor' mdlRmsTp(vdvRms, dvTp);
'RmsTouchPanelMonitor' mdlRmsSchedulingTp(vdvRms, dvSchedulingTp);


define_variable

constant char SOURCE_SUBPAGE_PREFEX[] = '[source]';

constant integer BTN_SOURCES = 1;


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
 * Check if this huddle instance is running in extended mode (with UI).
 */
define_function char extendedModeActive()
{
	return deviceIsOnline(dvTp);
}

/**
 * Handle anything involved to turn on / prep the system at the start of a
 * reservation.
 */
define_function handleBookingStart(RmsEventBookingResponse booking)
{
	log(AMX_DEBUG, 'Booking starting for huddle location');
	setDisplayPower(true);
	setActiveSource(SOURCE_ENZO);
}

/**
 * System cleanup following a booking end.
 */
define_function handleBookingEnd(RmsEventBookingResponse booking)
{
	log(AMX_DEBUG, 'Booking ending for huddle location');
	enzoSessionEnd(dvEnzo);
	setDisplayPower(false);
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

	if (extendedModeActive())
	{
	
	}
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
 * Sets the visibility state of a source launcher on our touch panel.
 */
define_function setSourceLauncherVisbible(char key[], char isVisible)
{
	stack_var char subpageName[16];

	log(AMX_DEBUG, "'setting source launcher for ', key, ' visibility ',
			bool_to_string(isVisible)");

	subpageName = "SOURCE_SUBPAGE_PREFEX,key";

	if (isVisible)
	{
		moderoShowSubpage(dvTp, BTN_SOURCES, subpageName, 65535, 10);
	}
	else
	{
		moderoHideSubpage(dvTp, BTN_SOURCES, subpageName, 10);
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

		// TODO change messaged based on if we have a UI available or not
		/*if (extendedModeActive())
		{
			showOSD('disconnect-extended');
		}
		else
		{*/
			showOSD('disconnected');
		//}

		wait_until (isSourceAvailable(sourceId)) 'signal returned'
		{
			log(AMX_DEBUG, 'Signal to active source returned. Switching back to display');
			hideOSD();
		}
	}

	updateButtonFeedbackState();

	// If our touch panel is present we'll dynamically update selectable sources
	// based on what's available.
	if (extendedModeActive())
	{
		stack_var char key[16];
		switch (sourceId)
		{
			case SOURCE_HDMI: key = 'hdmi';
			case SOURCE_VGA: key = 'vga';
		}
		setSourceLauncherVisbible(key, hasSignal);
	}
}

/**
 * Handle a change to the availability state of one of our enzo content sources.
 */
define_function handleEnzoSourceStatusEvent(char sourceId[], char isAvailable)
{
	log(AMX_DEBUG, "'Source status event for ', sourceId, ' [',
			bool_to_string(isAvailable), ']'");

	// Dynamically update our enzo based content sources based on what's
	// available.
	if (extendedModeActive())
	{
		stack_var char key[16];
		switch (sourceId)
		{
			case ENZO_CONTENT_SOURCE_DROPBOX: key = 'dropbox';
			case ENZO_CONTENT_SOURCE_USB: key = 'usb';
		}
		setSourceLauncherVisbible(key, isAvailable);
	}
}


define_start

setLogPrefix("'huddleController[', getInstanceId(), ']'");
