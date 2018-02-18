## Grimes Crate Filler

The Grimes Crate Filler script is an old-fashioned Ammo Crate Refill script for ArmA 3, including modular use of all weapons, attachments, magazines, items, clothing, bags, and much more!

This package includes an application of the script as part of an example mission. 

This README is intended to provide detailed information as to the purpose, function, FAQs, and minor troubleshooting for this script in addition to installation, uninstallation, and maintenance tips. For further information or specifics in the code, the user should read the comments to the code within the script files. 

## Author Information

Kent “KC” Grimes of Austin, Texas, United States is the author of the Grimes Crate Filler. The script was made in order to provide mission makers a user-friendly means of customizing an ammo crate.

The purpose of this script is to provide a way for the mission maker to customize ammo crates in order to make their mission unique and as generalized or as focused as they would like. 

BI Forums Topic: https://forums.bohemia.net/forums/topic/161393-grimes-crate-filler-script/

## Installation

At this time, there is no “installer” for the script, and it is instead a simple series of actions and file moves.  

1. Obtain the script files
	1. github: https://github.com/kcgrimes/grimes-crate-filler
	1. Armaholic: http://www.armaholic.com/page.php?id=24116
2. Simply copy the file "G_Occupation.sqf" into your mission directory
3. In the ArmA 3 editor, place an ammo crate found in the Empty -> Ammo section. 
4. In the crate's Init field, type the following command:

```
nul = [this] execVM "G_crate.sqf";
```

Parameters:  
Basic Settings:  
_Wpncount                = 10;   //Quantity of each weapon/launcher to be spawned  
_Ammocount               = 50;   //Quantity of each type of ammunition/explosive to be spawned  
_Itemcount               = 10;   //Quantity of each type of item (gadgets, attachments, etc)  
_Clothingcount           = 3;    //Quantity of each type of uniform/hat/helmet/glasses (suggested to keep small due to not being stackable)  
_Bagcount                = 3;    //Quantity of each type of bag/vest item (suggested to keep small due to not being stackable)  
_Refresh                 = 600;  //Amount of time until crate empties/refills (seconds), 0 is no refresh  

Advanced Settings:  
_NATO_Weapons              = 1; //All weapons seen as BLUFOR weapons  
_OPFOR_Ind_Weapons         = 1; //All weapons seen as OPFOR and Independent weapons  
_Mixed_Weapons             = 1; //All weapons found in BLUFOR, OPFOR, and Independent arsenals  
_Base_Weapons              = 1; //All weapons selected above will only be base/stock variants with no attachments (see attachments parameter)  
_Weapon_Ammo               = 1; //All ammunition used by any weapons pulled from above parameters  
_NATO_Launchers            = 1; //All rocket/missile launchers seen as BLUFOR launchers  
_OPFOR_Ind_Launchers       = 1; //All rocket/missile launchers seen as OPFOR and Independent launchers  
_NATO_Launcher_Ammo        = 1; //All ammunition used by BLUFOR rocket/missile launchers  
_OPFOR_Ind_Launcher_Ammo   = 1; //All ammunition used by OPFOR and Independent rocket/missile launchers  
_Plantable_Explosives      = 1; //All plantable explosive devices (mines, charges, etc.) (not sorted by faction)  
_Grenade_Launcher_Ammo     = 1; //All grenade launcher ammo  
_Throwables                = 1; //All throwable munitions (smokes, grenades, chemlights)  
_Attachments               = 1; //All weapon attachments (not sorted by faction)  
_Items                     = 1; //All items (gadgets, kits, binocs, rangefinder, laser designator, anything else on player that is not a bag or weapon)  
_Headgear                  = 1; //All hats and helmets  
_Glasses_Goggles           = 1; //All glasses and goggles (currently unsupported by BIS)  
_BLUFOR_Uniforms           = 1; //All BLUFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)  
_OPFOR_Uniforms            = 1; //All OPFOR uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)  
_Independent_Uniforms      = 1; //All Independent uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)  
_Civilian_Uniforms         = 1; //All Civilian uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)  
_Guerilla_Uniforms         = 1; //All Guerilla uniforms, which are hit and miss for who can wear them, but mostly follow the name's indication (too many exceptions to split)  
_Other_Uniforms            = 1; //All Other uniforms (Note: Can only wear the uniforms of the player's faction, though Civilian can wear most all uniforms)  
_Vests                     = 1; //All vests and chest rigs  
_Bags                      = 1; //All empty, normal backpacks  
_Preset_Bags               = 1; //All preset bags (normal bags containing a preset of items, such as First Aid Kits and Explosives, which are already found elsewhere in the crate)  
_Assemble_Bags             = 1; //All backpacks that lack cargo but can be used or combined with another bag to assemble a static weapon

Notes/Tips:
* To keep an entity from spawning, simply comment it out by adding // at the beginning of the line (comment out)
* Read the extra comments if you are confused about something, or contact me on the forums or via e-mail
* Unfortunately as of the release of this script the crate sorting system in A3 isn't so great. Here's what you need to know.
	* All - Displays all items spawned into the crate
	* Weapons - Only weapons, launchers, and all bags (not vests)
	* Magazines - Only magazines, throwables, launchables, plantables, and all bags (not vests)
	* Items - Only attachments, gadgets, items, kits, hat/helmets, uniforms, vests, and all bags
	* This is why I suggest you keep the bag/uniform/vest/hat count low, as it is very cluttery. Sorry!
* Uniforms and vests have a commented number to the right of the classname. This indicates their capacity. Capacity for all bags was said to me 1 weapon, 13 magazines.
* Players can only wear uniforms of their faction
* Although it is possible to spawn everything into the crate, it is not recommended in Multiplayer due to lag. However, default settings and under will only cause an extra second of loading.
* All of the recommended limitations can be experimented with, of course. Make your mission as good as it can be!

## Documentation

This README is intended to provide detailed information as to the purpose, function, FAQs, and minor troubleshooting for this script in addition to installation, uninstallation, and maintenance tips. For further information or specifics in the code, the user should read the comments to the code within the script files. Any further questions or comments can be directed to the author. 

## Tests

The script is designed to exit upon critical failure and it will attempt to announce the problem in chat. These types of failures are intended for development, and should never be encountered down the road if they were not encountered at launch, save for software updates. Upon setup or completion of modifications, it is recommended that the user, before launch, run the script in a test environment.

## Contributors

Contributions are welcomed and encouraged. Please follow the below guidelines:
* Use the Pull Request feature
* Document any additional work
* Provide reasonable commit history comments
* Test all modifications locally and online

## License

MIT License

Copyright (c) 2014-2018 Kent "KC" Grimes. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
