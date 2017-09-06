# Metacoda Security Test XML Maps (sectest-maps)

## Intro

This repository provides some [SAS®](https://www.sas.com/) XML Libname Engine maps that can be used
for reading Metadata Security Test XML files exported from
[Metacoda® Security Plug-ins](https://www.metacoda.com/en/products/security-plug-ins/).

Metacoda customers and partners may find these maps useful if they want to do their own custom
processing or reporting on data available via Metacoda Security Plug-ins and exported in Metadata
Security Test XML format.

Metadata Security Test XML files are usually used for automated testing of SAS platform metadata
security implementations, but can also be used as a source of enhanced metadata security
information for custom reporting. Whilst Metacoda Security Plug-ins provide HTML and basic CSV
export features, for more advanced requirements Security Test XML files can also be considered.
Security Test XML files can be exported either manually using Metacoda Plug-ins from within SAS
Management Console, or in batch using the Metacoda Plug-ins Batch Interface. 

# Usage

You will need a Metadata Security Test XML file. To export one manually, launch SAS Management
Console and connect to the required SAS metadata server. If you have Metacoda Plug-ins installed,
select the Reviewer that contains the data you need. e.g. User Reviewer.
Using the tool bar button, or the context menu available by right clicking over the reviewer icon,
select the Export Metadata Security Test XML... menu item. In the export wizard check all of the
items you need in the export file, specify where you want the XML file to be saved and export
the file.

Choose the XML map that corresponds the the chosen Reviewer e.g. metacoda-user-reviewer-sectest.xml
and use the map with a SAS XML libname statement like so:

    filename sectest "input/metacoda-user-reviewer-sectest.xml" lrecl=32767 encoding="utf-8";
    filename map "metacoda-user-reviewer-sectest-map.xml" lrecl=32767 encoding="utf-8";
    libname sectest xml xmlfileref=sectest xmlmap=map access=readonly;

    title1 "Users";
    proc print data=sectest.users;
    run;
 
    title1 "User Groups (Direct+Indirect)";
    proc print data=sectest.userGroups;
    run;
 
    title1 "User Roles (Direct+Indirect)";
    proc print data=sectest.userRoles;
    run;
 
    libname sectest;
    filename map;
    filename sectest;

For more examples see the ``*-sample.sas`` files that accompany each map XML file.

# Resources

You may find the following resources useful when reviewing this documentation, the maps and sample code:

* [Metacoda Security Plug-ins Product Page](https://www.metacoda.com/en/products/security-plug-ins/)
* [Metacoda Security Testing Framework Product Page](https://www.metacoda.com/en/products/security-plug-ins/testing-framework/)
* [Metacoda Plug-ins Customer Documentation](https://support.metacoda.com/docs/plugins/v6.0/)
* [SAS® 9.4 XML LIBNAME Engine: User's Guide](https://support.sas.com/documentation/cdl/en/engxml/64990/HTML/default/viewer.htm#titlepage.htm)

# License

The maps and samples contained in this repository are licensed under the terms of the
[Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
See [LICENSE.txt](LICENSE.txt) for more information.

Metacoda Security Plug-ins, as required to export Metadata Security Test XML files read using these
maps, is a commercial product from Metacoda Pty Ltd, and must be separately licensed from Metacoda
if you want to use these maps with it.

# Trademarks

Metacoda® and all other Metacoda product or service names are registered trademarks or trademarks of
[Metacoda Group Pty Ltd](https://www.metacoda.com/) in the USA and other countries.

SAS® and all other SAS Institute Inc. product or service names are registered trademarks or
trademarks of [SAS Institute Inc.](https://www.sas.com/) in the USA and other countries. ® indicates
USA registration.

Other product and company names mentioned herein may be registered trademarks or trademarks of
their respective owners.