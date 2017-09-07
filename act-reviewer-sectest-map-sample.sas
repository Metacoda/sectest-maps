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

filename sectest "input/act-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "act-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.acts as select * from sectest.acts;
create table work.actAppliedACTs as
   select m.key, m.repoName, m.name, d.appliedACTRepoName, d.appliedACTName
   from work.acts m, sectest.actAppliedACTs d
   where m.key = d.key
;
create table work.actPermissionPatterns as
   select m.key, m.repoName, m.name, d.identityRepoName, d.identityPublicType, d.identityName, d.permissions
   from work.acts m, sectest.actGroupPermissionPatterns d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.identityRepoName, d.identityPublicType, d.identityName, d.permissions
   from work.acts m, sectest.actUserPermissionPatterns d
   where m.key = d.key
order by key, identityRepoName, identityPublicType, identityName; 
;
create table work.actProtectedObjects as
   select m.key, m.repoName, m.name, d.protectedObjRepoName, d.protectedObjModelType, d.protectedObjPublicType, d.protectedObjFolder, d.protectedObjName   
   from work.acts m, sectest.actProtectedObjects d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.protectedObjRepoName, d.protectedObjModelType, d.protectedObjPublicType, d.protectedObjFolder, d.protectedObjName   
   from work.acts m, sectest.actProtectedACTs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.protectedObjRepoName, d.protectedObjModelType, d.protectedObjPublicType, d.protectedObjFolder, d.protectedObjName   
   from work.acts m, sectest.actProtectedUsers d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.protectedObjRepoName, d.protectedObjModelType, d.protectedObjPublicType, d.protectedObjFolder, d.protectedObjName   
   from work.acts m, sectest.actProtectedGroups d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.protectedObjRepoName, d.protectedObjModelType, d.protectedObjPublicType, d.protectedObjFolder, d.protectedObjName   
   from work.acts m, sectest.actProtectedRoles d
   where m.key = d.key
order by key, protectedObjFolder, protectedObjName 
;
create table work.actAppliedACEs as
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.acts m, sectest.actAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.acts m, sectest.actAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/act-reviewer-sectest-data.html';

title1 "ACTs";
proc print data=work.acts;
run;

title1 "Permission Patterns for ACTs";
proc print data=work.actPermissionPatterns;
run;

title1 "ACT Protected Objects";
proc print data=work.actProtectedObjects;
run;

title1 "ACTs applied to ACTs";
proc print data=work.actAppliedACTs;
run;

title1 "ACEs applied to ACTs";
proc print data=work.actAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;