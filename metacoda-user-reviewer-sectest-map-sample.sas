/*
--------------------------------------------------------------------------------

Sample: metacoda-user-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of metacoda-user-reviewer-sectest-map.xml

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

ods listing close;
ods html body='output/user-reviewer-complete.html';

filename sectest "input/metacoda-user-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "metacoda-user-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

title1 "Users";
proc print data=sectest.users;
run;

title1 "User Direct Logins";
proc print data=sectest.userDirectLogins;
run;

title1 "User Indirect Logins";
proc print data=sectest.userIndirectLogins;
run;

title1 "User Logins (direct+indirect)";
proc print data=sectest.userLogins;
run;

title1 "User Group Direct Memberships";
proc print data=sectest.userDirectGroups;
run;

title1 "User Group Indirect Memberships";
proc print data=sectest.userIndirectGroups;
run;

title1 "User Group Memberships (direct+indirect)";
proc print data=sectest.userGroups;
run;

title1 "User Role Direct Memberships";
proc print data=sectest.userDirectRoles;
run;

title1 "User Role Indirect Memberships";
proc print data=sectest.userIndirectRoles;
run;

title1 "User Role Memberships (direct+indirect)";
proc print data=sectest.userRoles;
run;

title1 "User Capabilities";
proc print data=sectest.userCapabilities;
run;

libname sectest;
filename map;
filename sectest;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;