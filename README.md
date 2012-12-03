bashlib
=======

   Bash Shell Script Library


## Description
   The "bashlib" library is a collection of functions to deal with date, time, lists, some network operations, numbers, output formatting and system gathering info.
   Note that "bashlib" is in an early development stage, so please reconsider visiting it.
   Scripting is really powerful and important for system administrators, providing smarter and automated controlling.
   Bash is a powerful shell and has many built-in functions. But depending on the case, they are not enough.
   The "bashlib was created after a need for date, time and number operations, mainly conversions, file retrieval and sending, simple server checks, results formatting and validations."

## Usage
   In order to use "bashlib" from your script you have to source "bashlib.bash", by using "." or "source" builtin bash function, providing the right relative or absolute path.
   When you source "bashlib.bash" it provides you two functions: "load" and "unload".
   "load" allows you to use a specific function, for example, if you need "normalizeNumber" function you have to insert a line like "load numbers.normalizeNumber" before calling it. It will automatically source the corresponding function file from "pool" directory.
   "unload" allows you the way to get rid of all bashlib functions loaded, so they become unavailable.
   

## Specs
* The following Operating Systems are supported:
   * CentOS 5.5 or above
   * Debian 5.0 or above
   * MacOS X 10.6 or above
   * RedHat Enterprise 5.5 or above
   * Ubuntu 10.04 or above
* Languages:
   * Shell Script (Bash)
* Dependencies:
   * awk (using gawk)
   * bash (3.2 or above)
   * bc
   * cut
   * date
   * grep
   * sed
   * uname

## Notes
   The supported operating systems were tested with their default tools, i.e., it should work as is because it does not use extra tools.

## Recommendations
   After downloading "bashlib" it is recommended that you:
   - Copy the entire folder to somewhere from your HOME folder;
   - Save the files;
   - Check the permissions:
      - For libraries, 644 (-rw-r--r--)
      - For test executables, 755 (-rwxr-xr-x)

## Contribute
   Feel free to contribute, fork and help improve bashlib.

## Contributors
   - Paulo Pernomian - Creator - [GitHub](https://github.com/pernomian)
   - Fernando A. Damião - Tester, System - [GitHub](https://github.com/fadamiao)


License Information
===================

Copyright (c) 2012, Paulo Pernomian.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

* Neither the name of Paulo Pernomian nor the names of its
contributors may be used to endorse or promote products derived from this
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
