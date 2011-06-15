# -*- cmake -*-
#
# Utility macros for getting info from the version control system.

# @return the rev number ie from the change set
macro(vcs_get_revision _output_variable)
	MESSAGE(STATUS "Checking for Mercurial repository ${PROJECT_SOURCE_DIR}")
	
	# Check for the hg directory to see if this is a hg repo
	IF(IS_DIRECTORY "${PROJECT_SOURCE_DIR}/../.hg")
		# Find the hg executable for mac by bundle or by path and system path look everywhere!
		FIND_PROGRAM(_hg hg [PATH CMAKE_SYSTEM_PROGRAM_PATH CMAKE_SYSTEM_APPBUNDLE_PATH])
		
		# Test the return status make sure its found
		IF(NOT ${_hg} MATCHES "-NOTFOUND")
			# Output HG success
			MESSAGE(STATUS "Found hg!")
			
			# Grab the revision number
			EXECUTE_PROCESS(COMMAND ${_hg} id -n WORKING_DIRECTORY 
			"${PROJECT_SOURCE_DIR}" OUTPUT_VARIABLE _release 
			RESULT_VARIABLE hg_result
			OUTPUT_STRIP_TRAILING_WHITESPACE
			ERROR_STRIP_TRAILING_WHITESPACE)
			
			if (hg_result EQUAL 0)
				# Strip out the + from the result. + indicates uncommitted changes.
				string(REGEX REPLACE \\+ "" _release ${_release})

				# not using CPACK yet for installing. This is prep work for CPACK
				#set(CPACK_PACKAGE_VERSION_PATCH ${_release})
		
				# set Rev number.
				set(PHOENIX_WC_REVISION ${_release})
			ELSE ()
				# give feedback and set the rev to 0
				MESSAGE("Mercurial had an error. Setting revision to zero.")
				SET(PHOENIX_WC_REVISION 0)
			ENDIF ()
		ELSE()
			# give feedback and set the rev to 0
			MESSAGE("Could not find Mercurial. Setting revision to zero.")
			SET(PHOENIX_WC_REVISION 0)
		ENDIF()
	ELSE()
		# give feedback and set the rev to 0 as teh dirs not found
		MESSAGE(STATUS "Mercurial not used..")
		SET(PHOENIX_WC_REVISION 0)
	ENDIF()
	 
	# CPACK framework
	#SET(PHOENIX_PACKAGE_VERSION ${V_MAJOR}.${V_MINOR}.${V_PATCH})
	
	# Dev build number framework.
	#SET(PHOENIX_DEVELOPMENT_VERSION 1)
	
	# Show the version number and complete / return to utility script.
	MESSAGE(STATUS "Current Mercurial revision is ${PHOENIX_WC_REVISION}")
	set(${_output_variable} ${PHOENIX_WC_REVISION})
endmacro(vcs_get_revision)