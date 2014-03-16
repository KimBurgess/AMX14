program_name='logger'

#if_not_defined __LOGGER
#define __LOGGER


define_device

debug = dynamic_virtual_device;


define_variable

constant char LOG_PREFIX_MAX_LENGTH = 128;
constant char LOG_PREFIX_SEPERATOR[] = '::';
volatile char logPrefix[LOG_PREFIX_MAX_LENGTH];


/**
 * Sets the log prefix to use for messages generated within this scope.
 */
define_function setLogPrefix(char prefix[LOG_PREFIX_MAX_LENGTH])
{
	logPrefix = prefix;
}

/**
 * Light weight wrapper for internal log functions to enable prefixing (e.g. to
 * assist in identifying message source within modules etc)
 *
 * @param	lvl		the message severity level
 * @param			the log message
 */
define_function log(long lvl, char msg[])
{
	if (length_string(logPrefix) > 0)
	{
		amx_log(lvl, "logPrefix, LOG_PREFIX_SEPERATOR, msg");
	}
	else
	{
		amx_log(lvl, msg);
	}
}


define_event

data_event[debug]
{

	command:
	{
		switch(upper_string(data.text))
		{
			case 'ERROR': set_log_level(AMX_ERROR);
			case 'WARNING': set_log_level(AMX_WARNING);
			case 'INFO': set_log_level(AMX_INFO);
			case 'DEBUG': set_log_level(AMX_DEBUG);
			default: set_log_level(atoi(data.text));
		}
	}

}

#end_if