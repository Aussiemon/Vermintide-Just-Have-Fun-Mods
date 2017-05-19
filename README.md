# Vermintide Just-Have-Fun Mod Collection
A collection of interesting Vermintide mods I've created, with no particular theme. 

Requires Grimalackt's quality-of-life modpack installed to function:

(https://www.reddit.com/r/Vermintide/search?sort=new&restrict_sr=on&q=flair%3ACustom%2BContent) 

----------------------------------------------------------------
Mod List:
----------------------------------------------------------------

**Krench Mutation** command (replace ogres with Krench) 

**Mission Stats** command (print # completions per level) 

**Skip Cutscenes** mod (skip all cutscenes with space or escape)  

**Size Tweaks** mod (control sizes of creatures and players)  


----------------------------------------------------------------
Full Setup Instructions:
----------------------------------------------------------------
0.	Unpack .zip file. Drag mods folder to \<game folder\>\binaries. Merge and overwrite existing files or folders.

1.	Open mods\Initialize.lua

2.	Add lines 

		Mods.exec("patch", "SkipCutscenes")
		Mods.exec("patch", "SizeTweaks")
    
	underneath "--Additional mods go here :" comment.

    **OPTIONAL:**   Open patch\SkipCutscenes.lua and change "display_warning = true" to false to not display a one-time warning upon skipping a mission cutscene.
	
    **OPTIONAL:**   Open patch\SizeTweaks.lua to modify creature and player sizes. By default, Krench and rat ogres are scaled by 1.5x for demonstration purposes.
	
    **KNOWN ISSUE:**   Cursor appears on screen until game is restarted if equipment chest is open when cutscene would've ended. Use /fixcursor command to hide.
	
3.	Open mods\CommandList.lua

4.	Add lines

		{"/krenchtation",	 false, 	"commands", 	"krenchtation"},
		{"/missionstats",	 false, 	"commands", 	"missionstats"},
		{"/fixcursor",	 false, 	"commands", 	"fixcursor"},
    
	to bottom of commands.
	
    **OPTIONAL:**   Open commands\missionstats.lua and change "send_all = true" to false to not print stats publicly.
    
    **KNOWN ISSUE:**  The chat window is small. Hold tab and use the Page Up / Page Down keys to navigate.
	
    **OPTIONAL:**   Open patch\SkipCutscenes.lua and change "display_warning = true" to false to not display a one-time warning upon skipping a mission cutscene.
	
5.	Use spacebar or escape in-game to skip cutscenes.



----------------------------------------------------------------
Individual Mod Instructions:
----------------------------------------------------------------

For **Krench Mutation** command (replace ogres with Krench):

1.	Open mods\CommandList.lua

2.	Add line 

		{"/krenchtation",	 false, 	"commands", 	"krenchtation"},
    
	to bottom of commands.
	
3.	In-game command is "/krenchtation" without quotes.

----------------------------------------------------------------

For **Mission Stats** command (print # completions per level):

1.	Open mods\CommandList.lua

2.	Add line 

		{"/missionstats",	 false, 	"commands", 	"missionstats"},
    
	to bottom of commands.

    **OPTIONAL:**   Open commands\missionstats.lua and change "send_all = true" to false to not print stats publicly.
    
    **KNOWN ISSUE:**  The chat window is small. Hold tab and use the Page Up / Page Down keys to navigate.
	
3.	In-game command is "/missionstats" without quotes.

----------------------------------------------------------------

For **Skip Cutscenes** mod (skip all cutscenes with space or escape):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SkipCutscenes")
    
	underneath "--Additional mods go here :" comment.

    **OPTIONAL:**   Open patch\SkipCutscenes.lua and change "display_warning = true" to false to not display a one-time warning upon skipping a mission cutscene.
	
3.	Open mods\CommandList.lua

4.	Add line 

		{"/fixcursor",	 false, 	"commands", 	"fixcursor"},
    
	to bottom of commands.
	
5.	Use spacebar or escape in-game to skip cutscenes.

    **KNOWN ISSUE:**   Cursor appears on screen until game is restarted if equipment chest is open when cutscene would've ended. Use /fixcursor command to hide.
	
----------------------------------------------------------------

For **Size Tweaks** mod (control sizes of creatures and players):

1.	Open mods\Initialize.lua

2.	Add line 

		Mods.exec("patch", "SizeTweaks")
    
	underneath "--Additional mods go here :" comment.

    **OPTIONAL:**   Open patch\SizeTweaks.lua to modify creature and player sizes. By default, Krench and rat ogres are scaled by 1.5x for demonstration purposes.

----------------------------------------------------------------