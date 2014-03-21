program_name='system-events'

#if_not_defined __SYSTEM_EVENTS__
#define __SYSTEM_EVENTS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'

/*
 * --------------------
 * Events
 * --------------------
 */

define_event


/*
 * --------------------
 * Data events
 * --------------------
 */


data_event[dvPtzCam]
{
	online:
	{
		amxIrSetMode (data.device, IR_MODE_IR)
	}
}

data_event[dvDvxMain]
{
	online:
	{
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxSetAudioOutputMaximumVolume (dvDvxAudOutSpeakers, volumeMax)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
	}
}

data_event[dvTpDragAndDrop10]
{
	online:
	{
		// request bitmaps of sources
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_HDMI_1, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_HDMI_2, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_VGA, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_DISPLAYPORT, MODERO_BUTTON_STATE_OFF)
	}
}

button_event [dvTpTableDebug,1]
{
	push:
	{
		channelOff (dvTpTableDebug, 1)
		moderoDisableButtonPushes (dvTpTableDebug, 2)
		sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
	}
}

data_event [vdvDragAndDrop19]
{
	online:
	{
		// Define drop areas
		//send_command vdvDragAndDrop, 'DEFINE_DROP_AREA-<id>,<left>,<top>,<width>,<height>'
		
		// Define drop items
		//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidIn1.port, dragAreas19[dvDvxVidIn1.port])")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidIn5.port, dragAreas19[dvDvxVidIn5.port])")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidIn6.port, dragAreas19[dvDvxVidIn6.port])")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidIn7.port, dragAreas19[dvDvxVidIn7.port])")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidIn8.port, dragAreas19[dvDvxVidIn8.port])")
	}
	
	string:
	{
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorLeft.port, dropAreas19[dvDvxVidOutMonitorLeft.port])")
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorRight.port, dropAreas19[dvDvxVidOutMonitorRight.port])")
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMultiPreview.port, dropAreas19[dvDvxVidOutMultiPreview.port])")
				
				channelOn (dvTpTableDebug, 1)
				
				moderoEnableButtonPushes (dvTpTableDebug, 2)
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				moderoDisablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				moderoEnablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMultiPreview.port)")
				
				//channelOff (dvTpTableDebug, 1)	// maybe don't do this here
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-': {}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-': {}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMultiPreview.port)")
				
				
				moderoDisablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				moderoEnablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableDebug, 1)
						
						dvxSwitchVideoOnly (dvDvxMain, idDragItem, dvDvxVidOutMonitorLeft.port)
						
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
						
						// set flag to indicate that system is in use
						isSystemAvInUse = TRUE
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableDebug, 1)
						
						dvxSwitchVideoOnly (dvDvxMain, idDragItem, dvDvxVidOutMonitorRight.port)
						
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
						
						// set flag to indicate that system is in use
						isSystemAvInUse = TRUE
					}
					
					active (idDropArea == dvDvxVidOutMultiPreview.port):
					{
						sendCommand (vdvMultiPreview, "'START_VIDEO_PREVIEW-',itoa(idDragItem)")
					}
				}
				
				
				
			}
			
			case 'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-': {}
		}
	}
}

data_event [vdvDragAndDrop10]
{
	online:
	{
		// Define drag items
		//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi1.port, dragAreas10[dvDvxVidInTableHdmi1.port])")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi2.port, dragAreas10[dvDvxVidInTableHdmi2.port])")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableVga.port, dragAreas10[dvDvxVidInTableVga.port])")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableDisplayPort.port, dragAreas10[dvDvxVidInTableDisplayPort.port])")
	}
	
	string:
	{
		stack_var char header[50]
		local_var integer isClockwiseOrientation
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// remove the other drag items (don't want to allow multiple item selection in this instance)
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi2.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableVga.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableDisplayPort.port)")
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi1.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableVga.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableDisplayPort.port)")
					}
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi1.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi2.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableDisplayPort.port)")
					}
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi1.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi2.port)")
						sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(dvDvxVidInTableVga.port)")
					}
				}
				
				// Define drop areas based on which side was selected
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port OR idDragItem == dvDvxVidInTableVga.port):
					{
						isClockwiseOrientation = true
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorLeft.port, dropAreaLeftOrientationMonitorLeft)")
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorRight.port, dropAreaLeftOrientationMonitorRight)")
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, MODERO_BUTTON_STATE_ALL, 'Left')
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, MODERO_BUTTON_STATE_ALL, 'Right')
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port OR idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						isClockwiseOrientation = false
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorLeft.port, dropAreaRightOrientationMonitorLeft)")
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorRight.port, dropAreaRightOrientationMonitorRight)")
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, MODERO_BUTTON_STATE_ALL, 'Right')
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, MODERO_BUTTON_STATE_ALL, 'Left')
					}
				}
				
				
				// show buttons for the monitors
				cancel_wait 'FIRST_TIME_USER'
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 0, 30, 2)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 0, 30, 2)
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// Define drag items again
				//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi1.port, dragAreas10[dvDvxVidInTableHdmi1.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi2.port, dragAreas10[dvDvxVidInTableHdmi2.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableVga.port, dragAreas10[dvDvxVidInTableVga.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableDisplayPort.port, dragAreas10[dvDvxVidInTableDisplayPort.port])")
				
				// delete the drop areas for the monitors
				sendCommand (vdvDragAndDrop10, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop10, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				
				
				// hide the buttons for the monitors
				wait 20 'FIRST_TIME_USER'
				{
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 30, 1, 3)
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 30, 1, 3)
				}
				
				// reset the draggable popup position by hiding it and then showing it again
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
					}
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
					}
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
					}
				}
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
					}
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
					}
				}
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, btnDropArea, 30, 60, 1)
				
				//channelOn (dvTpDragAndDrop10, btnDropArea)
			}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
					}
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
					}
				}
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, btnDropArea, 60, 30, 2)
				
				//channelOff (dvTpDragAndDrop10, btnDropArea)
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				// Define drag items again
				//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi1.port, dragAreas10[dvDvxVidInTableHdmi1.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableHdmi2.port, dragAreas10[dvDvxVidInTableHdmi2.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableVga.port, dragAreas10[dvDvxVidInTableVga.port])")
				sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(dvDvxVidInTableDisplayPort.port, dragAreas10[dvDvxVidInTableDisplayPort.port])")
				
				// delete the drop areas for the monitors
				sendCommand (vdvDragAndDrop10, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop10, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				
				// hide the buttons for the monitors
				#warn '@TODO'
				
				// switch the selected input to the selected output
				dvxSwitchVideoOnly (dvDvxMain, idDragItem, idDropArea)
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 0, 1, 0)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 0, 1, 0)
				
				//channelOff (dvTpDragAndDrop10, btnDropArea)
				
				// reset the draggable popup position by hiding it and then showing it again
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
					}
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
					}
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
					}
				}
			}
		}
	}
}

// Configure Resolutions for Multi-Preview Input and associated DVX Output
data_event[dvDvxVidOutMultiPreview]
data_event[dvTpTableMain]
{
	online:
	{
		select
		{
			active (data.device == dvDvxVidOutMultiPreview):
			{
				dvxSetVideoOutputResolution (dvDvxVidOutMultiPreview, DVX_VIDEO_OUTPUT_RESOLUTION_1280x720p_60HZ)
				dvxSetVideoOutputAspectRatio (dvDvxVidOutMultiPreview, DVX_ASPECT_RATIO_STRETCH)
			}
			
			active (data.device == dvTpTableMain):
				moderoSetMultiPreviewInputFormatAndResolution (dvTpTableMain, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_1280x720p30HZ)
		}
	}
}

data_event[dvPduMain1]
{
	online:
	{
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		WAIT 50   // putting a wait here because the PDU seems to set the temp scale back to fahrenheit if it is set to celcius immediately after coming online
		pduSetTempScaleCelcius (dvPduMain1)
	}
}

data_event[dvTpTableMain]
{
	online:
	{
		/*
		 * --------------------
		 * Request info from connected devices.
		 * 
		 * This will solicit a response which will in turn update button feedback.
		 * --------------------
		 */
		
		// DVX
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputMaximumVolume (dvDvxAudOutSpeakers)
		
		// DXLink Rx - Left monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorLeftVidOut)
		
		// DXLink Rx - Right monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorRightVidOut)
		
		// DXLink Tx's
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable1Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable2Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable3Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable4Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable1Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable2Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable3Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable4Main)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable1VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable2VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable3VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable4VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable1VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable2VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable3VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable4VidInDigital)
		
		// PDU
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		
		// Update button text for PDU button labels
		{
			stack_var integer i
			
			for (i = 1; i <= PDU_MAX_OUTLETS; i++)
			{
				moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_OUTLET_LABELS[i], MODERO_BUTTON_STATE_ALL, LABELS_PDU_OUTLETS[i])
			}
		}
	}
}

data_event[dvTxTable1Main]
data_event[dvTxTable2Main]
data_event[dvTxTable3Main]
data_event[dvTxTable4Main]
{
	online:
	{
		dxlinkRequestTxVideoInputAutoSelect (data.device)
		dxlinkRequestTxSelectedVideoInput (data.device)
	}
}

data_event[dvTxTable1VidInAnalog]
data_event[dvTxTable2VidInAnalog]
data_event[dvTxTable3VidInAnalog]
data_event[dvTxTable4VidInAnalog]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusAnalog (data.device)
		
	}
}

data_event[dvTxTable1VidInDigital]
data_event[dvTxTable2VidInDigital]
data_event[dvTxTable3VidInDigital]
data_event[dvTxTable4VidInDigital]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusDigital (data.device)
		
	}
}

data_event[dvRxMonitorLeftVidOut]
data_event[dvRxMonitorRightVidOut]
{
	online:
	{
		dxlinkRequestRxVideoOutputResolution (data.device)
		dxlinkRequestRxVideoOutputAspectRatio (data.device)
		dxlinkRequestRxVideoOutputScaleMode (data.device)
	}
}


/*
 * --------------------
 * Button events
 * --------------------
 */






button_event[dvTpTableAudio,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxEnableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxEnableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_MUTE:  dvxCycleAudioOutputVolumeMute (dvDvxAudOutSpeakers)
			
			case BTN_AUDIO_INPUT_01:     dvxSwitchAudioOnly (dvDvxMain, 1, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_02:     dvxSwitchAudioOnly (dvDvxMain, 2, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_03:     dvxSwitchAudioOnly (dvDvxMain, 3, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_04:     dvxSwitchAudioOnly (dvDvxMain, 4, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_05:     dvxSwitchAudioOnly (dvDvxMain, 5, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_06:     dvxSwitchAudioOnly (dvDvxMain, 6, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_07:     dvxSwitchAudioOnly (dvDvxMain, 7, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_08:     dvxSwitchAudioOnly (dvDvxMain, 8, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_09:     dvxSwitchAudioOnly (dvDvxMain, 9, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_10:     dvxSwitchAudioOnly (dvDvxMain, 10, dvDvxAudOutSpeakers.port)
			
			case BTN_AUDIO_FOLLOW_MONITOR_LEFT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
			}
			case BTN_AUDIO_FOLLOW_MONITOR_RIGHT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxDisableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxDisableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
		}
	}
}

/*
button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorLeft)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxVidOutMonitorLeft.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE	// moved to data_event to capture video preview popup hiding
	}
}
*/

/*
button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorRight)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxVidOutMonitorRight.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL))    )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE   // moved to data_event to capture video preview popup hiding
	}
}
*/

/*
button_event[dvTpTableVideo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_VIDEO_MONITOR_LEFT_OFF:     necMonitorSetPowerOff (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_LEFT_ON:      necMonitorSetPowerOn (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_RIGHT_OFF:    necMonitorSetPowerOff (vdvMonitorRight)
			case BTN_VIDEO_MONITOR_RIGHT_ON:     necMonitorSetPowerOn (vdvMonitorRight)
			
			case BTN_VIDEO_QUERY_LYNC_CALL_NO:   {}  // ignore
			case BTN_VIDEO_QUERY_LYNC_CALL_YES:
			{
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
			}
			
			case BTN_VIDEO_LYNC_MONITOR_LEFT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_1)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorLeft.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorLeft)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
			
			case BTN_VIDEO_LYNC_MONITOR_RIGHT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_2)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorRight.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorRight)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
		}
	}
}
*/

button_event[dvTpTableLighting,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_LIGHTING_PRESET_ALL_OFF:    lightsOff (LIGHTING_ADDRESS_BOARDROOM)
		}
	}
}

button_event[dvTpTableBlinds,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_BLIND_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
			case BTN_BLIND_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
			case BTN_BLIND_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_CORNER_WINDOW_STOP)
			
			case BTN_BLIND_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
			case BTN_BLIND_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
			case BTN_BLIND_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_WALL_WINDOW_STOP)
			
			case BTN_SHADE_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
			case BTN_SHADE_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
			case BTN_SHADE_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_CORNER_WINDOW_STOP)
			
			case BTN_SHADE_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
			case BTN_SHADE_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
			case BTN_SHADE_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_WALL_WINDOW_STOP)
		}                      
	}
}

button_event[dvTpTablePower,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_POWER_TOGGLE_MONITOR_LEFT:  pduToggleRelayPower (dvPduOutletMonitorLeft)
			case BTN_POWER_TOGGLE_MONITOR_RIGHT: pduToggleRelayPower (dvPduOutletMonitorRight)
			case BTN_POWER_TOGGLE_PDXL2:         pduToggleRelayPower (dvPduOutletPdxl2)
			
			case BTN_POWER_TOGGLE_MULTI_PREVIEW:
			{
				// Cycle power on the PDU
				pduDisableRelayPower (dvPduOutletMultiPreview)
				wait waitTimePowerCycle
				{
					pduEnableRelayPower (dvPduOutletMultiPreview)
				}
			}
			
			case BTN_POWER_TOGGLE_PC:        pduToggleRelayPower (dvPduOutletPc)
			//case BTN_POWER_TOGGLE_DVX:     pduToggleRelayPower (dvPduOutletDvx)    // don't allow user to turn power off to DVX
			case BTN_POWER_TOGGLE_FAN_1:     pduToggleRelayPower (dvPduOutletFan1)
			case BTN_POWER_TOGGLE_FAN_2:     pduToggleRelayPower (dvPduOutletFan2)
			
			case BTN_POWER_TEMPERATURE_SCALE_TOGGLE:     channelToggle (dvPduMain1,PDU_CHANNEL_TEMP_SCALE)
			case BTN_POWER_TEMPERATURE_SCALE_CELCIUS:    pduSetTempScaleCelcius (dvPduMain1)
			case BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT: pduSetTempScaleFahrenheit (dvPduMain1)
		}
	}
}

button_event[dvTpTableCamera,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  irOn (dvPtzCam, CAM1_FOCUS_NEAR)
			case BTN_CAMERA_FOCUS_FAR:   irOn (dvPtzCam, CAM1_FOCUS_FAR)
			case BTN_CAMERA_ZOOM_IN:     irOn (dvPtzCam, CAM1_ZOOM_FAST_TELE)
			case BTN_CAMERA_ZOOM_OUT:    irOn (dvPtzCam, CAM1_ZOOM_FAST_WIDE)
			case BTN_CAMERA_PAN_LEFT:    irOn (dvPtzCam, CAM1_REVERSE)
			case BTN_CAMERA_PAN_RIGHT:   irOn (dvPtzCam, CAM1_FORWARD)
			case BTN_CAMERA_TILT_DOWN:   irOn (dvPtzCam, CAM1_DOWN)
			case BTN_CAMERA_TILT_UP:     irOn (dvPtzCam, CAM1_UP)
			
			case BTN_CAMERA_HOME:
			{
				irPulse (dvPtzCam, CAM1_HOME)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  irOff (dvPtzCam, CAM1_FOCUS_NEAR)
			case BTN_CAMERA_FOCUS_FAR:   irOff (dvPtzCam, CAM1_FOCUS_FAR)
			case BTN_CAMERA_ZOOM_IN:     irOff (dvPtzCam, CAM1_ZOOM_FAST_TELE)
			case BTN_CAMERA_ZOOM_OUT:    irOff (dvPtzCam, CAM1_ZOOM_FAST_WIDE)
			case BTN_CAMERA_PAN_LEFT:    irOff (dvPtzCam, CAM1_REVERSE)
			case BTN_CAMERA_PAN_RIGHT:   irOff (dvPtzCam, CAM1_FORWARD)
			case BTN_CAMERA_TILT_DOWN:   irOff (dvPtzCam, CAM1_DOWN)
			case BTN_CAMERA_TILT_UP:     irOff (dvPtzCam, CAM1_UP)
		}
	}
}

button_event[dvTpTableDxlink,0]
{
	push:
	{
		// button feedback
		on[button.input]
		
		switch (button.input.channel)
		{
			// TX - Auto
			case BTN_DXLINK_TX_AUTO_1:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable1Main)
			case BTN_DXLINK_TX_AUTO_2:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable2Main)
			case BTN_DXLINK_TX_AUTO_3:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable3Main)
			case BTN_DXLINK_TX_AUTO_4:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable4Main)
			
			// TX - HDMI
			case BTN_DXLINK_TX_HDMI_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable1VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_HDMI_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable2VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_HDMI_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable3VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_HDMI_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable4VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable4Main)
			}
			
			// TX - VGA
			case BTN_DXLINK_TX_VGA_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable1VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_VGA_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable2VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_VGA_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable3VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_VGA_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable4VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable4Main)
			}
			
			// RX - Scaler Auto
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			
			// RX - Scaler Bypass
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			
			// RX - Scaler Manual
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			
			// RX - Aspect Maintain
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			
			// RX - Aspect Stretch
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			
			// RX - Aspect Zoom
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			
			// RX - Aspect Anamorphic
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
		}                                                                        
	}
}

button_event[dvTpTableDebug,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_DEBUG_REBUILD_EVENT_TABLE:
			{
				rebuild_event ()
				debugPrint ('**** Event Table Rebuilt ****')
			}
			case BTN_DEBUG_WAKE_ON_LAN_PC:
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
		}
	}
}

button_event[dvTpTableMain, 0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_MAIN_SHUT_DOWN:
			{
				shutdownAvSystem ()
			}
			
			case BTN_MAIN_SPLASH_SCREEN:
			{
				//startMultiPreviewSnapshots ()
				
				// page flips done on the panel
			}
		}
	}
}



/*
 * --------------------
 * Level events
 * --------------------
 */

level_event[dvTpTableAudio, BTN_LVL_VOLUME_CONTROL]
{
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, level.value)
}



/*
 * --------------------
 * Timeline events
 * --------------------
 */

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	stack_var integer input
	local_var integer slotId
	local_var char dynamicImageName[30]
	
	input = timeline.sequence
	
	if (timelineTimesMultiPreviewSnapshots[input])
	{
		slotId = input
		dynamicImageName = "'MXA_PREVIEW_',itoa(slotId)"
		
		// Only take a snapshot if there is a valid signal status on the input
		if (dvx.videoInputs[slotId].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			dvxSwitchVideoOnly (dvDvxMain, slotId, dvDvxVidOutMultiPreview.port)
			
			WAIT waitTimeMplSnapShot 'WAIT_MULTI_PREVIEW_SNAPSHOT'   // wait just over half a second before taking the snapshot....allows the image time to lock on
			{
				moderoResourceForceRefreshPrefetchFromCache (dvTpTableVideo, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
			}
		}
	}
}



/*
 * --------------------
 * Custom events
 * --------------------
 */


#warn 'BUG: amx-au-gc-boardroom-main - custom event for streaming status not triggering'

custom_event[dvTpTableMain,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
{
	debugPrint ("'custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]'")
	debugPrint ("'custom.device = [',debugDevToString(custom.device),']'")
	debugPrint ("'custom.id = <>',itoa(custom.id)")
	debugPrint ("'custom.type = <>',itoa(custom.type)")
	debugPrint ("'custom.flag = <>',itoa(custom.flag)")
	debugPrint ("'custom.value1 = <>',itoa(custom.value1)")
	debugPrint ("'custom.value2 = <>',itoa(custom.value2)")
	debugPrint ("'custom.value3 = <>',itoa(custom.value3)")
	debugPrint ("'custom.text = "',custom.text,'"'")
	
	switch (custom.flag)
	{
		case 1:	// start
		{
			
		}
		case 2:	// stop
		{
			//startMultiPreviewSnapshots ()
		}
	}
}


data_event[dvTpTableMain]
{
	string:
	{
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','data_event[dvTpTableMain] - string:'"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','data.text = ',data.text"
		
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, '@PPF-popup-video-preview',1) == 1)
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if(find_string(data.text, "@PPF-popup-video-preview",1) == 1)'"
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			//startMultiPreviewSnapshots ()
		}
		else if( data.text == 'AWAKE' )	// panel just woke up
		{
			// this could have been caused by:
			// - user triggering panels' motion sensor
			// - user touching panels' touch overlay without triggering motion sensor somehow
			// - user VNC'ing to the panel
			// - program telling panel to wake up (i.e., if occ sensor triggers)
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "AWAKE" )'"
			
			if (isSystemAvInUse = FALSE)
				// turn on the lights
				lightsEnablePresetAllOn ()
		}
		else if( data.text == 'ASLEEP' )	// panel just went to sleep
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "ASLEEP" )'"
		}
		else if( data.text == 'STANDBY' )	// panel just went into standby
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "STANDBY" )'"
		}
		else if( data.text == 'SHUTDOWN' )	// panel just shut down
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "SHUTDOWN" )'"
		}
		else if( data.text == 'STARTUP' )	// panel just booted
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "STARTUP" )'"
		}
	}
}


button_event[dvTpTableMain,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_MAIN_PRESENTATION:
			{
				channelOn (button.input.device, button.input.channel)
				
				dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
				dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
				
				dvxSetVideoOutputBlankImage (dvDvxVidOutMonitorLeft, DVX_BLANK_IMAGE_LOGO_2)
				dvxSetVideoOutputBlankImage (dvDvxVidOutMonitorRight, DVX_BLANK_IMAGE_LOGO_2)
			}
			
			case BTN_MAIN_VIDEO_CONFERENCE:
			{
				channelOn (button.input.device, button.input.channel)
				
				channelOff (dvTpTableDebug, 1)
				sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
				
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInVcMain.port, dvDvxVidOutMonitorLeft.port)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInVcCamera.port, dvDvxVidOutMonitorRight.port)
			}
		}
	}
}




level_event[dvTpTableLighting,BTN_LVL_LIGHTING_CONTROL]
{
	// set lights
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, level.value, 0)
	// update display bargraph
	sendLevel (dvTpTableLighting, BTN_LVL_LIGHTING_DISPLAY , level.value)
}

#end_if