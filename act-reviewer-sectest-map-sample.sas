/*
--------------------------------------------------------------------------------

Sample: act-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of act-reviewer-sectest-map.xml

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
ods html body='output/act-reviewer-sectest-data.html';

filename sectest "input/act-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "act-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

title1 "ACTs";
proc print data=sectest.acts;
run;

title1 "Group Permission Patterns for ACTs";
proc print data=sectest.actGroupPermissionPatterns;
run;

title1 "User Permission Patterns for ACTs";
proc print data=sectest.actUserPermissionPatterns;
run;

title1 "ACT Protected Objects";
proc print data=sectest.actProtectedObjects;
run;

title1 "ACT Protected ACTs";
proc print data=sectest.actProtectedACTs;
run;

title1 "ACT Protected Users";
proc print data=sectest.actProtectedUsers;
run;

title1 "ACT Protected Groups";
proc print data=sectest.actProtectedGroups;
run;

title1 "ACT Protected Roles";
proc print data=sectest.actProtectedRoles;
run;

title1 "ACTs applied to ACTs";
proc print data=sectest.actAppliedACTs;
run;

title1 "Group ACEs applied to ACTs";
proc print data=sectest.actAppliedGroupACEs;
run;

title1 "User ACEs applied to ACTs";
proc print data=sectest.actAppliedUserACEs;
run;

libname sectest;
filename map;
filename sectest;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;