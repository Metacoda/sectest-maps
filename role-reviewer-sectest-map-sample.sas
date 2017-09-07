/*
--------------------------------------------------------------------------------

Sample: role-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of role-reviewer-sectest-map.xml

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
ods html body='output/role-reviewer-sectest-data.html';

filename sectest "input/role-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "role-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

title1 "Roles";
proc print data=sectest.roles;
run;

title1 "Direct Group Members for Roles";
proc print data=sectest.roleDirectGroupMembers;
run;

title1 "Direct User Members for Roles";
proc print data=sectest.roleDirectUserMembers;
run;

title1 "Indirect Group Members for Roles";
proc print data=sectest.roleIndirectGroupMembers;
run;

title1 "Indirect User Members for Roles";
proc print data=sectest.roleIndirectUserMembers;
run;

title1 "Group Members (direct+indirect) for Roles";
proc print data=sectest.roleGroupMembers;
run;

title1 "User Members (direct+indirect) for Roles";
proc print data=sectest.roleUserMembers;
run;

title1 "Direct Role Contributions";
proc print data=sectest.roleDirectContributions;
run;

title1 "Indirect Role Contributions";
proc print data=sectest.roleIndirectContributions;
run;

title1 "Role Contributions (direct+indirect)";
proc print data=sectest.roleContributions;
run;

title1 "Direct Contributing Roles";
proc print data=sectest.roleDirectContributingRoles;
run;

title1 "Indirect Contributing Roles";
proc print data=sectest.roleIndirectContributingRoles;
run;

title1 "Contributing Roles (direct+indirect)";
proc print data=sectest.roleContributingRoles;
run;

* The capabilities table can be very large: #rows = #roles * #capabilities;
title1 "Capabilities for Roles";
proc print data=sectest.roleCapabilities(obs=50);
run;

title1 "ACTs applied to Roles";
proc print data=sectest.roleAppliedACTs;
run;

title1 "Group ACEs applied to Roles";
proc print data=sectest.roleAppliedGroupACEs;
run;

title1 "User ACEs applied to Roles";
proc print data=sectest.roleAppliedUserACEs;
run;

libname sectest;
filename map;
filename sectest;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;