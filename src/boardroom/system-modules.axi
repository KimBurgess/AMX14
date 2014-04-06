program_name='system-modules'

#if_not_defined __SYSTEM_MODULES__
#define __SYSTEM_MODULES__

#include 'system-devices'
#include 'system-variables'

/*
 * --------------------
 * Module Definitions
 * --------------------
 */

define_module

'drag-and-drop' dragAndDropMod (vdvDragAndDrop10, dvTpDragAndDrop10)

'drag-and-drop' dragAndDropMod (vdvDragAndDrop19, dvTpDragAndDrop19)


'multi-preview-dvx-v2' multiPreviewDvx (vdvMultiPreview,
                                        dvDvxVidOutMultiPreview, 
                                        dvTpTableVideo, 
                                        btnsVideoSnapshotPreviews,          // address codes
                                        btnAdrsVideoSnapshotPreviews,       // address codes
                                        btnAdrsVideoInputLabels,            // address codes
                                        btnAdrsVideoOutputSnapshotPreviews, // address codes
                                        btnAdrVideoPreviewLoadingMessage,   // address code
                                        btnLoadingBarMultiState,            // channel code
                                        btnAdrLoadingBar,                   // address code
                                        btnAdrVideoPreviewWindow,           // address code
                                        btnExitVideoPreview,                // channel code
                                        popupNameVideoPreview,
                                        imageFileNameNoVideo)

'Samsung_MD55C_Comm_dr1_0_0' commMonitorLeft (vdvMonitorLeft, dvMonitorLeft)

'Samsung_MD55C_Comm_dr1_0_0' commMonitorLeft (vdvMonitorRight, dvMonitorRight)



'MD5Calculator_dr1_0_0' mdlMD5(vdvMD5Util, dvMaster)

'RmsTouchPanelMonitor' mdlRmsBoardroomTp(vdvRMS, dvTpScheduling)

'SchedulingUI' mdlBoardroomUi(vdvRms, dvTpScheduling, vdvMD5Util)














#end_if