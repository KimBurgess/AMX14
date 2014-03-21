program_name='huddleEnzoContentManager'


define_type

structure enzoContentSource
{
	char key[64];
	char name[64];
	char isAvailable;
}

structure enzoContentItem
{
	char sourceKey[64];
	char path[256];
	char name[128];
	char type[128];
	long size;
	char lastModified[32];
	char readOnly;
}


define_variable

constant char ENZO_CONTENT_SOURCE_DROPBOX = 1;
constant char ENZO_CONTENT_SOURCE_DOWNLOADS = 2;
constant char ENZO_CONTENT_SOURCE_USB = 3;

constant char MAX_ENZO_CONTENT_SOURCES = 3;
constant char MAX_ENZO_CONTENT_ITEMS = 10;

volatile enzoContentSource enzoSource[MAX_ENZO_CONTENT_SOURCES];
volatile enzoContentItem enzoContent[MAX_ENZO_CONTENT_ITEMS];


/**
 * Sets the current number of active enzo content sources.
 */
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

/**
 * Sets the current number of content items available.
 */
define_function setEznoContentItemCount(integer count)
{
	set_length_array(enzoContent, count);
}

/**
 * Gets the current number of content items cached.
 */
define_function integer getEnzoContentItemCount()
{
	return length_array(enzoContent);
}

/**
 * Update the details for a tracked content item.
 */
define_function updateEnzoContentItem(integer id, char sourceKey[], char path[],
	char name[], char type[], long size, char lastModified[], char readOnly)
{
	enzoContent[id].sourceKey = sourceKey;
	enzoContent[id].path = path;
	enzoContent[id].name = name;
	enzoContent[id].type = type;
	enzoContent[id].size = size;
	enzoContent[id].lastModified = lastModified;
	enzoContent[id].readOnly = readOnly;
}

/**
 * Gets the path for a cached content item.
 */
define_function char[256] getEnzoContentItemPath(integer id)
{
	return enzoContent[id].path;
}

/**
 * Gets the name for a cached content item.
 */
define_function char[128] getEnzoContentItemName(integer id)
{
	return enzoContent[id].name;
}

/**
 * Gets the name for a cached content item.
 */
define_function char[128] getEnzoContentItemType(integer id)
{
	return enzoContent[id].type;
}
