program_name='util'


/**
 * Checks is a device is currently online.
 *
 * @param	d			the d:p:s of the device to check
 * @return				a boolean, true if the device is currently online
 */
define_function char deviceIsOnline(dev d) {
	return (device_id(d) > 0);
}

/**
 * Gets the next available virtual device number.
 *
 * @param	searchBase	the value to begin searching from
 * @return				an integer representing the next available virtual device number
 */
define_function integer getNextVirtualDeviceId(integer searchBase) {
	stack_var integer id;

	id = searchBase;
	while(deviceIsOnline(id:1:0)) {
		id = id + 1;
	}

	return id;
}
