classdef GraphicalEngine < handle

	properties
		window 		= 0,
		windowSize 	= 0,
		setup 		= 2
		previousKeyPressed = 0;
		enabledKeys = [];
	end
	methods
		function obj = GraphicalEngine(setup)
			PsychDefaultSetup(setup);
			Screen('Preference', 'SkipSyncTests', 2);
            KbName('UnifyKeyNames');
			obj.setup = setup;
		end

		function openWindow(obj, windowSize)
			[obj.window, obj.windowSize] = PsychImaging('OpenWindow', 0, 0, windowSize);
            Screen('BlendFunction', obj.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		end

		function drawArc(obj, objColor, position, radius, fromAngle, toAngle)
			Screen('DrawArc',obj.window, uint8(objColor),[position - radius, position + ...
                        radius],fromAngle, toAngle);
		end
		function drawFilledRect(obj, objColor, position, rectSize)
			Screen('FillRect',obj.window, uint8(objColor),[position - rectSize ./ 2, position + ...
                        rectSize ./ 2]);
		end

		function drawFilledCircle(obj, objColor, position, radius)
			Screen('FillOval',obj.window, uint8(objColor),[position - radius, position + ...
                        radius]);
		end

		function drawFilledPoly(obj, objColor, vertices)
			Screen('FillPoly',obj.window,objColor,vertices')
		end

		function drawCenteredText(obj, textToDisplay,  objColor)
			DrawFormattedText(obj.window,textToDisplay,'center','center', objColor);
        end
        
        function drawText(obj, textToDisplay, postion, objColor)
			Screen('DrawText', obj.window, textToDisplay, postion(1), postion(2), objColor);
        end
        
		function whiteIndex = getWhiteIndex(obj)
			whiteIndex = WhiteIndex(obj.window);
		end
		function wSize = getWindowSize(obj)
			wSize = obj.windowSize;
		end

		function closeAllWindows(obj)
			Screen('CloseAll');
		end

		function updateScreen(obj)
			Screen('Flip', obj.window);
		end

		function pos = getMousePosition(obj)
			pos = get(0, 'PointerLocation');
			% [x,y] = GetMouse();
		end

		function setMousePosition(obj, x, y)
			SetMouse(x, y);
		end

		function center = getCenter(obj)
			center = obj.windowSize(3:4) ./ 2;
		end

		function hideCursor(obj)
			HideCursor();
		end

		function showCursor(obj)
			ShowCursor();
		end

		function keyPressed = checkIfKeyPressed(obj, key)
			[a,b,keyCode] = KbCheck;
			keyPressed = false;
			if any(keyCode(key))
				if obj.previousKeyPressed ~= key
					keyPressed = true;
					obj.previousKeyPressed = key;
				end
			else
				obj.previousKeyPressed = 0;
			end
		end

		function key = getKeyboardKey(obj, key)
			key = KbName(key);
		end

		function addEnabledKeyInput(obj, key)
			obj.enabledKeys = [obj.enabledKeys key];
			RestrictKeysForKbCheck(obj.enabledKeys);
		end
	end
end