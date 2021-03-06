program_name='huddleEnzoListener'


#define INCLUDE_ENZO_NOTIFY_CONTENT_SOURCES
#define INCLUDE_ENZO_NOTIFY_CONTENT_ERROR
#define INCLUDE_ENZO_NOTIFY_CONTENT_SOURCE_COUNT
#define INCLUDE_ENZO_NOTIFY_CONTENT_ITEMS_RECORD_COUNT
#define INCLUDE_ENZO_NOTIFY_CONTENT_ITEMS_RECORD
#define INCLUDE_ENZO_NOTIFY_CONTENT_PATH_CHANGED
#define INCLUDE_ENZO_NOTIFY_CONTENT_OPEN_ERROR


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

define_function enzoNotifyContentSourcesRecord(dev enzo, integer relativeIndex,
		integer absoluteIndex, char id[], char name[], char rootPath[],
		char isAvailable)
{
	if (enzo == dvEnzo)
	{
		if (absoluteIndex <= MAX_ENZO_CONTENT_SOURCES)
		{
			setEnzoContentSourceSourceId(absoluteIndex, id);
			setEnzoContentSourceSourceName(absoluteIndex, name);
			setEnzoContentSourceAvailable(absoluteIndex, isAvailable);
		}
	}
}

define_function enzoNotifyContentSourceCount(dev enzo, integer relativeCount,
		integer absoluteCount)
{
	if (enzo == dvEnzo)
	{
		setEznoContentSourceCount(min_value(absoluteCount, MAX_ENZO_CONTENT_SOURCES));

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
				stack_var integer i;
				for (i = MAX_ENZO_CONTENT_SOURCES; i; i--)
				{
					setEnzoContentSourceAvailable(i, false);
				}
				enzoIsInSession = false;
				handleEnzoLogoutEvent();
			}
		}
	}
}

define_function enzoNotifyContentItemsRecordCount(dev enzo,
		integer relativeCount, integer absoluteCount)
{
	if (enzo == dvEnzo)
	{
		setEznoContentItemCount(relativeCount);
	}
}

define_function enzoNotifyContentItemsRecord(dev enzo, integer relativeIndex,
		integer absoluteIndex, char sourceId[], char path[], char name[],
		char type[], long size, char lastModified[], char readOnly)
{
	if (enzo == dvEnzo)
	{
		updateEnzoContentItem(relativeIndex, sourceId, path, name, type, size,
				lastModified, readOnly);

		if (relativeIndex == getEnzoContentItemCount())
		{
			refreshFileList();
		}
	}
}

define_function enzoNotifyContentPathChanged(dev enzo, char sourceId[], char path[])
{
	if (enzo = dvEnzo)
	{
		enzoRequestContentItems(dvEnzo, 1, MAX_ENZO_CONTENT_ITEMS, true);
	}
}

define_function enzoNotifyContentContentOpenError(dev enzo, char message[256],
		char path[256])
{
	if (enzo == dvEnzo)
	{
		showFileBrowserError();
	}
}


define_event

timeline_event[ENZO_SOURCE_POLL_TL]
{
	enzoRequestContentSources(dvEnzo);
}

data_event[dvEnzo]
{

	command: {}

	string: {}

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
