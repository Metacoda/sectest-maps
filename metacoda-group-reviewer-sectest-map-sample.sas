/*
--------------------------------------------------------------------------------

Sample: metacoda-group-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of metacoda-group-reviewer-sectest-map.xml

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
ods html body='output/metacoda-group-reviewer-sectest-data.html';

filename sectest "input/metacoda-group-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "metacoda-group-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

title1 "Groups";
proc print data=sectest.groups;
run;

title1 "Direct Logins for Groups";
proc print data=sectest.groupDirectLogins;
run;

title1 "Indirect Logins for Groups";
proc print data=sectest.groupIndirectLogins;
run;

title1 "Logins (direct+indirect) for Groups";
proc print data=sectest.groupLogins;
run;

title1 "Direct Group Members for Groups";
proc print data=sectest.groupDirectGroupMembers;
run;

title1 "Direct User Members for Groups";
proc print data=sectest.groupDirectUserMembers;
run;

title1 "Indirect Group Members for Groups";
proc print data=sectest.groupIndirectGroupMembers;
run;

title1 "Indirect User Members for Groups";
proc print data=sectest.groupIndirectUserMembers;
run;

title1 "Group Members (direct+indirect) for Groups";
proc print data=sectest.groupGroupMembers;
run;

title1 "User Members (direct+indirect) for Groups";
proc print data=sectest.groupUserMembers;
run;

title1 "Direct Group Memberships for Groups";
proc print data=sectest.groupDirectGroupMemberships;
run;

title1 "Indirect Group Memberships for Groups";
proc print data=sectest.groupIndirectGroupMemberships;
run;

title1 "Group Memberships (direct+indirect) for Groups";
proc print data=sectest.groupGroupMemberships;
run;

title1 "Direct Role Memberships for Groups";
proc print data=sectest.groupDirectRoleMemberships;
run;

title1 "Indirect Role Memberships for Groups";
proc print data=sectest.groupIndirectRoleMemberships;
run;

title1 "Role Memberships (direct+indirect) for Groups";
proc print data=sectest.groupRoleMemberships;
run;

title1 "Capabilities for Groups";
proc print data=sectest.groupCapabilities;
run;

libname sectest;
filename map;
filename sectest;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;