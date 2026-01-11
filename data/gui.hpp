class RscDisplayMissionOptions
{
	idd = 2913;
	movingEnable = 1;
	class controls
	{
		class Title
		{
			deletable = 0;
			fade = 0;
			type = 0;
			colorBackground[] = {0,0,0,0};
			fixedWidth = 0;
			colorShadow[] = {0,0,0,0.5};
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			shadow = 0;
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			colorText[] = {0.95,0.95,0.95,1};
			font = "PuristaMedium";
			style = 0;
			idc = 1000;
			text = "Mission Options";
			x = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "15 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class ButtonCancel
		{
			deletable = 0;
			fade = 0;
			class HitZone
			{
				left = 0;
				top = 0;
				right = 0;
				bottom = 0;
			};
			textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
			font = "RobotoCondensed";
			url = "";
			action = "";
			class AttributesImage
			{
				font = "RobotoCondensed";
				color = "#E5E5E5";
				align = "left";
			};
			type = 16;
			style = "0x02 + 0xC0";
			default = 0;
			shadow = 0;
			animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
			animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
			colorBackground[] = {0,0,0,0.8};
			colorBackgroundFocused[] = {1,1,1,1};
			colorBackground2[] = {0.75,0.75,0.75,1};
			color[] = {1,1,1,1};
			colorFocused[] = {0,0,0,1};
			color2[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			textSecondary = "";
			colorSecondary[] = {1,1,1,1};
			colorFocusedSecondary[] = {0,0,0,1};
			color2Secondary[] = {0,0,0,1};
			colorDisabledSecondary[] = {1,1,1,0.25};
			sizeExSecondary = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			fontSecondary = "PuristaLight";
			period = 1.2;
			periodFocus = 1.2;
			periodOver = 1.2;
			size = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			class TextPos
			{
				left = "0.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				top = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - 		(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
				right = 0.005;
				bottom = 0;
			};
			class Attributes
			{
				font = "PuristaLight";
				color = "#E5E5E5";
				align = "left";
				shadow = "false";
			};
			class ShortcutPos
			{
				left = "5.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				top = 0;
				w = "1 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				h = "1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};
			idc = 2;
			shortcuts[] = {"0x00050000 + 1"};
			text = "Cancel";
			x = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "23 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "6.25 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class ButtonOKscripted
		{
			deletable = 0;
			fade = 0;
			class HitZone
			{
				left = 0;
				top = 0;
				right = 0;
				bottom = 0;
			};
			textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
			font = "RobotoCondensed";
			url = "";
			action = "";
			class AttributesImage
			{
				font = "RobotoCondensed";
				color = "#E5E5E5";
				align = "left";
			};
			type = 16;
			style = "0x02 + 0xC0";
			shadow = 0;
			animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureOver = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)";
			animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)";
			animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)";
			colorBackground[] = {0,0,0,0.8};
			colorBackgroundFocused[] = {1,1,1,1};
			colorBackground2[] = {0.75,0.75,0.75,1};
			color[] = {1,1,1,1};
			colorFocused[] = {0,0,0,1};
			color2[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			textSecondary = "";
			colorSecondary[] = {1,1,1,1};
			colorFocusedSecondary[] = {0,0,0,1};
			color2Secondary[] = {0,0,0,1};
			colorDisabledSecondary[] = {1,1,1,0.25};
			sizeExSecondary = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			fontSecondary = "PuristaLight";
			period = 1.2;
			periodFocus = 1.2;
			periodOver = 1.2;
			size = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			class TextPos
			{
				left = "0.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				top = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - 		(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
				right = 0.005;
				bottom = 0;
			};
			class Attributes
			{
				font = "PuristaLight";
				color = "#E5E5E5";
				align = "left";
				shadow = "false";
			};
			class ShortcutPos
			{
				left = "5.25 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				top = 0;
				w = "1 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
				h = "1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.09,1};
			shortcuts[] = {"0x00050000 + 0",28,57,156};
			default = 1;
			text = "OK";
			soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenuOK\soundPush",0.09,1};
			idc = 999;
			x = "32.75 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "23 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "6.25 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class CBA_AddonsGroup
		{
			deletable = 0;
			fade = 0;
			type = 15;
			shadow = 0;
			style = 16;
			class VScrollbar
			{
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				shadow = 0;
				scrollSpeed = 0.06;
				height = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				color[] = {1,1,1,1};
				autoScrollEnabled = 1;
				width = 0;
			};
			class HScrollbar
			{
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				shadow = 0;
				scrollSpeed = 0.06;
				width = 0;
				autoScrollEnabled = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				color[] = {1,1,1,1};
				height = 0;
			};
			idc = 4301;
			enableDisplay = 0;
			x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40) + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2))/2))";
			y = "((3.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))/2))";
			w = "((38) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((17.3) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			class controls
			{
				class Background
				{
					deletable = 0;
					fade = 0;
					type = 0;
					colorText[] = {1,1,1,1};
					text = "";
					fixedWidth = 0;
					style = 0;
					shadow = 1;
					colorShadow[] = {0,0,0,0.5};
					font = "RobotoCondensed";
					SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
					linespacing = 1;
					tooltipColorText[] = {1,1,1,1};
					tooltipColorBox[] = {1,1,1,1};
					tooltipColorShade[] = {0,0,0,0.65};
					idc = -1;
					colorBackground[] = {0,0,0,0.4};
					x = "((0.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
					y = "((3.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					w = "((37) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
					h = "((13.8) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
				};
				class AddonText
				{
					deletable = 0;
					fade = 0;
					type = 0;
					colorBackground[] = {0,0,0,0};
					colorText[] = {1,1,1,1};
					fixedWidth = 0;
					shadow = 1;
					colorShadow[] = {0,0,0,0.5};
					font = "RobotoCondensed";
					linespacing = 1;
					tooltipColorText[] = {1,1,1,1};
					tooltipColorBox[] = {1,1,1,1};
					tooltipColorShade[] = {0,0,0,0.65};
					idc = -1;
					style = 1;
					text = "Category:";
					x = "((0.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
					y = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					w = "((4) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
					h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					sizeEx = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
				};
				class VolatileWarningText
				{
					deletable = 0;
					fade = 0;
					type = 0;
					colorBackground[] = {0,0,0,0};
					colorText[] = {1,1,1,1};
					fixedWidth = 0;
					shadow = 1;
					colorShadow[] = {0,0,0,0.5};
					font = "RobotoCondensed";
					linespacing = 1;
					tooltipColorText[] = {1,1,1,1};
					tooltipColorBox[] = {1,1,1,1};
					tooltipColorShade[] = {0,0,0,0.65};
					y = "((2) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					h = "((2*3/4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					sizeEx = "((3/4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
					onLoad = "(_this select 0) ctrlEnable true;";
					idc = 9042;
					style = 0;
					text = "Changes will not persist after mission restart";
					x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
					w = "((24) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
				};
			};
		};
	};
	enableDisplay = 1;
	onLoad = "_this call DOTT_settings_fnc_initDisplayMissionOptions;";
	onUnload = "";
	class controlsBackground
	{
		class BackgroundDisable
		{
			idc = -1;
			style = 0;
			default = 0;
			show = 1;
			fade = 0;
			blinkingPeriod = 0;
			deletable = 0;
			tooltip = "";
			tooltipMaxWidth = 0.5;
			tooltipColorShade[] = {0,0,0,1};
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {0,0,0,0};
			class ScrollBar
			{
				width = 0;
				height = 0;
				scrollSpeed = 0.06;
				arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
				arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
				border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
				thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
				color[] = {1,1,1,1};
			};
			sizeEx = "4.32 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
			font = "RobotoCondensedLight";
			shadow = 1;
			type = 0;
			text = "";
			lineSpacing = 1;
			fixedWidth = 0;
			colorText[] = {1,1,1,1};
			colorShadow[] = {0,0,0,1};
			moving = 0;
			autoplay = 0;
			loops = 0;
			tileW = 1;
			tileH = 1;
			onCanDestroy = "";
			onDestroy = "";
			onMouseEnter = "";
			onMouseExit = "";
			onSetFocus = "";
			onKillFocus = "";
			onKeyDown = "";
			onKeyUp = "";
			onMouseButtonDown = "";
			onMouseButtonUp = "";
			onMouseButtonClick = "";
			onMouseButtonDblClick = "";
			onMouseZChanged = "";
			onMouseMoving = "";
			onMouseHolding = "";
			onVideoStopped = "";
			x = -4;
			y = -2;
			w = 8;
			h = 4;
			colorBackground[] = {1,1,1,0.5};
			onLoad = "(_this select 0) ctrlshow is3DEN;";
		};
		class BackgroundDisableTiles
		{
			idc = -1;
			default = 0;
			show = 1;
			fade = 0;
			blinkingPeriod = 0;
			deletable = 0;
			tooltip = "";
			tooltipMaxWidth = 0.5;
			tooltipColorShade[] = {0,0,0,1};
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {0,0,0,0};
			class ScrollBar
			{
				width = 0;
				height = 0;
				scrollSpeed = 0.06;
				arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
				arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
				border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
				thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
				color[] = {1,1,1,1};
			};
			sizeEx = "4.32 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
			font = "RobotoCondensedLight";
			shadow = 1;
			type = 0;
			colorBackground[] = {0,0,0,0};
			lineSpacing = 1;
			fixedWidth = 0;
			colorShadow[] = {0,0,0,1};
			moving = 0;
			autoplay = 0;
			loops = 0;
			onCanDestroy = "";
			onDestroy = "";
			onMouseEnter = "";
			onMouseExit = "";
			onSetFocus = "";
			onKillFocus = "";
			onKeyDown = "";
			onKeyUp = "";
			onMouseButtonDown = "";
			onMouseButtonUp = "";
			onMouseButtonClick = "";
			onMouseButtonDblClick = "";
			onMouseZChanged = "";
			onMouseMoving = "";
			onMouseHolding = "";
			onVideoStopped = "";
			style = 144;
			x = -4;
			y = -2;
			w = 8;
			h = 4;
			text = "\a3\3DEN\Data\Displays\Display3DENEditAttributes\backgroundDisable_ca.paa";
			tileW = "8 / (32 * pixelW)";
			tileH = "4 / (32 * pixelH)";
			colorText[] = {1,1,1,0.05};
			onLoad = "(_this select 0) ctrlshow is3DEN;";
		};
		class TitleBackground
		{
			deletable = 0;
			fade = 0;
			type = 0;
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			style = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
			idc = 1080;
			x = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "38 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class TabsBackground
		{
			deletable = 0;
			fade = 0;
			type = 0;
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			style = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			colorBackground[] = {0,0,0,1};
			idc = 1081;
			x = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "2.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "38 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
		class MainBackground
		{
			deletable = 0;
			fade = 0;
			type = 0;
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			style = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			colorBackground[] = {0,0,0,0.7};
			idc = 1082;
			x = "1 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "3.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "38 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "19.8 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
	};
	enableSimulation = 0;
};

class DOTT_settings_Row_Checkbox
{
	cba_settings_script = "DOTT_settings_fnc_gui_settingCheckbox";
	class controls
	{
		class Name
		{
			idc = 5010;
			style = 1;
			x = "((0) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((15.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 0;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Checkbox
		{
			idc = 5100;
			x = "((16) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			soundEnter[] = {"\a3\ui_f\data\Sound\RscButtonMenu\soundEnter",0.09,1};
			soundPush[] = {"\a3\ui_f\data\Sound\RscButtonMenu\soundPush",0.09,1};
			soundClick[] = {"\a3\ui_f\data\Sound\RscButtonMenu\soundClick",0.09,1};
			soundEscape[] = {"\a3\ui_f\data\Sound\RscButtonMenu\soundEscape",0.09,1};
			type = 77;
			deletable = 0;
			style = 0;
			checked = 0;
			color[] = {1,1,1,0.7};
			colorFocused[] = {1,1,1,1};
			colorHover[] = {1,1,1,1};
			colorPressed[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.2};
			colorBackground[] = {0,0,0,0};
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackgroundHover[] = {0,0,0,0};
			colorBackgroundPressed[] = {0,0,0,0};
			colorBackgroundDisabled[] = {0,0,0,0};
			textureChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
			textureUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
			textureFocusedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
			textureFocusedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
			textureHoverChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
			textureHoverUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
			texturePressedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
			texturePressedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
			textureDisabledChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
			textureDisabledUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Default
		{
			idc = 5020;
			style = 48;
			text = "\a3\3den\Data\Displays\Display3DEN\ToolBar\undo_ca.paa";
			x = "((27) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 1;
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			colorBackground[] = {0,0,0,0.5};
			colorBackgroundDisabled[] = {0,0,0,0.5};
			colorBackgroundActive[] = {0,0,0,1};
			colorFocused[] = {0,0,0,1};
			colorShadow[] = {0,0,0,0};
			colorBorder[] = {0,0,0,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
			shadow = 2;
			font = "RobotoCondensed";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			url = "";
			offsetX = 0;
			offsetY = 0;
			offsetPressedX = 0;
			offsetPressedY = 0;
			borderSize = 0;
		};
	};
	x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	w = "((37) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	class VScrollbar
	{
		width = 0;
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		height = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	class HScrollbar
	{
		height = 0;
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	deletable = 0;
	fade = 0;
	type = 15;
	idc = -1;
	shadow = 0;
	style = 16;
};

class DOTT_settings_Row_List
{
	cba_settings_script = "DOTT_settings_fnc_gui_settingList";
	class controls
	{
		class Name
		{
			idc = 5010;
			style = 1;
			x = "((0) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((15.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 0;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class List
		{
			idc = 5110;
			x = "((16) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((10.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			arrowFull = "\a3\3DEN\Data\Controls\ctrlCombo\arrowFull_ca.paa";
			arrowEmpty = "\a3\3DEN\Data\Controls\ctrlCombo\arrowEmpty_ca.paa";
			class ComboScrollBar
			{
				thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
				border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
				arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
				arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
				color[] = {1,1,1,1};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				shadow = 0;
				scrollSpeed = 0.06;
				width = 0;
				height = 0;
				autoScrollEnabled = 0;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
			};
			deletable = 0;
			fade = 0;
			type = 4;
			colorSelect[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,1};
			colorScrollbar[] = {1,0,0,1};
			colorDisabled[] = {1,1,1,0.25};
			colorPicture[] = {1,1,1,1};
			colorPictureSelected[] = {1,1,1,1};
			colorPictureDisabled[] = {1,1,1,0.25};
			colorPictureRight[] = {1,1,1,1};
			colorPictureRightSelected[] = {1,1,1,1};
			colorPictureRightDisabled[] = {1,1,1,0.25};
			colorTextRight[] = {1,1,1,1};
			colorSelectRight[] = {0,0,0,1};
			colorSelect2Right[] = {0,0,0,1};
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
			soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
			soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};
			maxHistoryDelay = 1;
			style = "0x10 + 0x200";
			font = "RobotoCondensed";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			shadow = 0;
			colorSelectBackground[] = {1,1,1,0.7};
			wholeHeight = 0.45;
			colorActive[] = {1,0,0,1};
		};
		class Default
		{
			idc = 5020;
			style = 48;
			text = "\a3\3den\Data\Displays\Display3DEN\ToolBar\undo_ca.paa";
			x = "((27) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 1;
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			colorBackground[] = {0,0,0,0.5};
			colorBackgroundDisabled[] = {0,0,0,0.5};
			colorBackgroundActive[] = {0,0,0,1};
			colorFocused[] = {0,0,0,1};
			colorShadow[] = {0,0,0,0};
			colorBorder[] = {0,0,0,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
			shadow = 2;
			font = "RobotoCondensed";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			url = "";
			offsetX = 0;
			offsetY = 0;
			offsetPressedX = 0;
			offsetPressedY = 0;
			borderSize = 0;
		};
	};
	x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	w = "((37) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	class VScrollbar
	{
		width = 0;
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		height = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	class HScrollbar
	{
		height = 0;
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	deletable = 0;
	fade = 0;
	type = 15;
	idc = -1;
	shadow = 0;
	style = 16;
};

class DOTT_settings_Row_Slider
{
	cba_settings_script = "DOTT_settings_fnc_gui_settingSlider";
	class controls
	{
		class Name
		{
			idc = 5010;
			style = 1;
			x = "((0) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((15.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 0;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Slider
		{
			idc = 5120;
			x = "((16) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((8.2) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			style = 1024;
			type = 43;
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			sliderRange[] = {0,1};
			sliderPosition = 1;
			lineSize = 0.1;
			arrowEmpty = "\a3\3DEN\Data\Controls\CtrlXSlider\arrowEmpty_ca.paa";
			arrowFull = "\a3\3DEN\Data\Controls\CtrlXSlider\arrowFull_ca.paa";
			border = "\a3\3DEN\Data\Controls\CtrlXSlider\border_ca.paa";
			thumb = "\a3\3DEN\Data\Controls\CtrlXSlider\thumb_ca.paa";
			class Title
			{
				idc = -1;
				colorBase[] = {1,1,1,1};
				colorActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",1};
			};
			class Value
			{
				idc = -1;
				format = "%.f";
				type = "SPTPlain";
				colorBase[] = {1,1,1,1};
				colorActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",1};
			};
			onCanDestroy = "";
			onDestroy = "";
			onSetFocus = "";
			onKillFocus = "";
			onKeyDown = "";
			onKeyUp = "";
			onMouseButtonDown = "";
			onMouseButtonUp = "";
			onMouseButtonClick = "";
			onMouseButtonDblClick = "";
			onMouseZChanged = "";
			onMouseMoving = "";
			onMouseHolding = "";
			onSliderPosChanged = "";
			default = 0;
			show = 1;
			fade = 0;
			blinkingPeriod = 0;
			deletable = 0;
			tooltip = "";
			tooltipMaxWidth = 0.5;
			tooltipColorShade[] = {0,0,0,1};
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {0,0,0,0};
			class ScrollBar
			{
				width = 0;
				height = 0;
				scrollSpeed = 0.06;
				arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
				arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
				border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
				thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
				color[] = {1,1,1,1};
			};
		};
		class Edit
		{
			idc = 5121;
			x = "((24.3) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((2.2) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 2;
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.95,0.95,0.95,1};
			colorDisabled[] = {1,1,1,0.25};
			colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
			autocomplete = "";
			text = "";
			size = 0.2;
			style = "0x00 + 0x40";
			font = "RobotoCondensed";
			shadow = 2;
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			canModify = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Default
		{
			idc = 5020;
			style = 48;
			text = "\a3\3den\Data\Displays\Display3DEN\ToolBar\undo_ca.paa";
			x = "((27) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))/2";
			w = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 1;
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			colorBackground[] = {0,0,0,0.5};
			colorBackgroundDisabled[] = {0,0,0,0.5};
			colorBackgroundActive[] = {0,0,0,1};
			colorFocused[] = {0,0,0,1};
			colorShadow[] = {0,0,0,0};
			colorBorder[] = {0,0,0,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
			shadow = 2;
			font = "RobotoCondensed";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			url = "";
			offsetX = 0;
			offsetY = 0;
			offsetPressedX = 0;
			offsetPressedY = 0;
			borderSize = 0;
		};
	};
	x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	w = "((37) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	class VScrollbar
	{
		width = 0;
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		height = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	class HScrollbar
	{
		height = 0;
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	deletable = 0;
	fade = 0;
	type = 15;
	idc = -1;
	shadow = 0;
	style = 16;
};

class DOTT_settings_Row_Time
{
	cba_settings_script = "DOTT_settings_fnc_gui_settingTime";
	h = "((2) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	class controls
	{
		class Name
		{
			y = "((0.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			idc = 5010;
			style = 1;
			x = "((0) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			w = "((15.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 0;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "";
			fixedWidth = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			font = "RobotoCondensed";
			SizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Slider
		{
			idc = 5140;
			x = "((16) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((10.5) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			style = 1024;
			type = 43;
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			sliderRange[] = {0,1};
			sliderPosition = 1;
			lineSize = 0.1;
			arrowEmpty = "\a3\3DEN\Data\Controls\CtrlXSlider\arrowEmpty_ca.paa";
			arrowFull = "\a3\3DEN\Data\Controls\CtrlXSlider\arrowFull_ca.paa";
			border = "\a3\3DEN\Data\Controls\CtrlXSlider\border_ca.paa";
			thumb = "\a3\3DEN\Data\Controls\CtrlXSlider\thumb_ca.paa";
			class Title
			{
				idc = -1;
				colorBase[] = {1,1,1,1};
				colorActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",1};
			};
			class Value
			{
				idc = -1;
				format = "%.f";
				type = "SPTPlain";
				colorBase[] = {1,1,1,1};
				colorActive[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",1};
			};
			onCanDestroy = "";
			onDestroy = "";
			onSetFocus = "";
			onKillFocus = "";
			onKeyDown = "";
			onKeyUp = "";
			onMouseButtonDown = "";
			onMouseButtonUp = "";
			onMouseButtonClick = "";
			onMouseButtonDblClick = "";
			onMouseZChanged = "";
			onMouseMoving = "";
			onMouseHolding = "";
			onSliderPosChanged = "";
			default = 0;
			show = 1;
			fade = 0;
			blinkingPeriod = 0;
			deletable = 0;
			tooltip = "";
			tooltipMaxWidth = 0.5;
			tooltipColorShade[] = {0,0,0,1};
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {0,0,0,0};
			class ScrollBar
			{
				width = 0;
				height = 0;
				scrollSpeed = 0.06;
				arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
				arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
				border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
				thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
				color[] = {1,1,1,1};
			};
		};
		class Frame
		{
			x = "((18.25) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((1.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((6) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			type = 0;
			idc = -1;
			deletable = 0;
			style = 64;
			shadow = 2;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "RobotoCondensed";
			sizeEx = 0.02;
			text = "";
		};
		class Separator
		{
			style = 2;
			text = ":   :";
			font = "EtelkaMonospaceProBold";
			x = "((18.25) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((1.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((6) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			sizeEx = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			colorBackground[] = {0,0,0,0.2};
			deletable = 0;
			fade = 0;
			type = 0;
			idc = -1;
			colorText[] = {1,1,1,1};
			fixedWidth = 0;
			shadow = 1;
			colorShadow[] = {0,0,0,0.5};
			linespacing = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Hours
		{
			idc = 5141;
			style = 514;
			tooltip = "Hours";
			font = "EtelkaMonospaceProBold";
			x = "((18.25) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			y = "((1.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((2) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			sizeEx = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			maxChars = 2;
			deletable = 0;
			fade = 0;
			type = 2;
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.95,0.95,0.95,1};
			colorDisabled[] = {1,1,1,0.25};
			colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
			autocomplete = "";
			text = "";
			size = 0.2;
			shadow = 2;
			canModify = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Minutes
		{
			idc = 5142;
			tooltip = "Minutes";
			x = "((20.25) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			style = 514;
			font = "EtelkaMonospaceProBold";
			y = "((1.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((2) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			sizeEx = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			maxChars = 2;
			deletable = 0;
			fade = 0;
			type = 2;
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.95,0.95,0.95,1};
			colorDisabled[] = {1,1,1,0.25};
			colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
			autocomplete = "";
			text = "";
			size = 0.2;
			shadow = 2;
			canModify = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Seconds
		{
			idc = 5143;
			tooltip = "Seconds";
			x = "((22.25) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			style = 514;
			font = "EtelkaMonospaceProBold";
			y = "((1.1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			w = "((2) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			sizeEx = "((0.9) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			maxChars = 2;
			deletable = 0;
			fade = 0;
			type = 2;
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.95,0.95,0.95,1};
			colorDisabled[] = {1,1,1,0.25};
			colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",1};
			autocomplete = "";
			text = "";
			size = 0.2;
			shadow = 2;
			canModify = 1;
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
		};
		class Default
		{
			y = "((0.5) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) + ((0.4) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)) / 2";
			idc = 5020;
			style = 48;
			text = "\a3\3den\Data\Displays\Display3DEN\ToolBar\undo_ca.paa";
			x = "((27) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			w = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
			h = "((1) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
			deletable = 0;
			fade = 0;
			type = 1;
			colorText[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.25};
			colorBackground[] = {0,0,0,0.5};
			colorBackgroundDisabled[] = {0,0,0,0.5};
			colorBackgroundActive[] = {0,0,0,1};
			colorFocused[] = {0,0,0,1};
			colorShadow[] = {0,0,0,0};
			colorBorder[] = {0,0,0,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
			shadow = 2;
			font = "RobotoCondensed";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			url = "";
			offsetX = 0;
			offsetY = 0;
			offsetPressedX = 0;
			offsetPressedY = 0;
			borderSize = 0;
		};
	};
	x = "((1) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	y = "((0) * ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25))";
	w = "((37) * (((safeZoneW / safeZoneH) min 1.2) / 40))";
	class VScrollbar
	{
		width = 0;
		color[] = {1,1,1,1};
		autoScrollEnabled = 1;
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		height = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	class HScrollbar
	{
		height = 0;
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	deletable = 0;
	fade = 0;
	type = 15;
	idc = -1;
	shadow = 0;
	style = 16;
};