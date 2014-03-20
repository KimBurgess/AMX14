program_name='huddleEnzoListener'


#define INCLUDE_ENZO_NOTIFY_CONTENT_ERROR
#define INCLUDE_ENZO_NOTIFY_CONTENT_SOURCE_COUNT

define_variable

volatile dev dvEnzoDevices[1];


#include 'amx-enzo-api';
#include 'amx-enzo-listener';


define_variable

constant long ENZO_SOURCE_POLL_TL = 87809;
constant long ENZO_POLL_INTERVAL[1] = {1000};

volatile char enzoIsInSession;


define_function char getEnzoSessionActive()
{
	return enzoIsInSession;
}

define_function enzoNotifyContentSourceCount(dev enzo, integer relativeCount,
		integer absoluteCount)
{
	if (enzo == dvEnzo)
	{
		// At the time of writing the Enzo API does not provide a means to query
		// ENzo session state. There is however an error returned if you
		// attempt to query available sources whilst the device is not in an
		// active session.
		if (!getEnzoSessionActive())
		{
			enzoIsInSession = true;
			handleEnzoLoginEvent();
		}
	}
}

define_function enzoNotifyContentError(dev enzo, char errorMessage[])
{
	if (enzo == dvEnzo)
	{
		// As above the is the second component to our active/non-active session
		// detection.
		if (find_string(errorMessage, 'Enzo session is not active', 1))
		{
			if (getEnzoSessionActive())
			{
				enzoIsInSession = false;
				handleEnzoLogoutEvent();
			}
		}
	}
}


define_event

timeline_event[ENZO_SOURCE_POLL_TL]
{
	enzoRequestContentSources(dvEnzo);
}

data_event[dvEnzo]
{

	command:
	{

	}

	string:
	{

	}

	online:
	{
		if (!timeline_active(ENZO_SOURCE_POLL_TL))
		{
			timeline_create(ENZO_SOURCE_POLL_TL, ENZO_POLL_INTERVAL, 1,
					TIMELINE_RELATIVE, TIMELINE_REPEAT);
		}
	}

	offline:
	{
		if (timeline_active(ENZO_SOURCE_POLL_TL))
		{
			timeline_kill(ENZO_SOURCE_POLL_TL);
		}
	}

}


define_start

dvEnzoDevices[1] = dvEnzo;
set_length_array(dvEnzoDevices, 1);

rebuild_event();
