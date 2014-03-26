program_name='huddleSourceManager'


#include 'amx-dxlink-api';
#include 'amx-dxlink-control';


define_type

structure SignalSource
{
	char key[32];
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
	setSourceKey(SOURCE_ENZO, 'enzo');
	setSourceName(SOURCE_ENZO, 'Enzo');
	setSourceAvailable(SOURCE_ENZO, true);

	setSourceKey(SOURCE_HDMI, 'hdmi');
	setSourceName(SOURCE_HDMI, 'HDMI input');
	setSourceAvailable(SOURCE_HDMI, false);

	setSourceKey(SOURCE_VGA, 'vga');
	setSourceName(SOURCE_VGA, 'VGA input');
	setSourceAvailable(SOURCE_VGA, false);
}

/**
 * Get the key associated with a source.
 */
define_function char[32] getSourceKey(char sourceId)
{
	return source[sourceId].key;
}

/**
 * Sets the key associated with a source ID.
 */
define_function setSourceKey(char sourceId, char key[32])
{
	log(AMX_DEBUG, "'Associating source key', itoa(sourceId), ' with ', key");
	source[sourceId].key = key;
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

	if (sourceId == SOURCE_ENZO)
	{
		hideOSD();
	}

	cancel_wait 'signal returned';
	cancel_wait 'auto power off';

	setDisplaySource(sourceId);

	activeSource = sourceId;

	updateButtonFeedbackState();

	anchorSourceLauncher(getSourceKey(activeSource));
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
			setDisplayInput(INPUT_HDMI);
		}
		case SOURCE_HDMI:
		{
			dxlinkSetTxVideoInputDigital(dvTx);
			setDisplayInput(INPUT_DVI);
		}
		case SOURCE_VGA:
		{
			dxlinkSetTxVideoInputAnalog(dvTx);
			setDisplayInput(INPUT_DVI);
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
