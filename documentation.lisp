(in-package #:org.shirakumo.open-with)

(docs:define-docs
  (variable *file-type-associations*
    "A hash table associating file extension types to handlers.

You may set entries in this table with keys being PATHNAME-TYPEs and
values being handlers as specified by RUN-HANDLER.

See RUN-HANDLER
See OPEN")
  
  (variable *url-schema-associations*
    "A hash table associating url schemas to handlers.

You may set entries in this table with keys being URL schemas and
values being handlers as specified by RUN-HANDLER.

See RUN-HANDLER
See OPEN")
  
  (variable *default-file-handler*
    "The default handler for files when no specific one is set.

You may set this to any handler as specified by RUN-HANDLER.

See *FILE-TYPE-ASSOCIATIONS*
See RUN-HANDLER
See OPEN")
  
  (variable *default-url-handler*
    "The default handler for URLs when no specific one is set.

You may set this to any handler as specified by RUN-HANDLER.

See *URL-SCHEMA-ASSOCIATIONS*
See RUN-HANDLER
See OPEN")

  (function external-open-with-fun
    "Create a handler for an external program.

An external program with the given name is searched for in directories
listed in the PATH environment variable (on Windows with the .exe
suffix). If none can be found, an error is signalled. If one can be
found, a function suitable for RUN-HANDLER is returned that will
create a process for the program to open the THING with. When starting
the program, ARGS are provided as command-line arguments to the
program, with the THING to open as the last argument appended on.

See RUN-HANDLER")
  
  (function run-handler
    "Run a handler for the THING with the given arguments.

HANDLER can be one of the following:

  HANDLER ::= symbol
            | function
            | program
            | (option+)
  program ::= string
  option  ::= symbol
            | function
            | program
            | (program string*)

Where OPTIONs are potential handlers that are tried in sequence until
one that does not error appears. If none of the options run without
error, an error is signalled at the end.

In the case of SYMBOLs and FUNCTIONs, the designated lisp function is
simply invoked with THING and ARGS. In the case of PROGRAMs, a handler
function is constructed via EXTERNAL-OPEN-WITH-FUN

In all cases ARGS should be a keyword argument list, and whatever
handler must accept any keyword argument, though may ignore all of
them. The only specified keyword argument is BACKGROUND which, if
true, specifies that the handler should be run in the background and
the function should return immediately.

See EXTERNAL-OPEN-WITH-FUN")
  
  (function open
    "Attempts to open THING for viewing or editing.

Users may add methods to this function to customise the behhaviour for
other types. A default implementation for PATHNAMEs and STRINGs is
provided, which invokes a file handler for pathnames and strings
unless the string starts with an URL schema, in which case a url
handler is invoked instead.

For files, if the pathname has a type, a corresponding handler is
looked up in the *FILE-TYPE-ASSOCIATIONS* table. If it is a directory,
the handler is looked up by the :DIRECTORY key. Otherwise it is looked
up by the :FILE key. If no custom handler is set, the
*DEFAULT-FILE-HANDLER* is used.

For URLs, a corresponding handler is looked up in the
*URL-SCHEMA-ASSOCIATIONS* table. If no custom handler is set, the
*DEFAULT-URL-HANDLER* is used.

Whatever the case, the chosen handler is then invoked on THING and
ARGS via the RUN-HANDLER function.

See *FILE-TYPE-ASSOCIATIONS*
See *URL-SCHEMA-ASSOCIATIONS*
See *DEFAULT-FILE-HANDLER*
See *DEFAULT-URL-HANDLER*
See RUN-HANDLER"))
