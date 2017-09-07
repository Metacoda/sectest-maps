/*
--------------------------------------------------------------------------------

Sample: capability-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of capability-reviewer-sectest-map.xml

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

filename sectest "input/capability-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "capability-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.capabilities as select * from sectest.capabilities;
create table work.capabilityDirectMembers as
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName 
   from work.capabilities c, sectest.capabilityDirectRoleMembers m
   where c.key = m.key
;
create table work.capabilityIndirectMembers as
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityIndirectRoleMembers m
   where c.key = m.key
outer union corr
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityIndirectGroupMembers m
   where c.key = m.key
outer union corr
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityIndirectUserMembers m
   where c.key = m.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
create table work.capabilityMembers as
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityRoleMembers m
   where c.key = m.key
outer union corr
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityGroupMembers m
   where c.key = m.key
outer union corr
   select c.*, m.memberIdentityRepoName, m.memberIdentityPublicType, m.memberIdentityName, m.level 
   from work.capabilities c, sectest.capabilityUserMembers m
   where c.key = m.key
order by key, level, memberIdentityRepoName, memberIdentityPublicType, memberIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/capability-reviewer-sectest-data.html';

title1 "Capabilities";
proc print data=work.capabilities;
run;

%let capabilityName=Save;

title1 "Direct Members granted '&capabilityName' Capability";
proc print data=work.capabilityDirectMembers;
where name="&capabilityName";
run;

title1 "Indirect Members granted '&capabilityName' Capability";
proc print data=work.capabilityIndirectMembers;
where name="&capabilityName";
run;

title1 "Members (direct+indirect) granted 'Save' Capability";
proc print data=work.capabilityMembers(obs=1000);
where name="&capabilityName";
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;