program_name='huddleDisplayManager'


#include 'SNAPI';


define_constant

char INPUT_HDMI[] = 'HDMI';
char INPUT_DVI[] = 'DVI';


/**
 * Sets the active display input.
 */
define_function setDisplayInput(char input[8])
{
	local_var char cmd[DUET_MAX_CMD_LEN];

	log(AMX_DEBUG, "'Changing display input [', input, ']'");

	wait_until (displayIsReady()) 'display input change'
	{
		cmd = DuetPackCmdHeader('INPUT');
		cmd = DuetPackCmdParam(cmd, input);
		cmd = DuetPackCmdParam(cmd, '1');
		sendCommand(vdvDisplay, cmd);
	}
}

/**
 * Sets the display power state.
 */
define_function setDisplayPower(char isOn)
{
	log(AMX_DEBUG, "'Setting display power [', bool_to_string(isOn), ']'");

	if (!isOn)
	{
		cancel_wait 'display input change';
	}

	wait_until (displayIsReady()) 'display power change'
	{
		[vdvDisplay, POWER_ON] = isOn;
	}

}

/**
 * Check if the display / module is in a state where it will listen to us.
 */
define_function char displayIsReady()
{
	return !([vdvDisplay, LAMP_WARMING_FB] || [vdvDisplay, LAMP_COOLING_FB]);
}
