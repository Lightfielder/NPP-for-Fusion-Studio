-- Startup script
-- Changes will take effect once Notepad++ is restarted

--[[--
Open in Fusion Studio.lua v1.0 2021-11-21 04.43 PM
By Andrew Hazelden

Part of the "Notepad++ for Fusion" atom package in the Steakunderwater Reactor package manager.

--]]--

npp.AddShortcut("Open in Fusion Studio", "Shift+F5", function()
	-- Absolute filepath for Fusion Studio executable "Fusion.exe"
	local fusionProgramFolder = [[C:\Program Files\Blackmagic Design\Fusion 17\]]
	local fusionExecutable = tostring(fusionProgramFolder) .. [[Fusion.exe]]
	local fuscriptExecutable = tostring(fusionProgramFolder) .. [[fuscript.exe]]
	
	-- Create a temp file for error logging: C:\Users\VFX\AppData\Local\TempNPP4Fusion_log.txt
	local tempFolder = os.getenv('TEMP')
	local logFile = tostring(tempFolder) .. '\\NPP4Fusion_log.txt'

	-- Save the current file to disk
	npp:SaveCurrentFile()

	-- Read the current Notepad++ Document information
	local filename = npp:GetFullCurrentPath()
	local ext = npp:GetExtPart():lower()
	
	if ext and ext == '.comp' then
		-- Opening a Fusion Composite
		print('[Open in Fusion Studio] [Comp File] ', filename, '\t[Ext]', ext, '\t[Logfile]', logFile)
		
		-- Run Fusion
		local command = 'start "" "' .. fusionExecutable .. '" "' .. tostring(filename) .. '" -verbose -log "' .. tostring(logFile) ..'" -cleanlog 2>&1 &' 
		print('[Launch Command] ',  command)
		local result = os.execute(command)
		print('[Result]')
		print(result)
		
		-- Should the error log be displayed?
		npp:DoOpen(logFile)
	elseif ext and ext == '.setting' then
		-- Opening a Fusion Macro
		print('[Open in Fusion Studio] [Macro File] ', filename, '\t[Ext]', ext)
		
		-- Run FuScript
		local command = 'start "" "' .. fuscriptExecutable .. '" -l lua -i -x "fusion = bmd.scriptapp([[Fusion]], [[localhost]], 0.0, 0, [[Interactive]]);if fusion ~= nil then fu = fusion;app = fu;composition = fu.CurrentComp;comp = composition;SetActiveComp(comp);comp:Paste(bmd.readfile([[' ..  tostring(filename) .. ']]));print([[[Adding Macro] ' ..  tostring(filename) .. ']]); else print([[FuScript Error] Please open up the Fusion Studio GUI before running this menu item.]]) end" 2>&1 &' 
		
		print('[Launch Command] ',  command)
		local result = os.execute(command)
		print('[Result]')
		print(result)
	elseif ext and ext == '.lua' then
		-- Running a Fusion Lua Script
		print('[Open in Fusion Studio] [Lua Script] ', filename, '\t[Ext]', ext)
		
		-- Run FuScript
		local command = 'start "" "' .. fuscriptExecutable .. '" -l lua -i -x "fusion = bmd.scriptapp([[Fusion]], [[localhost]], 0.0, 0, [[Interactive]]);if fusion ~= nil then fu = fusion;app = fu;composition = fu.CurrentComp;comp = composition;SetActiveComp(comp);print([[[Lua Script] ' ..  tostring(filename) .. ']]); else print([[FuScript Error] Please open up the Fusion Studio GUI before running this menu item.]]) end" "' .. tostring(filename).. '" 2>&1 &' 
		
		print('[Launch Command] ',  command)
		local result = os.execute(command)
		print('[Result]')
		print(result)
	elseif ext and ext == '.py' then
		-- Running a Fusion Python Script
		print('[Open in Fusion Studio] [Python Script] ', filename, '\t[Ext]', ext)

		-- Python version
		--local pythonVer = 'py2'
		local pythonVer = 'py3'
		
		-- Run FuScript
		local command = 'start "" "' .. fuscriptExecutable .. '" -l ' .. tostring(pythonVer) .. ' -i -x "from pprint import pprint;import BlackmagicFusion as bmd;fusion = bmd.scriptapp(\'\'\'Fusion\'\'\', \'\'\'localhost\'\'\');fu = fusion;app = fusion;comp = fusion.GetCurrentComp();print(\'\'\'[Python ' .. tostring(pythonVer) ..' Script] ' ..  tostring(filename) .. '\'\'\');" -l ' .. tostring(pythonVer) .. ' "' .. tostring(filename).. '" 2>&1 &' 
		
		print('[Launch Command] ',  command)
		local result = os.execute(command)
		print('[Result]')
		print(result)
	else
		print('[Open in Fusion Studio] To use this script you need to have a document like a .comp, .setting, .lua, or .py open in the foreground Notepad++ editing window.')
	end
end)
