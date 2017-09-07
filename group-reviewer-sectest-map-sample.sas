/*
--------------------------------------------------------------------------------

Sample: group-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of group-reviewer-sectest-map.xml

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

filename sectest "input/group-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "group-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.groups as select * from sectest.groups;
create table work.groupDirectLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.groups m, sectest.groupDirectLogins d
   where m.key = d.key
;
create table work.groupIndirectLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.groups m, sectest.groupIndirectLogins d
   where m.key = d.key
;
create table work.groupLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.groups m, sectest.groupLogins d
   where m.key = d.key
;
create table work.groupDirectMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName
   from work.groups m, sectest.groupDirectGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName
   from work.groups m, sectest.groupDirectUserMembers d
   where m.key = d.key
order by key, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.groupIndirectMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.groups m, sectest.groupIndirectGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.groups m, sectest.groupIndirectUserMembers d
   where m.key = d.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.groupMembers as
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.groups m, sectest.groupGroupMembers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.memberIdentityRepoName, d.memberIdentityPublicType, d.memberIdentityName, d.level
   from work.groups m, sectest.groupUserMembers d
   where m.key = d.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.groupDirectGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName
   from work.groups m, sectest.groupDirectGroupMemberships d
   where m.key = d.key
;
create table work.groupIndirectGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName, d.level
   from work.groups m, sectest.groupIndirectGroupMemberships d
   where m.key = d.key
;
create table work.groupGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName, d.level
   from work.groups m, sectest.groupGroupMemberships d
   where m.key = d.key
;
create table work.groupDirectRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName
   from work.groups m, sectest.groupDirectRoleMemberships d
   where m.key = d.key
;
create table work.groupIndirectRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName, d.level
   from work.groups m, sectest.groupIndirectRoleMemberships d
   where m.key = d.key
;
create table work.groupRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName, d.level
   from work.groups m, sectest.groupRoleMemberships d
   where m.key = d.key
;
create table work.groupCapabilities as
   select m.key, m.repoName, m.name, d.folder, d.capabilityName, d.isGranted
   from work.groups m, sectest.groupCapabilities d
   where m.key = d.key
;
create table work.groupAppliedACTs as
   select m.key, m.repoName, m.name, d.appliedACTRepoName, d.appliedACTName
   from work.groups m, sectest.groupAppliedACTs d
   where m.key = d.key
;
create table work.groupAppliedACEs as
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.groups m, sectest.groupAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.groups m, sectest.groupAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/group-reviewer-sectest-data.html';

title1 "Groups";
proc print data=work.groups;
run;

title1 "Direct Logins for Groups";
proc print data=work.groupDirectLogins;
run;

title1 "Indirect Logins for Groups";
proc print data=work.groupIndirectLogins;
run;

title1 "Logins (direct+indirect) for Groups";
proc print data=work.groupLogins;
run;

title1 "Direct Members for Groups";
proc print data=work.groupDirectMembers;
run;

title1 "Indirect Members for Groups";
proc print data=work.groupIndirectMembers;
run;

title1 "Members (direct+indirect) for Groups";
proc print data=work.groupMembers;
run;

title1 "Direct Group Memberships for Groups";
proc print data=work.groupDirectGroupMemberships;
run;

title1 "Indirect Group Memberships for Groups";
proc print data=work.groupIndirectGroupMemberships;
run;

title1 "Group Memberships (direct+indirect) for Groups";
proc print data=work.groupGroupMemberships;
run;

title1 "Direct Role Memberships for Groups";
proc print data=work.groupDirectRoleMemberships;
run;

title1 "Indirect Role Memberships for Groups";
proc print data=work.groupIndirectRoleMemberships;
run;

title1 "Role Memberships (direct+indirect) for Groups";
proc print data=work.groupRoleMemberships;
run;

* The capabilities table can be very large: #rows = #groups * #capabilities;
title1 "Capabilities for Groups";
proc print data=work.groupCapabilities(obs=500);
run;

title1 "ACTs applied to Groups";
proc print data=work.groupAppliedACTs;
run;

title1 "ACEs applied to Groups";
proc print data=work.groupAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;