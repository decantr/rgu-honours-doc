\# TODO : expand the abstract
\# TODO : more on the ethics
\# TODO : ONGOING : keep ToC up to date

.nr PSINCR 2p
.nr GROWPS 4
.ds LF Shaw Eastwood
.ds RF %

\# macro to handle figures
.de FIG
.       KS
.       PSPIC -C "\\$2" 4
.       ad c
.       I "Figure \\$1"
.shift 2
\\$*
.       KE
.       ad b
..

\# macro to handle references
.de REF
.       KS
.       ad c
.       I "Figure \\$1"
.shift
\\$*
.       KE
.       ad b
..


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
has brought a plethora of low energy, low profile devices to market that are purpose built for a single function.
These devices are synonymous with poor security, abscence of proper upstream updates, along with spending CPU cycles on sending useless telemetry to the manufacturer of the device.
This project will follow the design and implementation of deployable distributed sensor network for use on Raspberry Pi devices with minimal setup needed.
.AE

\# Table of Contents

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
.PX
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

By harnessing this technology we can better minitor the many variables in any given environment, unfortunately the majority of these implementations are proprietary.
Anyone interested in deploying such a network would be required to obtain a bulk purchase of potentially hundreds of Single Board Computers
.B "SBC" ) (
which are purpose built for the task and pay licensing fees.
Thanks to the rise of the Non Profit
.B "Raspberry Pi Foundation"
and its (mostly) open source
.B "Raspberry Pi"
line, we have access to a plethora of Low Power SBC'S which we can leverage to produce our own LPIoTD.

.NH 2
Report Structure

.PP
This report details the process required to construct a distributed mesh network of sensors.
The report will walkthrough the steps taken to create the open source tooling that has been made available with the release of this document.

.IP
.B "Introduction"
- This section, containing the broad overview of the project and the motivation behind it.
.IP
.B "Literature Review"
- The literature review section details the projects done that are in the similar field as this.
.IP
.B "Design & Methodology"
- The design methodology section will walkthrough the rational followed in the design of the project.
.IP
.B "Implementation"
- Naturally, following the design section the implementation seciton will describe what was built with the tools and techniques described in the methodology section.
.IP
.B "Testing & Results"
- This is followed by the testing and results which will describe the testing process overall and the results achieved from this resting.
.IP
.B "Evaluation"
- An evaluation of the project as a whole will follow this and cover the implementation and the results of testing.
.IP
.B "Conclusion"
- Finally the conclusion which will describe things learned and describe the pitfalls to any future implementations.

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

.PP
This section will review the literature surrounding establishing a sensor network including the kinds of devices, the network options available and sensors that could be used.

.SH
Background

.PP
The current system for monitoring rivers and bodies of water involves building small concrete huts that record and store data locally.
The cost of building these huts makes them prohibitive and is inefficient with today's technology.
Some even requiring a person being sent periodically to collect this information manually.
.[
SEPA Water Level Data FAQ
.]
Figure I shows one of these monitoring stations found along the River Beauly.

.FIG "2.1: SEPA Monitoring Station" "images/wallace.eps"
.[
Wallace2012
.]

In 2005 the WFD reported 285 type 1a and 1b "at risk" bodies of water.
.[
SEPA2007
.]

By 2006 253 stations such as the one pictured in Figure 1 were in place across Scotland representing 10% of the country's total water bodies and 26% of the 989 "at risk" rivers as of 2009.
.[
SEPA2009
.]

.FIG "2.2: Monitoring Stations in Scotland" "images/monitoring.eps"
.[
SEPA2006
.]

.PP
The reason for this can be attributed to the cost of these monitoring stations, with the solution proposed in this paper cost could be greatly reduced to a fraction of this.
.[
SEPA2016
.]

Alternatives to this using more modern technology are still highly expensive and cost prohibitive.
.[
TheIoTMarketplace2015
.]

.NH 2
Open Source

.PP
Attempts have been made to tackle some of the problems such as flooding
.[
Castillo-Effen2004
.]
 though few of these projects cover the many aspects this project will.
Many commercial applications developed are built with a propriety licence which prohibits the reading or sharing of the code.
This is the antithesis of Open Source, which has slowly been gaining traction from large companies, dispelling the myth that it is hobbyist code at best.
For example, Red Hat Inc. was valued at 35 billion during its recent acquisition.
.[
Hammond2018
.]
This is no better seen than in the worldwide adoption of Apache, a
.IT "http daemon"
that runs many websites from hobby to major company (Apple.com, Adobe.com etc.).
.[
W3techs2018
.]

Further projects such as the Linux kernel, originating from Linus Torvalds has seen a massive adoption, most strikingly in the supercomputing market where it has completely dominated the top 500 supercomputers (ranked by TFlops).
.[
Top5002018
.]

.PP
The field of environmental monitoring is largely untapped, with much of the current solutions being closed source and expensive.
.[
TheIoTMarketplace2015
.]

There is little interaction from the community and even less interoperability from the technologies deployed.
There's also the consumer aspect, where environmentally conscious individuals want to help monitor the local environment.
An attempt was made to crowd source the collection of atmospheric data
.[
OKLabStuttgart2015
.]
across Europe and beyond with small sensor units developed during workshops.

.FIG "2.3: Air Quality Map" "images/opendatamap.eps"
.[
OKLabStuttgart2018
.]

This model of crowd sourced deployment means anyone can get involved, and it ensures that the data is freely available to all.
This is also a key principle for this project, and the Open Database License
.[
OpenDataCommons2011
.]
will ensure the data can be used freely.

.SH 2
Endpoint Devices

.PP
The Internet of Things
.B "IoT" ) (
is a burgeoning field that has seen a massive boom in the Smart Devices market.
.[
Lueth2018
.]

IoT devices are defined by their low cost and low power and their ability to communicate with each other on the same LAN and have a degree of interoperability.
.[
Vujovic2014
.]

With the ever increasing rise of such devices the availability of low cost System On a Chip
.B "SOC" ) (
devices increases with it.

Many vendors have begun targeting the SoC devices after the Raspberry Pi Foundation unveiled the Raspberry Pi 1.
Today there exists a myriad of low cost SoC's with differing qualities for differing use cases.
.[
Larabel2018
.]

Many System On a Chips are available in the current market.
Two of the largest names include Raspberry Pi from the Non Profit Raspberry Pi Foundation and the Arduino board from Arduino LLC.

.SH 3
Raspberry Pi

.PP
The Raspberry Pi Zero W
.B "RPi0" ), (
the Non W (Wireless) is pictured below, is a nice fit for our endpoint controller.
It's availability and it's wide range of support makes it an appealing choice for the controller.
The RPi0 is an excellent fit for our project as at idle it will only draw a maximum average of 100mA
.[
Alex2017
.]
with further tweaks reducing it.

On a relatively low cost battery we can expect this to last a day.
Many of the current SEPA stations use solar power to power the electronics inside the shed.
.[
SEPA2007
.]
Our sensors will also be battery powered leveraging a solar panel to ensure charge is maintained.

.FIG "2.4: Raspberry Pi Zero W" "images/rpi0.eps"
.[
Amos2016
.]

The Raspberry Pi 3B+ on the other hand is a much better fit for a server/command and control device.
.[
Leccese2014
.]
With it's more powerful CPU increasing the power draw to an idle of ~500mA
.[
RaspberryPiFoundation2018
.]
powering this from a battery wouldn't be ideal. Instead it should be used to connecting a LTE adapter or Ethernet cable to connect the endpoints to the larger LAN or WAN for sending information back to a central server.

.FIG "2.5: Raspberry Pi 3B+" "images/rpi3b.eps"
.[
RaspberryPiFoundation2018a
.]


.SH 3
Arduino

.PP
The Arduino is a compelling choice as it's Arduino Nano product, pictured below, uses the ATmega328 microcontroller.
This is a controller with a miniscule power draw of only 19mA.
.[
ArduinoLLC2010
.]
This can be further improved to reach as low as 54 µA (0.054 mA).
This would enable us to run on a minimal power source such as a 9V battery cell for periods of years.
.[
Madcoffee2018
.]

Further the arduino features a smaller SoC size for both the Nano and the full-size Uno device
.[
ArduinoLLC2010
.]
making it more versatile.

.FIG "2.6: Arduino Nano" "images/arduinonano.eps"
.[
Mellis2010
.]

.SH 3
Other

.PP
Many other SoC's include the ASUS tinker board and BeagleBoard among many others.
Other SoC's target features found lacking in the Raspberry Pi, namely Gigabit Ethernet and increased RAM or reducing power consumption and SoC size.
These make them compelling choices in scenario's where size or bandwidth etc. are essential however these other board's are often more expensive and even more difficult to source.

.SH 3
Comparison

.PP
.TS
centre tab(&) expand nowarn;
lcccccc
lrrrrrr.
_
& Uno Rev 3 & Nano & Pi 3B+ & Pi Zero W & BeagleBone & TinkerBoard
_
Cost (£) & 15 & 15 & 35 & 15 & 50 & 55
Power Draw Idle & 0.225 W & 0.01 W & 2 W & 0.5 W & 1.75 W & 2 W
WiFI & N/A & N/A & 802.11 b/g/n & 802.11 b/g/n & 802.11 b/g/n & 802.11 b/g/n
Bluetooth & N/A & N/A & 4.2 & 4.1 & 4.1 & 4.0
CPU Arch & AVR & AVR & ARMv8 & ARMv6 & ARMv8 & ARMv7
Clock Speed & 16 MHz & 16 Mhz & 1.4 GHz & 1 GHz & 1 GHz & 1.8 GHz
Core Count & 1 & 1 & 4 & 1 & 1 & 4
RAM & 32 KB & 32 KB & 1 GB & 512 MB & 512 MB & 2 GB
OS & N/A & N/A & Linux & Linux & Linux & TinkerOS
_
.TE
.REF "2.7: Table comparing differing devices"
.[
ArduinoLLC2010
.]
.[
ArduinoLLC2008a
.]
.[
RaspberryPiFoundation2018
.]
.[
RaspberryPiFoundation2017
.]
.[
BeagleBoard2017
.]
.[
Asus2017}
.]

The advantage afforded to the RPi0 is it's availability, low cost, support but more importantly familiarity.
It is important to ensure the barrier for entry, both cost and technical ability, is kept to a minimal for anyone who wishes to deploy one or more of these.
Additionally by using the RPi0 we can leverage technologies already created for the device.
From the graph above we can see that the pi3 and pi0 fit nicely into the middle of the graph offering good hardware and low power consumption.

.SH 2
Server

.PP
A server is defined as a device that can serve one or more "client" devices.
This will usually be a powerful device that clients can send raw data to and have the server do any computation required before returning a result.
.[
Raymond2003
.]
A number of operating systems exist to target the server.
This is achieved by first stripping the system of as many superfluous systems as possible, such as a graphics stack.
.[
Canonical2013
.]

The configuration is therefore handled primarily though the shell, under Linux this is usually Bash (Bourne Again Shell).
Windows Server's do not abide by this however and usually a graphical stack is used to perform most configuration.
.[
MicrosoftCorporation2017a
.]
Due to this, a Linux server is best placed due to its far lower system requirements to run.

.TS
centre tab(&);
cccc
lrrr.
_
& Raspbian Lite & Ubuntu Server & Microsoft Server
_
CPU & 1 GHz & 1 GHz & 1.4 GHz
RAM & 128 MB & 384 MB & 512 MB
Storage & 2 GB & 1.5 GB & 32 GB
_
.TE
.REF "2.8: Comparitive Requirements of differing software"
.[
Debian2018
.]
.[
Canonical2013
.]
.[
MicrosoftCorporation2017a
.]

To ensure that costs are kept low, small SD Cards are ideal which somewhat rules out the Windows option.
In addition hardware support for Windows on Raspberry Pi is limited to Windows S
.[
MicrosoftCorporation2017b
.]
which would require any software to be written as a UWP
.[
MicrosoftCorporation2017c
.]
which would hinder performance.

.SH 2
Sensors

.SH 3
Water Level

.PP
The collection of the river data will be the trickiest part of the project.
Currently to collect water level data, a wire is laid across the river and a buoy attached to the middle.
The sag in the wire can then be used to calculate depth.
.[
SEPA2016
.]
An alternative solution involves using an ultrasonic sensor to judge the distance between the sensor and the water.
.[
AravindJayan2016
.]
An example of this sensor is shown in the figure below.
This method has the advantage of being a low physical footprint solution to monitoring.

.FIG "2.9: HC SR04 Ultrasonic Sensor" "images/hcsr04spl.eps"
.[
MouserElectronics
.]

.SH 3
pH Sensor

.PP
The sensing of the pH level is somewhat more difficult and requires a specialist tool.
The EZO-pH Embedded pH Circuit
.[
AtlasScientific2018b
.]
allows for a digital signal to be read through i2c or UART by a connected device.
.[
Dey2018
.]
One issue with this sensor is that is an analogue device and thus if a Raspberry Pi is used we will require an ADC (Analogue to Digital Converter) to hook it up.
If instead an Arduino is used, this will not be an issue.
.SH 3
Temperature Sensor
.PP
To collect the temperature a wide range of sensors can be used with the only requirement being they are waterproof.

The most accessible of these is the DS18B20
.[
AdafruitDS18
.]
which communicates over the 1-Wire protocol.
This is particularly useful to us as it is a digital sensor meaning we will not need the additional ADC if a Raspberry Pi (Zero) is used.
Once connected this can be polled for the current temperature at the sensor.
.[
Monk2013
.]

.SH 2
Networks

.PP
.TS
centre tab(&);
ccccc
lrrrr.
_
& ZigBee & Pi 3B+ WiFi & Pi 0 W & Bluetooth
_
IEEE & 802.15.04 & 802.11 b/g/n & 802.11 b/g/n & 802.15.1*
Frequency (GHz) & 2.4 & 2.4/5 & 2.4 & 2.4
Main Application & Smart Devices & WLAN & WLAN & Low Bitrate Streams
Bit Rate & 250kbps & 600 Mbps & 54 Mbps & 24 Mbps
Range & 100m & 100m & 30m & 15m
_
.TE
.RS

.REF "2.10: ZigBee vs. a number of other wireless network"
.[
RaspberryPiFoundation2018
.]
.[
RaspberryPiFoundation2017
.]

.PP
The communication methods listed in Table above, all have there advantages and disadvantages.
ZigBee has a significant advantage in this area as in addition to the above metrics, it has a significantly lower battery usage than the other two protocols .
.[
Leccese2014
.]

However this comes at a cost, both financially and to accessibility, as the ZigBee protocol requires an additional module to be attached to the device used to allow it to communicate.
Further complicating things is these modules are an additional cost on top of the controller ( SoC ) and sensors required.
.[
zigbee2015
.]

This additional complexity serves to increases the desirability of Wifi and Bluetooth as options.
.PP
To connect these devices together, especially if Bluetooth is used, a method of daisy chaining them together is almost essential to keep costs to a minimum.
This introduces many issues however as one of the main issues facing SEPA with it's current solution is vandalism
.[
SEPA2018
.]

and these sensors could be an attractive target.
The removal of a device near the start of a chain either through a fault, theft etc. could affect many more sensors further along having a cascading effect.
This is not ideal and makes Bluetooth a very unattractive option.
Further, the Bluetooth 4.1 and Bluetooth LE suffer from major range limitations of a meagre 10 to 15 metres
.[
Volume2013
.]
, again ZigBee provides a excellent replacement to this with a majorly increased range over Bluetooth.
.[
Pocero2017
.]

.SH 2
Conclusion

.PP
There are a number of possibilities for the devices that could be used but overall the needs of the sensors used dictate the choice of the endpoint.
The Arduino suits this role more than the Raspberry Pi Zero W in terms of power consumption and having the Analog pins available with no additional modules necessary.

.PP
In contrast it's clear the lack of computational power on the Arduino Uno makes the Raspberry Pi 3B+ the clear winner for the command and control 'server' for the endpoints to report back to.
It's increased power consumption can easily be offset if it is placed in a position with a hard line power source which may not be able to reach the other devices.
Further if Ethernet/ADSL can be used it far better placed to interface with a physical connection.
Alternatively the additional demands on the hardware of a GSM/LTE adapter and connection will be offset with the more powerful device.

Network choice is majorly dependant on the topography of the terrain the devices are being deployed in.
If foliage is a major issue then the already weak WiFi is going to be inoperable and ZigBee will be essential, however if there is little vegetation then WiFi may be viable alternative to keep costs and complexity low.

The sensors used are entirely determined by the market and what is available. As stated previously this is a niche and thus there are few options.

.bp
.NH
Design / Methodology

.PP
This section will detail the design decisions taken to build the various sections of the project.
The initial plan of how the project would work, prior to any attempted implementation will be discussed first and then contraposed against the final implementation.
Many items discussed in the Literature Review and technologies that initally appeared promising proved to be either redundant or incompatible with the more core technologies being used, as such many of the decisions taken were interlinked with the restrictions imposed by the core requirements laid out in the previous section.
To aid in the seperation structure of the project, it has been split into a number of different repositories for each subject discussed below.
Initially the projcet requirements are listed here.

.NH 2
Requirements Analysis

.PP
As discussed in the Literature Review there are many different approaches to the monitoring remote locations with low powered devices.
The most common trend takes the form of an Arduino with a ZigBee antenna feeding back to a Raspberry Pi acting as a server to manage all the "clients" or endpoints.
This causes barriers to entry for anyone wishing to deploy a small scale sensor network as it increases the amount of different devices they need to buy.
This project shall attempt to do two things; to implement a solid architecture allowing the endpoint and server to communicate and store data and to explore the possibilities of using onboard solutions for wireless transmission.

.NH 3
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

.NH 3
Non-Functional Requirements

.PP
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

.NH 3
Legal and Ethical Requirements

.PP
This project has no Legal or Ethical ramifications as it collects no personal information.

.NH 3
Technologies Required

.PP
This project will require a
.B "Raspberry Pi 3 B +" ,
one or more
.B "Raspberry Pi Zero W"
and one Sensor from the list above.
This is in addition to the mandatory power cables, or battery packs and SD Card for the devices.
Both the server and the clients will run on top of the standard
.B "Raspbian Lite"
Linux distribution, this includes no GUI and can only be accessed through
.B "SSH"
(which will be enabled for testing purposes) and through the openened port
.CW "8080"
to access the graphs and port
.CW "3000"
to access the API.
Database will use the popular
.B "InfluxDB" ,
a
.B "NoSQL"
Time Series Database because of its low system requirements and easy to use
.B "HTTP API" .

.NH 2
Mesh Network

.PP
A mesh network is defined as as a network in which all nodes are communicating with each other, independently.
.[
mesh network
.]
This has the advantage of being a high
.B "QoS"
network which is very robust to disconnections and slow speeds.
Similiar to a mesh network is a
.B "P2P"
protocol such as bittorrent which provides direct Peer To Peer connections accross existing network infrastructure.
The Mesh network however is established at the hardware layer, with nodes not being physically connected.

.PS
lineht = lineht / 2

up
NW: circle rad .3 "node-w"
up
move
right
move
NN: circle rad .3 "node-n"
down
move
right
move
down
NE: circle rad .3 "node-e"
down
move
left
move
NS: circle rad .3 "node-s"

line <-> from NW.e to NN.s
line <-> from NW.e to NE.w
line <-> from NW.e to NS.n

line <-> from NN.s to NE.w
line <-> from NN.s to NS.n
line <-> from NN.s to NW.e

line <-> from NE.w to NS.n
line <-> from NE.w to NW.e
line <-> from NE.w to NN.s

line <-> from NS.n to NW.e
line <-> from NS.n to NN.s
line <-> from NS.n to NE.w

.PE
.REF "3.1 Mesh Network with four nodes."

This shows the general layout of a mesh network in that all nodes can, and are communicating with each other.
This is an atypical mesh network however as in an optimal setup each node would only connect to one other node, though in practice two is ideal, so as not to have overlapping network.
The mesh network ensures that if a node is dropped from the mesh, traffic can be routed around the lost node to ensure that connectivity is maintained.
For example below we will add a further two nodes on the outer reaches of the network.

.PS
lineht = lineht / 2

down
NWW: circle rad .3 "node-ww"
right
move
move
up
NW: circle rad .3 "node-w"
up
move
right
move
NN: circle rad .3 "node-n"
down
move
right
move
down
NE: circle rad .3 "node-e"
down
move
left
move
NS: circle rad .3 "node-s"
up
move
right
move
move
move
move
up
NEE: circle rad .3 "node-ee"

line <-> from NW.e to NN.s
line <-> from NW.e to NE.w
line <-> from NW.e to NS.n

line <-> from NN.s to NE.w
line <-> from NN.s to NS.n
line <-> from NN.s to NW.e

line <-> from NE.w to NS.n
line <-> from NE.w to NW.e
line <-> from NE.w to NN.s

line <-> from NS.n to NW.e
line <-> from NS.n to NN.s
line <-> from NS.n to NE.w

line <-> from NEE.w to NS.e
line <-> from NEE.w to NE.e
line <-> from NEE.w to NN.e

line <-> from NWW.e to NN.w
line <-> from NWW.e to NW.w
line <-> from NWW.e to NS.w

.PE
.REF "3.2: Mesh Network with six nodes."

In this diagram we can see that the nodes
.I "node-ww"
and
.I "node-ee"
are not directly connected with each other.
However they are still able to communicate with each other by routing their traffic through, for example
.I "node-n" .
The advantage of this network type become clear when, for example, nodes
.I "node-n"
and
.I "node-s"
lose connectivity, but
.I "node-ww"
and
.I "node-ee"
are still able to communicate through the remaining two nodes.

.PS
lineht = lineht/4
X: circle rad .3 "X"
move
move up
right
Y: circle rad .3 "Y"
move down
move right
Z: circle rad .3 "Z"
circle rad 1 dashed "" at X.c
circle rad 1 dashed "" at Y.c
circle rad 1 dashed "" at Z.c
.PE
.REF "3.3: Layout of three nodes, displaying antenna ranges"

.PP
The above graph shows the differing ranges between these nodes, demonstrating the limitation of antenna range.
As described above, the mesh network then allows
.CW "X"
to communicate with
.CW "Z"
via the connection established with
.CW "Y" .

.SH 3
Protocol

.PP
The choice of implementation discussed in the Literature Review covered a number of potential choices for building the network on.
The desire for a Mesh implementation seemed to narrow the choice of adapter type to WiFi or Bluetooth.
However recent advances in the
.B "B.A.T.M.A.N"
protocol have enabled it to compile and perform on ARM hardware, thus opening the door to use it.
The distributed mesh networking can be provided by the newer
.B "B.A.T.M.A.N Advanced"
protocol, which now operates on Layer 2 of the OSI stack.
This change means it no appears to the Linux System as an adapter so any program can send packets to it as if it was a normal adapter (wlan, eth etc.) and
.B "B.A.T.M.A.N"
will handle the transmission of the packets.
This has the added benefits of increased compatibility, high performance with very little overhead, perfect for low powered devices.

With this new
.B "B.A.T.M.A.N Advanced"
protocol
.B "DHCP"
traffic can be traversed through the interface which allows our nodes to request
configurations from a
.B "DHCP server"
anywhere in the network.
As long as a node, typically our bridge node, is connected to a network with one of these servers, typically running on the router, the nodes inside the mesh will be fully transparent to the wider network and, if it exists, the public internet.
This functionality however may not be desired as the nodes have no need for the internet, besides updates and thus it represents a potential security flaw.

.SH 3
Database API

.PP
.B "InfluxDB" 's
query language, although incredibly powerful, will be abstracted by an API for use in the front end viewer.
There are a number of ways to structure access to data in an API.
The most common implementation is Representational State Transfer
.B "REST" ). (
REST is a description of an Interface which completely abstracts the Data Layer which is accesses, meaning a client needs no prior knowledge of the API to communicate with it.
Implementations can use any data structure to communicate in for example XML, CSV etc. however the most common is Javascript Object Notation
.B "JSON" ) (
due to it's low boilerplate overhead and ubiquity.
In layman's terms this is analogous to posting a letter, you put the letter in the post box and the recipient will receive it, there is no need to know the inner workings of the Post Office to communicate through/with it.

A popular alternative to this is Simple Object Access Protocol
.B "SOAP" ) (
which, as the name states, is a protocol rather than a set of rules.
Despite both communicating over HTTP, SOAP by contrast is far more cumbersome in both transmission size and implementation.
The protocol which communicates exclusively through XML and requires a far greater tethering of client and server.
A client wanting to access a SOAP API uses it more as a gateway to pass commands into the system, meaning far tighter integration and lower portability.
Because of his it has largely lost traction to the afformentioned REST.

A number of other implementation exist such as Facebook's
.I "GraphQL"
or Netflix's
.I "FALCOR"
however these are largely bespoke protocols to fit a particular use case, and thus are not ideal for this purpose.

Due to this the REST implementation is the clear choice for the project.
The server running the API will be able to take advantage of the built-in features of the language.
PHP and Node.js both have very well developed integrations for both HTTP requests and handling of JSON, with Node.js providing the cleanest with the data type.

.bp
.PS
define filter {box ht 0.25 rad 0.125}
lineht = 0.25;
Top: [
    right;
    box width 1.3 "\fBCustom Client\fR" "HTTP";
    move;
    box "\fBWeb UI\fR" "HTTP";
    move;
    box "\fBCURL\fP" "HTTP";
    move;
    box width 1.5 "\fBMobile Application\fP" "HTTP";

    line <- down from 1st box .s; filter "\fBJSON\fP";
    A: line down;
    line <- down from 2nd box .s; filter "\fBJSON\fP";
    B: line down;
    line <- down from 3rd box .s; filter "\fBJSON\fP";
    C: line down;
    line <- down from 4th box .s; filter "\fBJSON\fP";
    D: line down;
]
move down 1 from last [] .s;
Anchor: box wid 1 ht 0.75 "\fBREST API\fR" "3000";
arrow from Top.A.end to Anchor.nw;
arrow from Top.B.end to 1/3 of the way between Anchor.nw and Anchor.ne;
arrow from Top.C.end to 2/3 of the way between Anchor.nw and Anchor.ne;
arrow from Top.D.end to Anchor.ne
arrow <- lineht .1 from Anchor.s; filter width 1.5 "Influx Query Language";
arrow lineht .25;
box "InfluxDB"
.PE
.REF "3.4: Interaction between clients and API"

.PP
The above Figure 14 shows how a myriad of different clients can interact with the API without needing to know the IQL syntax or handle output of the query.
This has a number advantages, as mentioned in the previous section, mainly the portability of the data returned, and that it is stateless.
Any type of client making a request against the API will recieve the same data.

.NH 2
Deploy Scripts
.PP
Initially the design and development of deployment tooling was necessary both as a key part of the project but also to allow for rapid prototyping of future work.
Languages for creating this are limited and the choice of
.CW "shell"
was an obvious one.
Most
.B "Linux"
Distribution's ship with Bourne Again Shell or
.B "bash"
as it's better known, this is also used by MacOS as the shell environment.
Bash implements some very useful features that can be used in the Command Line Interface
.B "CLI" ) (
environment or in "Shell Scripts" however these features are not POSIX complaint.
.[
gnubashmanual
.]
The Portable Operating System Interface
.B "POSIX" ) (
is the definition described in 1994 to define a Unix-Like Operating System with a standard set of operations.
.[
ieeestd.1994
.]
The shell script will adhere to this specification in order to provide portability between the Unix-like systems.

There was a number of different ways this could have been implemented, the use of the utility
.CW "dialog"
or
.CW "ncurses"
to create an interactive environment that the user could choose options from was a compelling choice as it would lower the barrier to entry significantly.
However as discussed in the previous section the portability was a more desirable feature and thus it was decided to ensure POSIX compliance, over these tools.
.SH 3
Input
.PP
Furthermore, anyone familiar with CLI tools is aware that they usually operate through "flags" or arguements that are passed to the command.
For example running the
.CW "git log"
command would create an output like this

.CW
.TS
box centre;
l.
.SM
$ git log
commit 63701fb155040d0cc1e2152dd19d6b8056f0fe5e (HEAD -> master)
Author: decantr <theeasterlywood@gmail.com>
Date:   Thu Apr 25 00:11:24 2019 +0100

    fix heading type
.TE
.REF "3.5: Output of the 'git log' command"

.R
Whereas running the
.CW "git log"
with the arguements
.CW "--no-pager log --oneline -n 1"
would produce the following.

.CW
.TS
box centre;
l.
.SM
$ git log --no-pager log --oneline -n 1
63701fb (HEAD -> master) fix heading type
.TE
.REF "3.6: Output of the git log command with flag"

.R
This is the standard way to control the behaviour of a command being run.
However as the stated objective of this project is a low barrier for entry, an interactive script experience was chosen.
The user will be prompted for a number of inputs, deciding what type of device we will be deploying and where the SD card is located.

.SH 3
Functionality

.PP
The remit of the setup scripts is such that it should provide an entirely automated setup experience.
The user should only be required to input the settings and move the SD Card to the desired device.
To accomplish this a number of processes need to be handled by the script, such as

.RS
.RS
.IP \[bu]
Collecting the .deb archive dependencies
.IP \[bu]
Collecting the .zip of the
.I "Raspbian Lite"
image
.IP \[bu]
Burn the image to the SD Card
.IP \[bu]
Whether to enable
.B "SSH" .
.IP \[bu]
Assigning a unique hostname for
.CW "DHCP-DNS"
.IP \[bu]
Ensure that
.B "B.A.T.M.A.N"
is setup on startup
.RE
.RE

These functions are integral to the functionality of the project and are tedious and problematic to perform manually.
.SH 3
Interface Configuration
.PP
Unfortunately, the nature of most Interface settings on Linux is to be stateless, i.e. non persistent through power cycle.
This requires that we have a "setup" file on the device that is earmarked to run on every boot.
There are a number of ways to run a script on startup in Linux, described below.

.IP
.B "cron"
- The cron utility has a option to define a
.CW "@reboot"
flag which will run the command provided on startup.

.IP
.B "systemd"
- Systemd is the init system for most Linux disribution and the creation of "Service" can run functions at intervels, or on startup.

.IP
.B "rc.local"
- The /etc/rc.local file is a list of "0 exit" commands to be executed on startup as root.

.IP
.B "other"
- There are other ways to run something at differing stages of start, for example .xinitrc for the init stage of x, or .bashrc for shell initilisation, however these are too late in the boot stage.

.PP
From this list there are number of good contesters emerge.
Crontab is the easiest to use of them all, a user unique file inside
.CW "/var/spool/cron/crontabs/" .
The tool is very flexible and allows for running commands at defined times and periods up to monthly.
This functionality is slowly being phased out in most distributions in favour of the far more flexible Systemd Servies, although Raspbian does ship with crontab by default.
A simple systemd service merely requires six lines for basic setup, as described.

.CW
.TS
box centre;
l.
.SM
[Unit]
Description=Service Name
[Service]
ExecStart=/path/to/foo.bar
[Install]
WantedBy=multi-user.target
.TE
.R
.REF "3.7: systemd service"

This is somewhat more legible than the archiac but simple crontab layout;

.CW
.TS
box centre;
l.
.SM
@reboot /path/to/foo.bar
.TE
.R
.REF "3.8: crontab entry"

The flaw, however, with the crontab implementation is the @reboot flag is non standard and it is not garunteed to function the same across installs.
.[
crontabguru
.]
The other alternative mentioned is a rc.local file.
Appending to this before the exit 0 is not reccomended as the file states at the top
.I "Make sure that the script will exit 0" ' '
which we can ensure will happen if our script fails.
Thus for deployment of the scripts the systemd service is the most ideal solution for deployment.

.SH 3
Binary Deployment

.PP
In an enviroment where the deployed devices do not have internet it is important that they still have functionality.
To ensure this the
.CW "reporter"
Golang binary will be deployed by the script as it sets up the other facets of the device.
It should be possible to push updates to the (potentially) off network node's.
It is important however that this file is kept updated incase of security updates or functionality changes.
It is also vital that, especially in the case of a functionality change, that the devices have the
.B "same"
version so the database is not being sent differing entry fields, which will cause issues.
To this end a auto-updater is required to ensure this standard version across the devices, which is managed by the bridge node, as it is required to have internet access.
This could be performed by using a
.CW "NFS"
or
.CW "HTTP"
share of the file and its
.CW "SHA"
hash on the bridge pi, which the node's periodically check against their own to determine whether an update is needed.
This implementation is rather noisy, it would be ideal if the bridge could "tell" the nodes they need to update and check on restart if they need to in case an update announcement was made while they were offline.
However the need for extra dependencies over a simple
.CW "GET"
only
.CW "HTTP/Curl"
implementation is not ideal either in resource usage or complexity.

.NH 2
Hardware

.PP
There are a number of requirements, as described in the literature review, that must be met before a SBV can be considered viable to run the project.

Firstly, the most important is GPIO or I2C capability.
These are the protocols used to read the information from the pins, which are connected to the sensors.
Without this there is no way to get said information (unless a USB sensor is used, though this would defeat the purpose).
Secondly, the WiFi antenna on connected must support the
.B "ad-hoc"
mode that enables the use of
.B "B.A.T.M.A.N" .
Thirdly, the
.CW "reporter"
binaries are only compiled (currently) for the arm architecture, however as long as Golang supports the target architecture (x86, amd64 etc.) then it can be compiled to support it.
These are the only real restrictions on the hardware that can be used.

The hardware used in for the development of the project are the expected deployment targets, as discussed before.
The ubiquitous
.I "Raspberry Pi 3B"
and it's
.I "Pi Zero W"
companion will be used for the Bridge and Node respectively.
By developing on these devices the functionality of the tooling can be ensured to perform on the most likely candidates for installation, due to their cost and availability.
Further, the accessibility of the device means that a greater number of libraries for accessing a wider range of sensors and their reliability are for more prevalent.
The current number of Raspberry Pi related (public) repositories on
.B "GitHub"
currently lies at just below 7000
.[
githubrasp
.]
with projects using the GPIO headers numbering 650.
.[
githubgpio
.]
With this level of community engagement there is no comparison for support.

A major restricting factor in where the nodes can be deployed is power.
The
.B "Raspberry Pi's"
used run of a 5V power supply and draw ~100 mA at idle.
This gives the opportunity for easily battery powering them.
A number of options exist to battery power the
.B "RPi"
from jury rigging laptop batteries to using car batteries.
However the easiest, and thus most likely, configuration is simply a power bank.
It is important to ensure when using this that the powerpack will deliver 5v and not undergo under and over volting as the charge depletes, a common flaw with cheaper models, as this will cause issues with the weak regulator in the
.B "RPi"
ranging from a power cylce to a burnout.

.SH 3
Storage

.PP
In the test deployment
.B "InfluxDB"
is setup locally on the bridge.
This is typically not an issue as as shown below, even with over 37K (37 000) entries, the database size is still very managable.

.CW
.TS
box centre;
l.
.SM
# number of entries
# connect to the database
$ docker exec -it sensordb influx
    Connected to http://localhost:8086 version 1.7.5
    InfluxDB shell version: 1.7.5
    Enter an InfluxQL query
    > use main
    Using database main
    > select (host, water_current) from usage limit 1
    name: usage
    host            water_current
    ----            -------------
    sensor-a2e7ea02 17
    > select count(water_current) from usage
    name: usage
    time count
    ---- -----
    0    37758
    > exit
# Size on disk
$ docker exec sensordb du -bsh /var/lib/influxdb/data/main
33M     /var/lib/influxdb/data/main
$
.TE
.R
.REF "3.9: Row count of InfluxDB vs. size on disk"

However in a production enviroment with many hundreds of sensors this database may need to be stored (physically) on an external Hard Disk Drive
.B "HDD"
or on a cloud DBMS, such as Amazon's DynamoDB.
Although again, this is somewhat outwith the remit of the project and would be to the discretion of a user deploying the tools.

.SH 3
Bridge

.PP
The Bridge node has to perform the function of creating a bridge between the WLAN or LAN it's attached to and the Mesh-Network that the nodes communicate within.
There is not actual requirement for a bridge node in a mesh network, however as we want to exfiltrate data from the mesh nodes it is required.
As it  sits on the outside of the network it is in a prime position to run the InfluxDB server and the API, described earlier.

For it to function in this bridging function however two interfaces are required, one wireless and the other valid interface (LAN, WLAN, IPoAC etc.).
The setup files will use
.CW "wlan0"
as the primary interface for the mesh network, and another most often
.CW "eth0"
as the network to bridge to.
This device needs to be inexpensive and developer friendly to enable easy adoption.
Although the use of a ZigBee antenna was mentioned in the Literature Review, this additional cost and complexity to setup (for the user) is enough to offset the gains.
Out of the hardware options researched the
.B "Raspberry Pi (2, 3, 3B)"
are the best suited for this task as they come with the BCM43438 WiFi antenna and a generic 10/100 LAN interface.
This wireless card is also able to support the Ad-Hoc mode which we require to interface with the mesh network, making it the ideal candidate.

.PS
lineht = lineht/4

X: circle rad .3 "node x"
move down
move left
Y: circle rad .3 "node y"
move right
move down
right
Z: circle rad .3 "node z"
move up
move right
N: box "bridge"
arrow <-> dashed
box dashed "network"

arrow <-> from X.s to N.w
arrow <-> from Y.e to N.w
arrow <-> from Z.n to N.w
.PE
.REF "3.10: Network topology of the bridge node"

.SH 3
Nodes

.PP
The nodes are a much simpler requiring a minute amount of proccessing power.
As discussed in the Literature Review an Arduino is a strong choice for the nodes due to its incredibly low power consumption.
The ability to compile
.CW "C"
code for it is also very compelling, as this could be heavily optimised by the
.CW "Clang"
or
.CW "GCC" .
However the requirement of an extra purchase, the WiFi shield, makes it undesirable in the goal of making the simplest setup for users possible.
Thus the Raspberry Pi Zero W is the compelling choice.
The Goland code compiles to a native binary, meaning no abstraction layer is required, increasing the performance.
Further by using cron to handling scheduling of the program it does not need to run in the background constantly, instead we can use cron to implement the job of a
.CW "while true, run code & sleep 1m" .
To demonstrate the networks functionality a number of sensor nodes will be setup to show fucntionality.
.bp

.NH
Implementation
.NH 2
Development Practices & Tools
.PP
When developming this project the
.B "Agile"
proccess was opted for.
This approach is based on the natural, iterative proccess of software development.
The proccess of design, implementation and redesign is key to this project and through this interative proccess the functionality was refined and edge cases worked out.

The use of the VCS
.CW "Git"
by Linus Torvalds has allowed for a rapid development enviroment while undertaking the project.
The Agile software development approach has complimented this with use of
.I "branches"
and being able to move between different code versions quickly and easily.
As the codebase was developed for the two major sections of code, web accessible repositories were used to ensure a seamless work environment between development locations and provided a backup mechanism incase of a disaster.
Further, the afformentioned branches allowed a master branch to be kept in a tested-working state at all times while a development branch was used to develop new features and bug fixes.
This approach is to development is described as a Production / Development branch.

By implementing
.B "GitHub"
into the workflow,
.I "issues"
were able to be used in to raised for bugs, feature and concerns and tracked by marking them with flags.
In this way I was able to employ an the Agile development approach, by generating a number of issues and then clearing them all in a sprint.
Using the release functionality allowed seperate releases to be produced, which the setup script can pull or alternatively for a build from source options.

.NH 2
Setup Tools
.PP
The setup tools are provided by the primary repository for the code.
The primary file for the project deployment is the
.CW "prepare-sd.sh"
file which provides the setup for the document.
The output from this depends on the provided options, an example setup for a
.B "Raspberry Pi Zero W" ,
which uses the ARMv6 architecture, is below.
The script will obtain and install the latest version of the
.CW "Raspbian Lite"
image from
.CW "raspberrypi.org" .

.CW
.TS
box centre;
l.
.SM
$ ./prepare-sd.sh
::    Is this a Node(0) or Bridge(1) [0]
::    Pi2 and 3 are armhf, Pi0 and Pi1 is armel
::    Choose either armhf or armel: armel
::    Listing out available drives
mmcblk0     179:0    0  3.7G  0 disk
::    Specifiy drive: /dev/mmcblk0
::    Are we deploying to an eduroam network [y/N]
::    Should SSH on port 22 be enabled? [Y/n]
::    Hostname set to sensor-abd44a41
:: WARNING : This will erase all data on /dev/mmcblk0!
::    Are you sure? [y/N] y
::    Writing 352M to /dev/mmcblk0
::    This may take a while
:: INFO : Finished writing to /dev/mmcblk0
:: INFO : Creating mounting directories
:: INFO : Mounting /dev/mmcblk0p to sd/
:: INFO : Moving files
:: INFO : Unmounting /dev/mmcblk0p
::    Install finished
$
.TE
.R
.REF "4.1: Output from the prepare-sd script"

There are a number of user required inputs during the process which ask the user for information about the enviroment that it cannot infer.
These options are as follows:
.IP \[bu]
Whether a Node or Bridge is being created.
.IP \[bu]
(If "Node" is chosen) ARM architecture that the script is deploying to ensure that the correct binaries are copied over to the device (the
.B "B.A.T.M.A.N"
setup deb archive and the correct compiled
.CW "reporter"
binary).
.IP \[bu]
The location of the /dev[ice] which the script should mount to. Special care is taken here to filter out the root device of the device running the script so a user does not brick their own machine.
.IP \[bu]
An option to deploy to the "eduroam" network. This option is included for any networks which will not correctly assign a DHCP address to devices inside the mesh network.
.RS
.IP \[bu]
If [y] is selected then the user is asked to manually assign the IP address of the device, and a corresponding hostname is chosen.
For example if
.CW "172.16.0.22"
is the IP then the sensor would be
.CW "sensor-22" .
.RE
.IP \[bu]
Whether or not SSH should be enabled on the device
.IP \[bu]
A final confirmation before writing to the selected disk, this option defaults to no.
.PP
This allows a multitude of differing options to be provided with the minimal amount of requirements for running the script.

.SH 3
Network

.PP
Some networks, such as the
.I "eduroam"
network on campus, does not correctly assign IP Address' inside the mesh network.
To account for this our network will have need to have two "types" to handle occasions such as this, hence the user is prompted if they are deploying to such a network.
If this option is slected then the script will assign a Static IP address to the device.
It is worth nothing that inside the mesh network nodes can still commmunicate with each other using the self assigned IP address
.CW "169.254.16.8" ' '
for example, however this is not predictable and thus nodes could not be contacted programmatically.
Further complicating things, if there is no DHCP server then it unlikely a localDNS server, and thus hostname communication is impossible.
A daemon such as Avahi could be used however it extremely unreliable in testing and far too slow to be used in such a dynamic network.

For this reason the first task of the script is to obtain the dependencies needed for the pi's after they have been setup.
This way there is no need for a node to require internet as it already has everything it needs.
Further, with the bridge node setup to provide updates to the nodes inside the network, nodes never need to connect to the internet directly.

.SH 3
Naming

.PP
When determining the name of the device, a number of considerations must be taken into account.
Collisions must be avoided within the network, so a large namespace will be required however, these will be stored with every database row so the name shouldn't be too long.
With this in mind two paths where chosen, if the IP adress is defined, simply affix the IP address to "sensor" to get, for example
.CW "sensor-122" .
When using DHCP however this cannot be known, nor can we be sure the IP wont change.
To this end, a function is used to generate a unique name, the current date as a string is hashed using md5, then the first 8 characters of that are taken with
.CW "date | md5sum | cut -c1-8" .
This gives us a predictable, repeatable way of generating names with increadibly low overhead while providing a huge namespace.
From this we can suffix those 8 chars to the name to get
.CW "sensor-adb44a41" .
This proccess however is not requried for the bridge node as there should only be one in any given mesh, and thus the name will be generated as
.CW "sensor-bridge" .

.SH 3
Burning

.PP
Because this script is aimed to be used by a wide range of users, the usability of the script across a number of install configurations must be ensured.
Further,
.CW "unzip"
is opted for as not only does it save extracting the file (saving time and disk space) it means the date prefix of the .img does not need to be considered.
To this end, a number of checks are made.
A typical Linux distribution will have
.CW "unzip"
installed which allows us to unzip the archive directly onto the sd card using
.CW "tee" .

Alternatively if the user does not have a
.CW "unzip"
installed (as
.CW "tee"
is POSIX)
then the img file will be dd instead.
Although it is common for dd to be used to burn images it is far slower than simply using cat.

.CW
.TS
centre;
l|c.
.R
.B
Command	Time (Real)
.CW
_
unzip foo.zip | tee /dev/bar	5m 4s
dd if=foo.img of=/dev/bar	8m 18s
.TE
.R
.REF "4.2: Comparative burn times for tee vs dd, timed with 'time'"

.SH 3
Software
.PP
The software depends on the type of device being created, be it a node or bridge.
For a bridge the
.CW "batctl"
software is required, along with the
.CW "bridge-utils"
package which allows the bridge to be created.

Initially it was envisaged to use the far newer
.CW "ip"
package tools which are intended to replace
.CW "ifconfig"
and
.CW "bridge-utils"
to perform the bridging, however when attempting implement this on the RPi's it would cause constant errors.
This was very unfortunate as it required the need to install the
.CW "bridge-utils"
package, causing an extra layer of complexity.
The package provides the two commands run in the
.CW "setup.sh"
script that is deployed to the devices.
These are the
.CW "brctl addbr"
which we create the bridge with and
.CW "brctl addif"
to add our interfaces to it.

.bl
.CW
.TS
box centre;
l.
.SM
$ brctl addbr foo
$ brctl addif foo bar0
$ brctl addif foo bar1
.TE
.REF "4.3: using batctl to create a bridge"

.PP
The
.CW "batctl"
package also has issues.
The most current version of batctl is 2019.0 which is provided from the Debian repositories.
The current available version of batctl from the Raspbian repositories is 2016.5.
However, as the open-mesh website requires 2017.3 for kernel version 4.14 (running on the Raspbian) or higher.
As the source is provided from their repo or (batctl-2017.3.tar.gz) could be shipped and compiled on the nodes.
Though this would have added an additional dependencies (libnl-3 and libnl-genl).

Installing batctl version 2019.0-1 from the Debian Sid repository works as expected on both the Raspberry Pi 3B and the Pi Zero W.
However attempting to run any batctl command on the Pi Zero W  with this version will result in a segmentation fault error, but will work on the Raspberry Pi3B.
Version's 2016.5 (from the Raspbian repo) and 2017.3 (compiled) do not share this issue.
To create a further problem, batctl 2016.5 in the Raspbian repository causes the bridge node (running on a Raspberry Pi 3) to become unreachable despite still passing traffic into and out of the mesh network.
Compiling is not ideal as serpate
.CW "dev"
packages must be provided to the Pi's and compiling from source takes over five minutes.
Thus, seperate versions must be provided depending on the type of device we are creating.

.NH 2
Node Software
.PP
The nodes have a Golang
.B "Go" ) (
binary deployed to them by the
.CW "prepare-sd.sh"
script.
This program reports the information from the sensor attached, to the
.CW "HTTP API"
of the
.B "InfluxDB"
instance running on the bridge.
Golang was chosen as it does not require any dependencies to run once compiled, meaning no further dependencies need to be deployed to the Node to run it.
It also allowed me to explore an entirely new language which has been gaining traction in the past few years.
In addition it has the ability to
.I "cross-compile"
to other architectures, meaning the device building code does not need to be the same architecture of the device running it.

A number of tools are made available to insert data into an InfluxDB instance.
InfluxDB provides and maintains a Go, along with python, JS and other language, client library that handles database connection management and query injection protection.
Influx also has a HTTP API that is accessible, by default, through port
.CW "8086" .
This allows encoding of data in the URL or in the HTTP Form.
In it's simplest form to insert data into a database a number of steps must be performed.


.CW
.TS
box centre;
l.
.SM
#!/bin/env python2.7

from influxdb import InfluxDBClient

# Database connection
db = InfluxDBClient(host="foo.com", database=bar)

# JSON message
msg = [{
  'measurement': 'test',
  'tags': {
    'host': sensor
  },'fields': {
    'variable': 10,
}}]

# write to db
db.write_points(msg)
.TE
.REF "4.4: Simple InfluxClient in Python"
.R
This is a very verbose implementation with many working parts.
It also requires us to use the InfluxDB language to move the data.
The alternative to this however is far simpler and can be implemented in CURL, in a single line.

.CW
.SM
.TS
box centre;
l.
$ curl "foo.com:8086/write?db=bar&test,host=sensor variable=10"
.TE
.NL
.R
.REF "4.5: Insert data using CURL"

This method is far less verbose and far more portable.
CURL is a Unix utility found in all major Operating Systems and is incredibly powerful.
The reporting to the database could be implemented in CURL however there are no implementations for GPIO reading in BASH.
Thus a medium of using Go to handle the reading of the GPIO pins and its built in HTTP library to interface with InfluxDB's HTTP API.

.KS
In its most basic form in Go, a HTTP request takes the following form.
.CW
.SM
.TS
box centre;
l.
client      := &http.Client{}
request,  _ := http.NewRequest( "GET" , "foo.com/bar" , nil )
response, _ := client.Do( req )
.TE
.NL
.R
.REF "4.6: Simple HTTP Reqeust in Go"
.KE

Initially the Client from the "http" package is created.
Then a "NewRequest" is created which contains the type of request,
.CW "GET" ,
.CW "POST" ,
.CW "DELETE"
etc. followed by the URL or IP Address of the target and finally the content of in the request.
This request is then passed to the http.Client initally created which then "Do[es]" the request defined previously.
This returns a http.Response which which contains a
.CW "Head" ,
with the headers and a
.CW "Body"
containing the actual content.
Content returned could be in the form of a HTML docuement to be displayed or a JSON string to be parsed and converted into Data.
The response can be read if desired as the API may return a succcess or failure string in either the header as a
.CW "403"
code for example, or in the Body as a JSON string
.CW "error: true" .

During the testing of this code, test data was generated from Go's
.CW "rand.Intn()"
method, to be supplied to the database.
By using this, I was able to test the network infrastructure and setup script reliablity very easily without the need for the sensors, throwing an additional variable into the mix.

.CW
.TS
box centre;
l.
.SM
// client to used to connect with
const url = "http://sensor-bridge.local:8086/write?db=main&"
cln := http.Client{}

// test data
lvl := strconv.Itoa(rand.Intn(12))

jss := "usage,host=sensor-foo water_level=" + lvl
jsb := []byte(jss)

// create the post request and set the content type
req, _ := http.NewRequest("POST", url, bytes.NewBuffer(jsb))

req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

// attach the request to the client and send
res, _ := cln.Do(req)

res.Body.Close()
.TE
.R
.REF "4.5: Simplified Go code for submitting a database entry"

The above simplified code shows the steps taken to submit information through the HTTP API of InfluxDB using the default http package provided by Go, as desribed.
Using HTTP to perform the query has a number of advantages.


.NH 3
Database Structure
.PP
The
.B "InfluxDB"
instance being used is being deployed through the
.B "Docker"
container provided by the official builds.
This allows us to abstract the most vulnerable part of the bridge nodes exposed side (the DB) to a container.
If a security flaw was exposed it would not affect the node itself.
The database is a NoSQL database and thus does not have a strict database layout, however the hostname of the device reporting back is marked as a "tag" for indexing purposes.
This acts as a fast way for the Influx Query Language to find the things searched for.

.NH 2
API
.PP
The API is in the form of a RESTful HTTP API written in Node.Js.
Incoming GET Requests are handled by the express server and query the database directly based on the paramaters sent.
The results from the database are then parsed and turned into a JSON Object that can then be parsed by the front end.

.NH 2
Web Client
.PP
The web interface is a simple implementation of two D3 libraries, Cubism and Parallel.
These allow the user to get an at a glance view of the information in the database, without needing to do any querying directly.
A realworld implementation of this project would expect users to deploy their own interfaces, if at all, as stated earlier the goal of the project is to build the framework.

.IMAGE
\# TODO : insert image of the UI

.NH 2
Hardware

.SH 3
Sensor

.PP
The sensor's were deployed on the Raspberry Pi Zero W's as mentioned in the design section.
This made development very easy as these devices, being fully fledged Linux installs, could be SSH'd in to read system logs to determine faults and prototype fixes in real time.

\# TODO : insert image of RPi0w
.FIG "3.11: Typical Raspberry Pi Zero W with DHT11 attached" "images/raspberrypizerowdht11.eps"

.PP
This is what a typical sensor node would look like.

.bp
.NH
Testing and Results
.PP
\# TODO : Do some testing
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
