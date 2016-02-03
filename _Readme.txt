This is probably not at all efficient nor reliable
Known Bugs:
	In all text-boxes, must select "None" as the input-method (right-click)
	Copied everything that looked similar, rather than just the .dylib files
		(so this is probably HUGELY bloated)
	Doesn't pay attention to arguments (e.g. opening files probably won't work)

Compilation at this version was a bitch...
	I won't go into it... see the NOTES directory

This was originally _cTools/_Programming Notes/Something_Works5.app


-------
Round-Two... Running this as an app didn't load the file-jpg and whatnot libraries
So... created appDylibs.sh and ran it on plugins and modules...

And... I have no idea how it knows to reference the files in ./Resources/share
instead of /opt/local/share...

lucky again, I guess... It must be, because when I modified file-jpg in Resources/share, it fixed the problem...

-------
Much later, everything appears to work, until save-as jpg and others aren't listed

Open jpg works?! WTF 
Recap: Open jpg is OK, save-as is not (only xcf's listed as an option).

Also right-clicking jpg and open-with Gimp-2.8 works, despite args[] not showing the file. Interesting.

Other notes:
Info.plist references MacOS/gimp-2.8 which is a shell script that calls gimp-2.8.theRealThing

