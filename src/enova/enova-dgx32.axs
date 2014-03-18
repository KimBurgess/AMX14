program_name='enova-dgx32'

include 'amx-dxlink-api'

#include 'amx-device-control'
#include 'amx-dgx-api'
#include 'amx-dgx-control'
#include 'amx-dxlink-api'
#include 'amx-dxlink-control'
#include 'amx-modero-api'
#include 'amx-modero-control'


define_device

// Touch Panel
dvTpMain         = 10001:1:0

// Touch Tracker - for Drag and drop module
touchTracker = 33001:1:0

// DGX Switcher
dvDgxSwitcher = 5002:DGX_PORT_SWITCHER:0
dvDgxSwitcherDiagnotsics = 5002:DGX_PORT_DIAGNOSTICS:0

// DXLink Fiber Multi-Format Transmitter
dvDxlfMftxMain              = 6001:DXLINK_PORT_MAIN:0
dvDxlfMftxUsb               = 6001:DXLINK_PORT_USB:0
dvDxlfMftxAudioInput        = 6001:DXLINK_PORT_AUDIO_INPUT:0
dvDxlfMftxVideoInputDigital = 6001:DXLINK_PORT_VIDEO_INPUT_DIGITAL:0
dvDxlfMftxVideoInputAnalog  = 6001:DXLINK_PORT_VIDEO_INPUT_DIGITAL:0

// DXLink Fiber Receiver
dvDxlfRxMain        = 7001:DXLINK_PORT_MAIN:0
dvDxlfRxUsb         = 7001:DXLINK_PORT_USB:0
dvDxlfRxAudioOutput = 7001:DXLINK_PORT_AUDIO_OUTPUT:0
dvDxlfRxVideoOutput = 7001:DXLINK_PORT_VIDEO_OUTPUT:0


define_constant

// CMD/STR Delimeters
char DELIM_HEADER[] = '-'
char DELIM_PARAM[] = ','

// DGX inputs
integer DGX_INPUT_SIGNAGE           = 1
integer DGX_INPUT_BLURAY            = 2
integer DGX_INPUT_LAPTOP            = 5
integer DGX_INPUT_SIGNAGE_REMOVABLE = 9

// DGX outputs
integer DGX_OUTPUT_DVX_1_FEED_1     = 1
integer DGX_OUTPUT_DVX_2_FEED_1     = 2
integer DGX_OUTPUT_DVX_1_FEED_2     = 5
integer DGX_OUTPUT_DVX_2_FEED_2     = 6
integer DGX_OUTPUT_MONITOR_FIBER_RX = 9
integer DGX_OUTPUT_ENCODER          = 13
integer DGX_OUTPUT_MONITOR_DIRECT   = 14

// Touch panel button channel codes
integer BTN_RESET_DEMO = 1

integer BTN_SOURCE_SIGNAGE           = 11
integer BTN_SOURCE_BLURAY            = 12
integer BTN_SOURCE_LAPTOP            = 13
integer BTN_SOURCE_SIGNAGE_REMOVABLE = 14

integer BTN_DESTINATION_DVX_1            = 21
integer BTN_DESTINATION_DVX_2            = 22
integer BTN_DESTINATION_MONITOR_RECEIVER = 23
integer BTN_DESTINATION_ENCODER          = 24
integer BTN_DESTINATION_MONITOR_LOCAL    = 25


char POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE[]            = 'draggable-source-signage'
char POPUP_NAME_DRAGGABLE_SOURCE_BLURAY[]             = 'draggable-source-bluray'
char POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP[]             = 'draggable-source-laptop'
char POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE[]  = 'draggable-source-signage-removable'




define_variable

// Modero Listener Dev Array for Listening to button events
dev dvPanelsButtons[] = { dvTpMain }

char ipAddressDxlfTx[15]
char ipAddressDxlfRx[15]

char draggableItemBitmapNames[DGX_32_MAX_VIDEO_INPUTS][30]



define_module 'drag-and-drop' dragAndDropMod (touchTracker, dvTpMain)

#define INCLUDE_MODERO_NOTIFY_BUTTON_BITMAP_NAME
define_function moderoNotifyButtonBitmapName (dev panel, integer btnAdrCde, integer nbtnState, char bitmapName[])
{
	// panel is the touch panel
	// btnAdrCde is the button address code
	// btnState is the button state
	// bitmapName is the name of the image assigned to the button
	
	switch (btnAdrCde)
	{
		case BTN_SOURCE_SIGNAGE:	        draggableItemBitmapNames[DGX_INPUT_SIGNAGE] = bitmapName
		case BTN_SOURCE_BLURAY:	            draggableItemBitmapNames[DGX_INPUT_BLURAY] = bitmapName
		case BTN_SOURCE_LAPTOP:	            draggableItemBitmapNames[DGX_INPUT_LAPTOP] = bitmapName
		case BTN_SOURCE_SIGNAGE_REMOVABLE:	draggableItemBitmapNames[DGX_INPUT_SIGNAGE_REMOVABLE] = bitmapName
	}
}


// Override Callback function from Moder Listener to track button pushes
#define INCLUDE_MODERO_NOTIFY_BUTTON_PUSH
define_function moderoNotifyButtonPush (dev panel, integer btnChanCde)
{
	// panel is the touch panel
	// btnChanCde is the button channel code
	
	if (panel == dvTpMain)
	{
		switch (btnChanCde)
		{
			case BTN_RESET_DEMO:
			{
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_1_FEED_1)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_1_FEED_2)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_2_FEED_1)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_2_FEED_2)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_ENCODER)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_MONITOR_DIRECT)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_MONITOR_FIBER_RX)
			}
		}
	}
}






define_event

data_event [dvDxlfMftxUsb]
{
	command:
	{
	}
}

data_event[dvDxlfRxMain]
data_event[dvDxlfRxUsb]
data_event[dvDxlfRxAudioOutput]
data_event[dvDxlfRxVideoOutput]
{
	command:
	{
		ipAddressDxlfTx = data.sourceip
		dxlinkEnableTxUsbHidService (dvDxlfMftxUsb)
		
		if (device_id(dvDxlfRxUsb))
			dxlinkSetRxUsbHidRoute (dvDxlfRxUsb,ipAddressDxlfTx)
	}
}

data_event [dvDxlfRxUsb]
{
	online:
	{
		if (device_id(dvDxlfMftxUsb))
			dxlinkSetRxUsbHidRoute (dvDxlfRxUsb,ipAddressDxlfTx)
	}
}

data_event [dvDgxSwitcher]
data_event [dvDgxSwitcherDiagnotsics]
{
	online:
	{
	}
	command:
	{
	}
	string:
	{
	}
}

data_event [dvTpMain]
{
	online:
	{
		// request bitmaps of sources
		moderoRequestButtonBitmapName (dvTpMain, BTN_SOURCE_SIGNAGE, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpMain, BTN_SOURCE_BLURAY, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpMain, BTN_SOURCE_LAPTOP, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpMain, BTN_SOURCE_SIGNAGE_REMOVABLE, MODERO_BUTTON_STATE_OFF)
		
		// reset popups
		moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
		moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
		
		moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
		moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
		
		moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
		moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
		
		moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
		moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
	}
}


data_event [touchTracker]
{
	online:
	{
		// Define drop areas
		//send_command touchTracker, 'DEFINE_DROP_AREA-<id>,<left>,<top>,<width>,<height>'
		sendCommand (touchTracker, "'DEFINE_DROP_AREA-',itoa(DGX_OUTPUT_DVX_1_FEED_1),',24,408,215,120'")
		sendCommand (touchTracker, "'DEFINE_DROP_AREA-',itoa(DGX_OUTPUT_DVX_2_FEED_1),',282,408,215,120'")
		sendCommand (touchTracker, "'DEFINE_DROP_AREA-',itoa(DGX_OUTPUT_MONITOR_FIBER_RX),',540,408,215,120'")
		sendCommand (touchTracker, "'DEFINE_DROP_AREA-',itoa(DGX_OUTPUT_ENCODER),',798,408,215,120'")
		sendCommand (touchTracker, "'DEFINE_DROP_AREA-',itoa(DGX_OUTPUT_MONITOR_DIRECT),',1041,408,215,120'")
		
		// Define drop items
		//send_command touchTracker, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
		sendCommand (touchTracker, "'DEFINE_DRAG_ITEM-',itoa(DGX_INPUT_BLURAY),',415,112,120,120'")
		sendCommand (touchTracker, "'DEFINE_DRAG_ITEM-',itoa(DGX_INPUT_SIGNAGE),',281,112,120,120'")
		sendCommand (touchTracker, "'DEFINE_DRAG_ITEM-',itoa(DGX_INPUT_SIGNAGE_REMOVABLE),',879,112,120,120'")
		sendCommand (touchTracker, "'DEFINE_DRAG_ITEM-',itoa(DGX_INPUT_LAPTOP),',549,112,120,120'")
	}
	
	string:
	{
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-': {}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				switch (idDragItem)
				{
					case DGX_INPUT_SIGNAGE:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
					}
					case DGX_INPUT_BLURAY:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
					}
					case DGX_INPUT_LAPTOP:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
					}
					case DGX_INPUT_SIGNAGE_REMOVABLE:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
					}
				}
				
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
				
				dgxEnableSwitch (dvDgxSwitcher, DGX_SWITCH_LEVEL_ALL, idDragItem, idDropArea)
				
				switch (idDropArea)
				{
					case DGX_OUTPUT_DVX_1_FEED_1:     btnDropArea = BTN_DESTINATION_DVX_1
					case DGX_OUTPUT_DVX_2_FEED_1:     btnDropArea = BTN_DESTINATION_DVX_2
					case DGX_OUTPUT_ENCODER:          btnDropArea = BTN_DESTINATION_ENCODER
					case DGX_OUTPUT_MONITOR_DIRECT:   btnDropArea = BTN_DESTINATION_MONITOR_LOCAL
					case DGX_OUTPUT_MONITOR_FIBER_RX: btnDropArea = BTN_DESTINATION_MONITOR_RECEIVER
				}
				
				moderoSetButtonBitmap (dvTpMain, btnDropArea, MODERO_BUTTON_STATE_OFF, draggableItemBitmapNames[idDragItem])
				
				// reset the draggable popup position by hiding it and then showing it again
				switch (idDragItem)
				{
					case DGX_INPUT_SIGNAGE:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE)
					}
					case DGX_INPUT_BLURAY:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_BLURAY)
					}
					case DGX_INPUT_LAPTOP:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_LAPTOP)
					}
					case DGX_INPUT_SIGNAGE_REMOVABLE:
					{
						moderoDisablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
						moderoEnablePopup (dvTpMain, POPUP_NAME_DRAGGABLE_SOURCE_SIGNAGE_REMOVABLE)
					}
				}
			}
		}
	}
}


#include 'amx-dgx-listener'
#include 'amx-dxlink-listener'
#include 'amx-modero-listener'