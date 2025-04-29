target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        ObjectManager.h
        ObjectManager.cc
        ObjectItem.h
        ObjectItem.cc

)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

