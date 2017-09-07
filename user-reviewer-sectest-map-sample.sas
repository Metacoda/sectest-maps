/*
--------------------------------------------------------------------------------

Sample: user-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of user-reviewer-sectest-map.xml

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
ods html body='output/user-reviewer-sectest-data.html';

filename sectest "input/user-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "user-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

title1 "Users";
proc print data=sectest.users;
run;

title1 "Direct Logins for Users";
proc print data=sectest.userDirectLogins;
run;

title1 "Indirect Logins for Users";
proc print data=sectest.userIndirectLogins;
run;

title1 "Logins (direct+indirect) for Users";
proc print data=sectest.userLogins;
run;

title1 "Direct Group Memberships for Users";
proc print data=sectest.userDirectGroupMemberships;
run;

title1 "Indirect Group Memberships for Users";
proc print data=sectest.userIndirectGroupMemberships;
run;

title1 "Group Memberships (direct+indirect) for Users";
proc print data=sectest.userGroupMemberships;
run;

title1 "Direct Role Memberships for Users";
proc print data=sectest.userDirectRoleMemberships;
run;

title1 "Indirect Role Memberships for Users";
proc print data=sectest.userIndirectRoleMemberships;
run;

title1 "Role Memberships (direct+indirect) for Users";
proc print data=sectest.userRoleMemberships;
run;

* The capabilities table can be very large: #rows = #user * #capabilities;
title1 "Capabilities for Users";
proc print data=sectest.userCapabilities(obs=50);
run;

title1 "ACTs applied to Users";
proc print data=sectest.userAppliedACTs;
run;

title1 "Group ACEs applied to Users";
proc print data=sectest.userAppliedGroupACEs;
run;

title1 "User ACEs applied to Users";
proc print data=sectest.userAppliedUserACEs;
run;

libname sectest;
filename map;
filename sectest;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;