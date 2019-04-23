.nr PSINCR 4p
.nr GROWPS 2
.so msacros
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
.PP
The primary aim of this project is to provide an open source and easy to deploy utility for setting up a monitoring system.
It will provide a framework to allow others use or build a top, opening up the field to a wider range of people from enthusiasts to small business.
A reliable backbone will be essential to providing a useful piece of software and built using secure and stable software.
Due to the nature of where these sensors are deployed, a robust network is required (allowing for nodes to drop and come back up again) which our choice of B.A.T.M.A.N allows.
This protocol can even route around a dead node, allowing packets to reach the bridge from any node.
This is broken down into some simple objectives below.
.RS
.IP \[bu]
Create a POSIX complaint script capable of deploying images to SD Cards.
.IP \[bu]
Network must be Mesh capable and provide a high
.B "QoS" .
.IP \[bu]
Create a binary capable of reporting sensor information to the database.
.IP \[bu]
A simple User Interface that a user can connect to to view the data being returned.
.RE
.bp
.NH
Literature Review
\# TODO : port lit review to groff.
.bp
.NH
Specification
.PP
.NH 2
Requirements Analysis
.PP
As discussed in the Literature Review there are many different approaches to the monitoring remote locations with low powered devices.
The most common trend takes the form of an Arduino with a ZigBee antenna feeding back to a Raspberry Pi acting as a server to manage all the "clients" or endpoints.
This causes barriers to entry for anyone wishing to deploy a small scale sensor network as it increases the amount of different devices they need to buy.
This project shall attempt to do two things; to implement a solid architecture allowing the endpoint and server to communicate and store data and to explore the possibilities of using onboard solutions for wireless transmission.
.NH 2
Functional Requirements
.PP
.B "Endpoint"
.RS
.IP \[bu]
The endpoint must be able to communicate with the server over distance
.IP \[bu]
The endpoints must have a sensor
.IP \[bu]
The endpoints must be able to retrieve data from sensors
.IP \[bu]
The endpoints must relay that information to the server
.IP \[bu]
Packetise the data and compress it for transmission over the likely low bandwidth connection
.IP \[bu]
Ensure that any lost data is resent
.IP \[bu]
The endpoints must be able to recover from loss of network
.IP \[bu]
In the case of weather conditions and the connection is lost, data to be sent should be held until the network returns
.IP \[bu]
The endpoint can recover from loss of power, incase of battery discharge
.RE
.PP
.B "Server"
.RS
.IP \[bu]
The server must be able to communicate with the endpoint
.IP \[bu]
The server must be able to store incoming data using a DBMS
.IP \[bu]
The server should not be susceptible to crashes
.IP \[bu]
Code running on the server should ensure that its uptime is maximum
.IP \[bu]
The mesh network must be able to establish new connections and handle lost connections on the fly.
.RS
As the endpoints are going to be susceptible to disconnecting and reconnecting, this should not cause an issue
.RE
.RE
.PP
.B "Software"
.RS
.IP \[bu]
Clients should sleep periodically to conserve power
.IP \[bu]
A minimum of Linux Kernel 4.18 should be used for the enhanced power saving improvements
.IP \[bu]
Client software must be deliverable as a single binary
.IP \[bu]
Should communicate of WiFi 2.4 GHz for the enhanced range
.IP \[bu]
Server software should be modelled as a RESTful API
.RE
.PP
.B "Sensors"
.RS
.IP \[bu]
.B "HC SR04"
Ultrasonic Sensor
.IP \[bu]
.B "EZO-pH"
Embedded pH Circuit
.IP \[bu]
.B "DS18B20"
Temperature Sensor
.IP \[bu]
DHT Temperature & Humidity Sensors
.RS
.IP \[bu]
.B "DHT11"
Sensor
.IP \[bu]
.B "DHT22"
Sensor
.IP \[bu]
.B "AM2302"
Sensor
.RE
.RE
.PP
.B "Non-Functional Requirements"
.RS
.IP \[bu]
Software developed should be open source
.IP \[bu]
Software developed should be maintainable
.IP \[bu]
Should be well documented allowing hobbyists and professionals to implement on their own
.IP \[bu]
Software should be written in the LTS versions of software to ensure long life of the project
.IP \[bu]
Client software should be written with power saving in mind
.IP \[bu]
Must have scripts for deploying software packages to SD Cards
.IP \[bu]
Endpoints and servers should comply with IEEE & IETF standards where possible
.RE
.NH 2
Legal and Ethical Requirements
.PP
This project has no Legal or Ethical ramifications as it collects no personal information.
.NH 2
Technologies Required
.PP
This project will require a
.B "Raspberry Pi 3 B +" ,
one or more
.B "Raspberry Pi Zero"
and one Sensor from the list above.
This is in addition to the mandatory power cables, or battery packs and SD Card for the devices.
Both the server and the clients will run on top of the standard
.B "Raspbian Lite"
Linux distribution, this includes no GUI and can only be accessed through SSH (which will be enabled for testing purposes) and through the openened port
.CW "8080"
to access the graphs and port
.CW "3000"
to access the API.
Database will use the popular
.B "InfluxDB" ,
a NoSQL Time Series Database because of its low system requirements and easy to use HTTP API.
.bp
.NH
Design / Methodology
.PP
This section will detail the design decisions taken to build the various sections of the project.
The initial plan of how the project would work, prior to any attempted implementation will be discussed first and then contraposed against the final implementation.
Many items discussed in the Literature Review and technologies that initally appeared promising proved to be either redundant or incompatible with the more core technologies being used, as such many of the decisions taken were interlinked with the restrictions imposed by the core requirements laid out in the previous section.
To aid in the seperation structure of the project, it has been split into a number of different repositories for each subject discussed below.
.NH 2
Setup Tools
.PP
The setup tools are provided by the primary repository for the code.
The primary file for the project deployment is the
.CW "prepare-sd.sh"
file which provides the setup for the document.
The output from this depends on the provided options, an example setup for a Rasbperry Pi Zero, which uses the ARMv6 architecture, is below.
.CW
.TS
box expand;
l.
$ ./prepare-sd.sh 0
::  Pi2 and 3 are armhf, Pi0 and Pi1 is armel
::  Choose either armhf or armel: armel
::  Listing out available drives
::  mmcblk0     179:0    0   15G  0 disk
::  Please specify drive: /dev/mmcblk0
::  Are we deploying to an eduroam network [y/N]
::  Hostname set to sensor-01d43a64
::  WARNING : This will erase all data on /dev/mmcblk0!
::  Are you sure? [y/N] y
::  Writing 352M to /dev/mmcblk0
::  This will take a while
::  Finished writing to /dev/mmcblk0
::  Creating mounting directories
::  Mounting /dev/mmcblk0p to /mnt/sd/
::  Moving files
::  Unmounting /dev/mmcblk0p
::  Install finished
$
.TE
.NH 2
Client Tooling
.NH 3
Reporter



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
.bp
.NH
Implementation
.PP
The implementation fo the project has followed a familiar path.
Initially the design and development of deployment tooling was neccassary both as a key part of the project but also to allow for rapid prototyping of future work.
Below will document these individual parts of the project.
.NH 2
Deployment Tools
.PP
.bp
.NH
Testing and Results
.PP
.bp
.NH
Evaluation
.PP
Below is a breakdown of the sections created to build this project and a discussion of the effectiveness of the implementation.
.NH 2
One
.PP
.NH 2
Two
.bp
.NH
Conclusion
.PP
.bp
.NH
Appendices
.SH 2
All of the other headnings
