program_name='boardroom2'

// Library Files
#include 'common'
#include 'debug'

#include 'agent-usb-ptz-web-cam'

#include 'system-library-api'
#include 'system-library-control'

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-mutual-exclusions'


/*
 * --------------------
 * 3rd party device includes
 * --------------------
 */

// Need to declare the lighting include file after declaring the lighting devices
#include 'lighting'
// Need to declare the nec monitor include file after declaring the monitor devices
#include 'nec-monitor'
// Need to declare the wake-on-lan include file after declaring the wake-on-lan IP socket
#include 'wake-on-lan'
// Need to declare the rms-main include file after declaring the RMS virtual device
#include 'rms-main'


#include 'system-modules'
#include 'system-functions'
#include 'system-events'
#include 'system-start'
#include 'system-mainline'

/*
 * --------------------
 * Listener includes
 * --------------------
 */

#include 'system-library-listener'