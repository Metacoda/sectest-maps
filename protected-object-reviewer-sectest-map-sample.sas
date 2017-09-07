/*
--------------------------------------------------------------------------------

Sample: protected-object-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of protected-object-reviewer-sectest-map.xml

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

filename sectest "input/protected-object-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "protected-object-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.protectedObjs as select * from sectest.protectedObjs;
create table work.protectedObjAppliedACTs as
   select m.*, d.appliedACTRepoName, d.appliedACTName
   from work.protectedObjs m, sectest.protectedObjAppliedACTs d
   where m.key = d.key
;
create table work.protectedObjAppliedACEs as
   select m.*, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.protectedObjs m, sectest.protectedObjAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.*, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.protectedObjs m, sectest.protectedObjAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/protected-object-reviewer-sectest-data.html';

title1 "Protected Objects";
proc print data=work.protectedObjs;
run;

title1 "ACTs applied to Protected Objects";
proc print data=work.protectedObjAppliedACTs;
run;

title1 "ACEs applied to Protected Objects";
proc print data=work.protectedObjAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;