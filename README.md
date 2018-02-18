## Grimes Crate Filler

The Grimes Crate Filler script is an old-fashioned Ammo Crate Refill script for ArmA 3, including all weapons, magazines, items, clothing, and bags.

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
3. In the ArmA 3 editor, place the Supply Box (NATO) ammo crate found in the Empty -> Ammo section. 
4. In the crate's Init field, type the following command:

```
nul = [this] execVM "G_crate.sqf";
```

Notes/Tips:
* To keep an entity from spawning, simply comment it out by adding // at the beginning of the line (comment out)
* Read the extra comments if you are confused about something, or contact me on the forums or via e-mail
* Unfortunately as of the release of this script the crate sorting system in A3 isn't so great. Here's what you need to know.
	* All - Displays all items spawned into the crate
	* Weapons - Only weapons, launchers, and all bags (not vests)
	* Magazines - Only magazines, throwables, launchable, plantables, and all bags (not vests)
	* Items - Only attachments, gadgets, items, kits, hat/helmets, uniforms, vests, and all bags
	* This is why I suggest you keep the bag/uniform/vest/hat count low, as it is very cluttery. Sorry!
* Uniforms and vests have a commented number to the right of the classname. This indicates their capacity. Capacity for all bags was said to me 1 weapon, 13 magazines.
* Players can only wear uniforms of their faction
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