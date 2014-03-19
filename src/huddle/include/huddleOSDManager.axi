program_name='huddleOSDManager'


#include 'string';
#include 'amx-enzo-control';


define_variable

constant char NOTIFICATION_IP_PLACEHOLDER[] = '<ip>';
constant char NOTIFICATION_NAME_PLACEHOLDER[] = '<name>';
constant char NOTIFICATION_PATH[] = 'http://<ip>/notification/<name>.html';


/**
 * Gets the master's IP address.
 */
define_function char[15] getMasterIp()
{
	stack_var ip_address_struct masterIp;

	get_ip_address(0:1:0, masterIp);

	return masterIp.IpAddress;
}

/**
 * Show an OSD message (full screen HTML on Enzo).
 */
define_function showOSD(char messageName[])
{
	stack_var char address[256];

	log(AMX_DEBUG, "'Showing OSD message [', messageName, ']'");

	address = string_replace(NOTIFICATION_PATH, NOTIFICATION_IP_PLACEHOLDER, getMasterIp());
	address = string_replace(address, NOTIFICATION_NAME_PLACEHOLDER, messageName);

	// TODO if enzo is not is session we need to start a session here

	enzoShowWebApp(dvEnzo, address);
}

/**
 * Hide our OSD.
 */
define_function hideOSD()
{
	log(AMX_DEBUG, 'Hiding OSD');

	enzoHideWebApp(dvEnzo);
}