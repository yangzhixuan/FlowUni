# Discover the projects that use CMake in the subdirectories.
# Note that explicit cmake invocation is required every time a new project is
# added or removed.
file(GLOB entries *)
add_subdirectory("WatchDog")
add_subdirectory("leakplug")
#foreach(entry ${entries})
#  if(IS_DIRECTORY ${entry} AND EXISTS ${entry}/CMakeLists.txt)
#    add_subdirectory(${entry})
#  endif()
#endforeach(entry)
