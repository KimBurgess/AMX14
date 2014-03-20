program_name='system-start'

#if_not_defined __SYSTEM_START__
#define __SYSTEM_START__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'

/*
 * --------------------
 * Startup code
 * --------------------
 */
define_start


// rebuild the event table after setting the variable device and channel code array values
//rebuild_event()   // not needed unless assigning values to dev or dev array variables during runtime



initArea (dropAreas19[dvDvxVidOutMonitorLeft.port], 438, 164, 320, 180)
initArea (dropAreas19[dvDvxVidOutMonitorRight.port], 1163, 164, 320, 180)
initArea (dropAreas19[dvDvxVidOutMultiPreview.port], 771, 164, 379, 180)

initArea (dragAreas19[dvDvxVidIn1.port], 747, 400 ,134, 105)
initArea (dragAreas19[dvDvxVidIn5.port], 601, 400, 134, 105)
initArea (dragAreas19[dvDvxVidIn6.port], 893, 400, 134, 105)
initArea (dragAreas19[dvDvxVidIn7.port], 1039,400, 134, 105)
initArea (dragAreas19[dvDvxVidIn8.port], 1185,400, 134, 105)



























#end_if