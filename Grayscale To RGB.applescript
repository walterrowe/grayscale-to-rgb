(*

  Original: Walter Rowe in 2023

  A droplet created from this AppleScript works like any other macOS app. You can
  drag-n-drop files onto it in Finder or double-click it and choose files to convert.

*)

use AppleScript version "2.7"
use scripting additions
use framework "Foundation"

(* TO FILTER FOR IMAGE FILES, LOOK FOR QUICKTIME SUPPORTED IMAGE FORMATS *)
property type_list : {"JPEG", "TIFF", "PNGf", "8BPS", "BMPf", "GIFf"}
property extension_list : {"jpg", "jpeg", "tif", "tiff", "png", "psd", "bmp", "gif"}
property typeIDs_list : {"public.jpeg", "public.tiff", "public.png", "com.adobe.photoshop-image", "com.microsoft.bmp", "com.compuserve.gif", "com.adobe.pdf", "com.apple.pict"}
property dropletName : "Grayscale To RGB"
property sipsOptions : "eval $(/usr/libexec/path_helper -s); sips -M /System/Library/ColorSync/Profiles/AdobeRGB1998.icc relative "

-- split a string based on a specific delimiter
on joinText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText as string
	set AppleScript's text item delimiters to ""
	return theTextItems
end joinText

-- split a string based on a specific delimiter
on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText

-- "on run" executes when you double-click a droplet in Finder
on run
	-- convert "path:to:me.app:" into "me" (apps are folders so note the trailing colon thus the -2 below)
	set appPath to path to me as string
	set appName to item -1 of splitText(appPath, ":")
	if appName is "" then set appName to item -2 of splitText(appPath, ":")
	
	-- if we are running as the name "CreateStyleDroplets", create a droplet for all the known styles
	if appName is (dropletName & ".applescript") then
		createAppFromAppleScript()
	else
		-- styleList will be false if 'Cancel' pressed on choose from list
		set selected_items to choose file with prompt "Select the images to convert:" of type {"public.image"} with multiple selections allowed
		process_items(selected_items)
	end if
end run

-- "on open" processes items dropped onto it in Finder or sent to it via "open app with parameters"
on open dropped_items
	-- get desired frame_it options based on invoked app name
	process_items(dropped_items)
end open

-- create the frame_it commands and execute them
on process_items(the_items)
	
	repeat with this_item in the_items
		set thePath to quoted form of POSIX path of this_item
		set theFold to joinText(items 1 thru ((count of splitText(thePath, "/")) - 1) of splitText(thePath, "/"), "/")
		set theName to item -1 of splitText(thePath, "/")
		if theName is "" then set theName to item -2 of splitText(thePath, "/")
		set theBase to item 1 of splitText(theName, ".")
		set theExt to item 2 of splitText(theName, ".")
		
		set theOut to theFold & "/" & theBase & "RGB." & theExt
		
		-- get the POSIX path of the current file we are processing
		set this_path to quoted form of POSIX path of this_item
		
		-- build the frame_it command line
		set sips_command to sipsOptions & " -o " & theOut & " " & this_path
		
		-- run frame_it on the named file
		try
			do shell script sips_command
		on error errStr number errorNumber
			display dialog "Droplet ERROR: " & errStr & ": " & (errorNumber as text) & "on file " & this_filename
		end try
	end repeat
end process_items

-- create the style droplets
on createAppFromAppleScript()
	
	-- select the droplet folder and droplet script with Finder 
	set dropletFolder to POSIX path of (choose folder with prompt "Select the folder for " & dropletName & ":")
	set dropletChoice to choose file with prompt "Select the " & dropletName & " applescript" default location POSIX path of (path to me)
	set dropletSource to the POSIX path of dropletChoice
	
	set iconSource to splitText(dropletSource, "/") as list
	set iconSource to items 1 thru -2 of iconSource
	set iconSource to joinText(iconSource, "/") & "/droplet.icns"
	
	-- set destination droplet name
	set droplet to dropletFolder & dropletName & ".app"
	
	set iconTarget to droplet & "/Contents/Resources/"
	
	-- set shell command to create the droplet
	set createDroplet to "osacompile -x -o " & quoted form of droplet & " " & quoted form of dropletSource
	set copyIcon to "/bin/cp " & quoted form of iconSource & " " & quoted form of iconTarget
	
	-- build the droplet
	try
		do shell script createDroplet
	on error errStr number errorNumber
		display dialog "Droplet ERROR: " & errStr & ": " & (errorNumber as text) & "on file " & droplet
	end try
	
	-- copy the app icon into the app folder
	try
		do shell script copyIcon
	on error errStr number errorNumber
		display dialog "Droplet ERROR: " & errStr & ": " & (errorNumber as text) & "on file " & droplet
	end try
	
	-- show the user the new app
	do shell script "open " & ("'" & dropletFolder & "'")
	
end createAppFromAppleScript