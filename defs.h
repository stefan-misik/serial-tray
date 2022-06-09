#ifndef DEFS_H_
#define DEFS_H_

/* Stringification */
#define DEFS_STRINGIFY(s) DEFS_STRINGIFYX(s)
#define DEFS_STRINGIFYX(s) #s

/* Project version*/
#define PROJECT_VER_1           1
#define PROJECT_VER_2           0
#define PROJECT_VER_3           0

#define PROJECT_EXE             "serial-tray"
#define PROJECT_VER             "v" DEFS_STRINGIFY(PROJECT_VER_1) "."     \
                                    DEFS_STRINGIFY(PROJECT_VER_2) "."     \
                                    DEFS_STRINGIFY(PROJECT_VER_3)
#define PROJECT_NAME            "Serial Tray"
#define PROJECT_AUTHOR          "Stefan Misik"
#define PROJECT_DESC            "Tool to list the serial ports"
#define PROJECT_CPYR            "Copyright (C) 2022 " PROJECT_AUTHOR

#define PROJECT_WEB "https://github.com/stefan-misik/serial-tray"

#endif  // DEFS_H_
