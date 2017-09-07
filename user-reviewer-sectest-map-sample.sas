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

filename sectest "input/user-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "user-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.users as select * from sectest.users;
create table work.userDirectLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.users m, sectest.userDirectLogins d
   where m.key = d.key
;
create table work.userIndirectLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.users m, sectest.userIndirectLogins d
   where m.key = d.key
;
create table work.userLogins as
   select m.key, m.repoName, m.name, d.authDomainName, d.userId, d.hasPassword
   from work.users m, sectest.userLogins d
   where m.key = d.key
;
create table work.userDirectGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName
   from work.users m, sectest.userDirectGroupMemberships d
   where m.key = d.key
;
create table work.userIndirectGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName, d.level
   from work.users m, sectest.userIndirectGroupMemberships d
   where m.key = d.key
;
create table work.userGroupMemberships as
   select m.key, m.repoName, m.name, d.parentGroupRepoName, d.parentGroupName, d.level
   from work.users m, sectest.userGroupMemberships d
   where m.key = d.key
;
create table work.userDirectRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName
   from work.users m, sectest.userDirectRoleMemberships d
   where m.key = d.key
;
create table work.userIndirectRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName, d.level
   from work.users m, sectest.userIndirectRoleMemberships d
   where m.key = d.key
;
create table work.userRoleMemberships as
   select m.key, m.repoName, m.name, d.parentRoleRepoName, d.parentRoleName, d.level
   from work.users m, sectest.userRoleMemberships d
   where m.key = d.key
;
create table work.userCapabilities as
   select m.key, m.repoName, m.name, d.folder, d.capabilityName, d.isGranted
   from work.users m, sectest.userCapabilities d
   where m.key = d.key
;
create table work.userAppliedACTs as
   select m.key, m.repoName, m.name, d.appliedACTRepoName, d.appliedACTName
   from work.users m, sectest.userAppliedACTs d
   where m.key = d.key
;
create table work.userAppliedACEs as
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.users m, sectest.userAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.users m, sectest.userAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/user-reviewer-sectest-data.html';

title1 "Users";
proc print data=work.users;
run;

title1 "Direct Logins for Users";
proc print data=work.userDirectLogins;
run;

title1 "Indirect Logins for Users";
proc print data=work.userIndirectLogins;
run;

title1 "Logins (direct+indirect) for Users";
proc print data=work.userLogins;
run;

title1 "Direct Group Memberships for Users";
proc print data=work.userDirectGroupMemberships;
run;

title1 "Indirect Group Memberships for Users";
proc print data=work.userIndirectGroupMemberships;
run;

title1 "Group Memberships (direct+indirect) for Users";
proc print data=work.userGroupMemberships;
run;

title1 "Direct Role Memberships for Users";
proc print data=work.userDirectRoleMemberships;
run;

title1 "Indirect Role Memberships for Users";
proc print data=work.userIndirectRoleMemberships;
run;

title1 "Role Memberships (direct+indirect) for Users";
proc print data=work.userRoleMemberships;
run;

* The capabilities table can be very large: #rows = #user * #capabilities;
title1 "Capabilities for Users";
proc print data=work.userCapabilities(obs=500);
run;

title1 "ACTs applied to Users";
proc print data=work.userAppliedACTs;
run;

title1 "ACEs applied to Users";
proc print data=work.userAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;