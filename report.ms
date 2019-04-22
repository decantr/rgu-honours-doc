.nr PSINCR 4p
.nr GROWPS 2
.TL
Distributed Mesh Sensor Network using Raspberry Pi's
.AU
Shaw Eastwood
.AI
Robert Gordon University
.DA
.AB
The Internet of Things
.B "IoT" ) (
has brought a plethora of low energy, low profile devices to market that are purpose built for a single purpose.
These devices are notorious for poor security and not receiving proper updates, along with wasting precious CPU cycles on sending excessive telemetry to the designers of the board.
This project will follow the design and implementation of deployable distributed sensor network for use on Raspberry Pi devices with minimal setup needed.
.AE
.XS 2
Report Structure
.XA 2
Introduction
.XA 3
Literature Review
.XA 4
Design / Methodology
.XA 5
Implementation
.XA 6
Testing and Results
.XA 7
Evaluation
.XA 8
Conclusion
.XA 9
Appendices
.XE
.TC
.bp
\# TODO : expand the abstract
\# TODO : more on the ethics
\# TODO : ONGOING : keep ToC up to date
.SH
Report Structure
.LP
This report details the process required to construct a distributed mesh network of sensors.
The report will walkthrough the process undertook to create the open source tooling that has been made available with the release of this document.
.XP
.B "Literature Review"
- The literature review section details the projects done that are in the similar field as this.
.XP
.B "Specification"
- Compiled list of requirements for the project.
.XP
.B "Design Methodology"
- The design methodology section will walkthrough the rational followed in the design of the project.
.XP
.B "Issues"
- Following this the implementation section describes the issues that were encountered and overcome in the building of the final product.
.XP
.B "Testing"
- This is followed by the testing and results which will describe the testing process overall and the results achieved from this resting.
.XP
.B "Evaluation"
- An evaluation of the project as a whole will follow this and cover the implementation and the results of testing.
.XP
.B "Conclusion"
- Finally the conclusion which will describe things learned and describe the pitfalls to any future implementations.
.bp
.NH
Introduction
.PP
The Internet Of Things
.B "IoT" ) (
is an ever growing market with
.B "ZigBee"
and
.B "WiFi"
powered devices becoming more and more prevalent in peoples homes.
Much of this stems from the rise of (Ultra)-Low Power IoT Devices (LPIoTD) that are used by enterprise to deploy sensors to inform automation systems.
This is commonly used for things such atmospheric control where a number of sensors in a room will allow a central server control temperature and air conditioning to each room individually.
The use of these LPIoTD is expanding into other areas, such as river monitoring, as described in my literature review, which was previously a manual task performed weekly.
.bl
By harnessing this technology we can gain a deeper understanding of how variables from different aspects of life can have an affect.
Unfortunately the majority of these implementations are proprietary.
Anyone interested in deploying such a network would be required to obtain a bulk purchase of potentially hundreds of Single Board Computers
.B "SBC" ) (
which are purpose built for the task and pay licensing fees.
Thanks to the rise of the Non Profit
.B "Raspberry Pi Foundation"
and its (mostly) open source
.B "Raspberry Pi"
line, we have access to a plethora of Low Power SBC'S which we can leverage to produce our own LPIoTD.

.NH 2
Motivation
.PP
My initial experience with IoT devices, as many peoples will likely be, was through a smart assistant device.
This seemingly innocuous cylinder would light up and respond to questions by using it's name.
Over the next few years the stories of data harvesting from IoT devices, breaches and security breaches
.[
Mirai
.]
the need for a standard, open source implementation became clearer.
A number of these projects caught my attention such as
.B "Mozilla" 's
.B WebThings
tool that attempts to allow interoperability between the differing protocols
.[
WebThings
.]
and
.B "Mycroft AI" 's
.B "Mycroft"
which is an open source AI implementation competing with the likes of
.B "Amazon" 's
.B "Alexa"
or
.B "Google" 's
.B "Google Assistant"
in order to provide a free platform that can be self hosted.
.[
Mycroft
.]
There have been a number of attempts from other academic papers, which I will touch on later, to create a similar implementation for distributed sensor networks, however none have really allowed such a low barrier to entry as this project aims to provide.
.NH 2
Aims and Objectives
.NH 2
Ethics of IoT

.bp
.NH
Literature Review
\# TODO : port lit review to groff.
.NH
Design / Methodology
.NH 2
Client Tooling - Reporter.go
.PP
.NH 2
Server Handler - Recorder.go
.PP
.NH 3
Database Structure
.PP
.NH 2
User Interface - Represent.js
.PP
.NH 2
Design of the Nodes
.PP
.NH 2
Design of Server
.PP

.NH
Implementation
.PP
The implementation fo the project has followed a familiar path.
Initially the design and development of deployment tooling was neccassary both as a key part of the project but also to allow for rapid prototyping of future work.
Below will document these individual parts of the project.
.NH 2
Deployment Tools
.PP
.NH
Testing and Results
.PP

.NH
Evaluation
.PP
Below is a breakdown of the sections created to build this project and a discussion of the effectiveness of the implementation.
.NH 2
One
.PP
.NH 2
Two

.NH
Conclusion
.PP
.NH
Appendices
