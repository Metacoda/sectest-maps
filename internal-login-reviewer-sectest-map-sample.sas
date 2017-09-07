/*
--------------------------------------------------------------------------------

Sample: internal-login-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of internal-login-reviewer-sectest-map.xml

Authors:
* Paul Homes <paul.homes@metacoda.com>

--------------------------------------------------------------------------------

Copyright 2017 Metacoda Pty Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--------------------------------------------------------------------------------
*/

filename sectest "input/internal-login-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "internal-login-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.internalLogins as select * from sectest.internalLogins;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/internal-login-reviewer-sectest-data.html';

title1 "Internal Logins";
proc print data=work.internalLogins;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;