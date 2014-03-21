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

{
	stack_var integer i
	
	i = 1
	
	for (i = 1; i <= DVX_MAX_VIDEO_INPUTS; i++)
	{
		draggablePopups19[i] = "'draggable-source-',itoa(i)"
	}
}


initArea (dropAreaLeftOrientationMonitorLeft, 310, 303, 180, 320)
initArea (dropAreaLeftOrientationMonitorRight, 310, 657, 180, 320)
initArea (dropAreaRightOrientationMonitorLeft, 310, 657, 180, 320)
initArea (dropAreaRightOrientationMonitorRight, 310, 303, 180, 320)

initArea (dragAreas10[dvDvxVidInTableHdmi1.port], 20, 20 ,133, 200)
initArea (dragAreas10[dvDvxVidInTableHdmi2.port], 647, 20, 133, 200)
initArea (dragAreas10[dvDvxVidInTableVga.port], 20, 1060, 133, 200)
initArea (dragAreas10[dvDvxVidInTableDisplayPort.port], 647,1060, 133, 200)

draggablePopups10[dvDvxVidInTableDisplayPort.port] = 'draggable-source-displayport'
draggablePopups10[dvDvxVidInTableHdmi1.port]       = 'draggable-source-hdmi1'
draggablePopups10[dvDvxVidInTableHdmi2.port]       = 'draggable-source-hdmi2'
draggablePopups10[dvDvxVidInTableVga.port]         = 'draggable-source-vga'





















#end_if