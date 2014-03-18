program_name='huddleSourceManager'


#include 'amx-dxlink-api';
#include 'amx-dxlink-control';


define_type

structure SignalSource
{
	char name[32];
	char isAvailable;
}


define_variable

constant char SOURCE_ENZO = 1;
constant char SOURCE_HDMI = 2;
constant char SOURCE_VGA = 3;

constant char NUM_SOURCES = 3;

volatile SignalSource source[NUM_SOURCES];

volatile char activeSource;


/**
 * Set up system source information.
 */
define_function configSources() {
	setSourceName(SOURCE_ENZO, 'Enzo');
	setSourceAvailable(SOURCE_ENZO, true);

	setSourceName(SOURCE_HDMI, 'HDMI input');
	setSourceAvailable(SOURCE_HDMI, false);

	setSourceName(SOURCE_VGA, 'VGA input');
	setSourceAvailable(SOURCE_VGA, false);
}

/**
 * Get the human readable name associated with a source.
 */
define_function char[32] getSourceName(char sourceId)
{
	return source[sourceId].name;
}

/**
 * Sets the human readable name associated with a source ID.
 */
define_function setSourceName(char sourceId, char name[32])
{
	log(AMX_DEBUG, "'Associating source ID', itoa(sourceId), ' with ', name");
	source[sourceId].name = name;
}

/**
 * Check the availability (aka input status) of a source id.
 */
define_function char isSourceAvailable(char sourceId)
{
	return source[sourceId].isAvailable;
}

/**
 * Sets the source available for consideration during switching requests.
 */
define_function setSourceAvailable(char sourceId, char isAvailable)
{
	log(AMX_DEBUG, "'Setting availability state of ', getSourceName(sourceId),
			' ', bool_to_string(isAvailable)");

	source[sourceId].isAvailable = isAvailable;
}

/**
 * Gets the number of sources currently available for selection.
 */
define_function char getAvailableSourceCount()
{
	stack_var char i;
	stack_var char count;

	count = 0;
	for (i = NUM_SOURCES; i; i--)
	{
		if (isSourceAvailable(i))
		{
			count = count + 1;
		}
	}

	return count;
}

/**
 * Set the active system source.
 */
define_function setActiveSource(char sourceId)
{
	log(AMX_INFO, "'Selecting ', getSourceName(sourceId), ' as system source'");

	setDisplaySource(sourceId);

	if (sourceId == SOURCE_ENZO)
	{
		enzoBlankingHide(dvEnzo);
	}
	else
	{
		enzoBlankingShow(dvEnzo, true);
	}

	activeSource = sourceId;

	updateButtonFeedbackState();
}

/**
 * Sets the source to be output to the room display.
 */
define_function setDisplaySource(char sourceId)
{
	log(AMX_DEBUG, "'Switching to ', getSourceName(sourceId)");

	switch (sourceId)
	{
		case SOURCE_ENZO:
		{
			// TODO select correct input on display
		}
		case SOURCE_HDMI:
		{
			dxlinkSetTxVideoInputDigital(dvTXTable);
			// TODO select correct input on display
		}
		case SOURCE_VGA:
		{
			dxlinkSetTxVideoInputAnalog(dvTXTable);
			// TODO select correct input on display
		}
	}
}

/**
 * Gets the currently active system source.
 */
define_function char getActiveSource()
{
	return activeSource;
}

/**
 * Selects the next available source.
 */
define_function cycleActiveSource()
{
	stack_var char i;
	for (i = activeSource; i < activeSource + NUM_SOURCES - 1; i++)
	{
		if (isSourceAvailable(i % NUM_SOURCES + 1))
		{
			setActiveSource(i % NUM_SOURCES + 1);
			break;
		}
	}
}


define_start

configSources();
