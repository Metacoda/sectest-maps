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

filename sectest "input/role-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "role-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.roles as select * from sectest.roles;
create table work.roleDirectMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName
   from work.roles m, sectest.roleDirectGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName
   from work.roles m, sectest.roleDirectUserMembers d
   where m.key = d.key
order by key, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.roleIndirectMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.roles m, sectest.roleIndirectGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.roles m, sectest.roleIndirectUserMembers d
   where m.key = d.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.roleMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.roles m, sectest.roleGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.roles m, sectest.roleUserMembers d
   where m.key = d.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.roleDirectContributions as
   select m.key, m.repoName, m.name, d.targetRoleRepoName, d.targetRoleName
   from work.roles m, sectest.roleDirectContributions d
   where m.key = d.key
;
create table work.roleIndirectContributions as
   select m.key, m.repoName, m.name, d.targetRoleRepoName, d.targetRoleName, d.level
   from work.roles m, sectest.roleIndirectContributions d
   where m.key = d.key
;
create table work.roleContributions as
   select m.key, m.repoName, m.name, d.targetRoleRepoName, d.targetRoleName, d.level
   from work.roles m, sectest.roleContributions d
   where m.key = d.key
;
create table work.roleDirectContributingRoles as
   select m.key, m.repoName, m.name, d.sourceRoleRepoName, d.sourceRoleName
   from work.roles m, sectest.roleDirectContributingRoles d
   where m.key = d.key
;
create table work.roleIndirectContributingRoles as
   select m.key, m.repoName, m.name, d.sourceRoleRepoName, d.sourceRoleName, d.level
   from work.roles m, sectest.roleIndirectContributingRoles d
   where m.key = d.key
;
create table work.roleContributingRoles as
   select m.key, m.repoName, m.name, d.sourceRoleRepoName, d.sourceRoleName, d.level
   from work.roles m, sectest.roleContributingRoles d
   where m.key = d.key
;
create table work.roleCapabilities as
   select m.key, m.repoName, m.name, d.folder, d.capabilityName, d.isGranted
   from work.roles m, sectest.roleCapabilities d
   where m.key = d.key
;
create table work.roleAppliedACTs as
   select m.key, m.repoName, m.name, d.appliedACTRepoName, d.appliedACTName
   from work.roles m, sectest.roleAppliedACTs d
   where m.key = d.key
;
create table work.roleAppliedACEs as
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.roles m, sectest.roleAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.roles m, sectest.roleAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/role-reviewer-sectest-data.html';

title1 "Roles";
proc print data=work.roles;
run;

title1 "Direct Members for Roles";
proc print data=work.roleDirectMembers;
run;

title1 "Indirect Members for Roles";
proc print data=work.roleIndirectMembers;
run;

title1 "Members (direct+indirect) for Roles";
proc print data=work.roleMembers;
run;

title1 "Direct Role Contributions";
proc print data=work.roleDirectContributions;
run;

title1 "Indirect Role Contributions";
proc print data=work.roleIndirectContributions;
run;

title1 "Role Contributions (direct+indirect)";
proc print data=work.roleContributions;
run;

title1 "Direct Contributing Roles";
proc print data=work.roleDirectContributingRoles;
run;

title1 "Indirect Contributing Roles";
proc print data=work.roleIndirectContributingRoles;
run;

title1 "Contributing Roles (direct+indirect)";
proc print data=work.roleContributingRoles;
run;

* The capabilities table can be very large: #rows = #roles * #capabilities;
title1 "Capabilities for Roles";
proc print data=work.roleCapabilities(obs=500);
run;

title1 "ACTs applied to Roles";
proc print data=work.roleAppliedACTs;
run;

title1 "ACEs applied to Roles";
proc print data=work.roleAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;