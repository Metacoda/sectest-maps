/*
--------------------------------------------------------------------------------

Sample: auth-domain-reviewer-sectest-map-sample.sas

Purpose:

Demonstrates the use of auth-domain-reviewer-sectest-map.xml

Authors:
* Paul Homes <paul.homes@metacoda.com>

--------------------------------------------------------------------------------

Copyright 2023 Metacoda Pty Ltd

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

filename sectest "input/auth-domain-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
filename map "auth-domain-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

proc sql;
create table work.authDomains as select * from sectest.authDomains;
create table work.authDomainLogins as
   select m.key, m.repoName, m.name, d.loginUserId, d.loginHasPassword
   from work.authDomains m, sectest.authDomainLogins d
   where m.key = d.key
;
create table work.authDomainConnections as
   select m.key, m.repoName, m.name, d.connectionRepoName, d.connectionName
   from work.authDomains m, sectest.authDomainConnections d
   where m.key = d.key
;
create table work.authDomainLibraries as
   select m.key, m.repoName, m.name, d.libraryRepoName, d.libraryParentFolder, d.libraryName
   from work.authDomains m, sectest.authDomainLibraries d
   where m.key = d.key
;
create table work.authDomainAppliedACTs as
   select m.key, m.repoName, m.name, d.appliedACTRepoName, d.appliedACTName
   from work.authDomains m, sectest.authDomainAppliedACTs d
   where m.key = d.key
;
create table work.authDomainAppliedACEs as
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.authDomains m, sectest.authDomainAppliedGroupACEs d
   where m.key = d.key
outer union corr
   select m.key, m.repoName, m.name, d.aceIdentityRepoName, d.aceIdentityPublicType, d.aceIdentityName, d.acePermissions
   from work.authDomains m, sectest.authDomainAppliedUserACEs d
   where m.key = d.key
order by key, aceIdentityRepoName, aceIdentityPublicType, aceIdentityName; 
;
quit; 

libname sectest;
filename map;
filename sectest;

* -----------------------------------------------------------------------------;

ods listing close;
ods html body='output/auth-domain-reviewer-sectest-data.html';

title1 "Auth Domains";
proc print data=work.authDomains;
run;

title1 "Logins associated with Auth Domains";
proc print data=work.authDomainLogins;
run;

title1 "Connections associated with Auth Domains";
proc print data=work.authDomainConnections;
run;

title1 "Libraries (indirectly) associated with Auth Domains";
proc print data=work.authDomainLibraries;
run;

title1 "ACTs applied to Auth Domains";
proc print data=work.authDomainAppliedACTs;
run;

title1 "ACEs applied to Auth Domains";
proc print data=work.authDomainAppliedACEs;
run;

ods html close;
ods listing;

* -----------------------------------------------------------------------------;