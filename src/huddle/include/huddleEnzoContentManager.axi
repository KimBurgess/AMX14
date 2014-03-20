program_name='huddleEnzoContentManager'


define_type

structure enzoContentSource
{
	char key[64];
	char name[64];
	char isAvailable;
}



define_variable

constant char ENZO_CONTENT_SOURCE_DROPBOX = 1;
constant char ENZO_CONTENT_SOURCE_DOWNLOADS = 2;
constant char ENZO_CONTENT_SOURCE_USB = 3;

constant char MAX_ENZO_CONTENT_SOURCES = 3;

volatile enzoContentSource enzoSource[MAX_ENZO_CONTENT_SOURCES];


define_function setEznoContentSourceCount(integer count)
{
	set_length_array(enzoSource, count);
}

/**
 * Get the content source ID used by the API.
 */
define_function char[32] getEnzoContentSourceKey(integer sourceId)
{
	return enzoSource[sourceId].key;
}

/**
 * Sets the id to use within the enzo API.
 */
define_function setEnzoContentSourceSourceId(integer sourceId, char key[32])
{
	enzoSource[sourceId].key = key;
}

/**
 * Get the human readable name associated with a content source.
 */
define_function char[32] getEnzoContentSourceName(integer sourceId)
{
	return enzoSource[sourceId].name;
}

/**
 * Sets the human readable name associated with a source.
 */
define_function setEnzoContentSourceSourceName(integer sourceId, char name[32])
{
	enzoSource[sourceId].name = name;
}

/**
 * Check the availability (aka input status) of a source id.
 */
define_function char isEnzoContentSourceAvailable(integer sourceId)
{
	return enzoSource[sourceId].isAvailable;
}

/**
 * Sets the source available for consideration during switching requests.
 */
define_function setEnzoContentSourceAvailable(integer sourceId, char isAvailable)
{
	stack_var char previousAvailability;
	previousAvailability = enzoSource[sourceId].isAvailable;

	enzoSource[sourceId].isAvailable = isAvailable;

	if (isAvailable != previousAvailability)
	{
		handleEnzoContentSourceStatusEvent(sourceId, isAvailable);
	}
}
