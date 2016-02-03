#!/bin/bash

# For an OSX application-bundle
# We need to modify the executables to reference local dylibs instead of
# system-wide (usually in /opt/local/lib)
# Per: http://stackoverflow.com/questions/1596945/building-osx-app-bundle


# So this was called on each directory with executables (e.g. plugins and
#  modules) then at the end was called as, explicitely:
# for file in /Applications/Gimp-2.8\ copy.app/Contents/MacOS/*.dylib ; \
# do \
#	appDylibs.sh "$file" ; \
# done

executable="$1"

dylibs=`otool -L "$executable"`

IFS="
"

for dylib in $dylibs
do
	# Strip the leading spaces... 
	dylib="${dylib##[[:blank:]]}"
	# Strip the version information in parentheses and the leading spaces
	dylib="${dylib%%[[:blank:]]\(*\)}"

	echo "'$dylib'"

	# Look for dylibs in /opt/local/lib...
	optlocallibstripped="${dylib#"/opt/local/lib/"}"
	#optlocallibstripped="${dylib#"@executable_path/"}"

	# If they're not in /opt/local/lib, then skip 'em.
	if [ "$optlocallibstripped" == "$dylib" ]
	then
		continue
	fi

#optlocallibstripped="${optlocallibstripped%%[[:blank:]]\(*\)}"
	echo "    '$optlocallibstripped'"

	# At this point we have 'libWhatever.dylib'

	# The recommended method is to use @executable_path/
	#  but as far as I'm aware, this means the dylibs this depends on
	#  have to be located in the same directory as this executable
	# Fine for the main application, but not good for the plugins in the
	#  plugins directory, because gimp will try to load the dylibs as though
	#  they are plugins (nogo)

	# As/of the loading-script, the current-working-directory is set to
	# Gimp2.8.app/Contents/MacOS
	# So move the dylibs used by the plugin there, as well...
	# (and reference it as ./)
	workingDir="${executable%%.app/Contents*}.app/Contents/MacOS/"
	#echo "     '$workingDir'"

	# *seems* to work. And has the benefit that the dylibs that are shared
	# with the gimp executable instead of having multiple copies
	# Also, "@executable_path" is longer than "/opt/local/lib" which is
   #  supposedly a bad thing (though I guess I lucked out)	
	install_name_tool -change "$dylib" \
		"./$optlocallibstripped" "$executable"

	cp "$dylib" "$workingDir"
done
