\# TODO : expand the abstract
\# TODO : more on the ethics
\# TODO : ONGOING : keep ToC up to date

.nr PSINCR 2p
.nr GROWPS 4
.ds LF Shaw Eastwood
.ds RF %
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
Report Structure

.PP
This report details the process required to construct a distributed mesh network of sensors.
The report will walkthrough the process undertook to create the open source tooling that has been made available with the release of this document.

.bl
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
.bl

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
.IMAGE
.TS
centre;
c.
.I
Fig 1: SEPA Monitoring Station.
.[
Wallace2012
.]
.R
.TE

In 2005 the WFD reported 285 type 1a and 1b "at risk" bodies of water.
.[
SEPA2007
.]

By'2006 253 stations such as the one pictured in Figure 1 were in place across Scotland representing 10% of the country's total water bodies and 26% of the 989 "at risk" rivers as of 2009.
.[
SEPA2009
.]

.IMAGE
.TS
centre;
c.
.I
Fig 2: Monitoring Stations in Scotland.
.[
SEPA2006
.]
.R
.TE

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

.IMAGE
.TS
centre;
c.
.I
Fig 3: Air Quality Map
.[
OKLabStuttgart2018
.]
.R
.TE

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

.IMAGE
.TS
centre;
c.
.I
Fig 4: Raspberry Pi Zero
.[
Amos2016
.]
.R
.TE

The Raspberry Pi 3B+ on the other hand is a much better fit for a server/command and control device.
.[
Leccese2014
.]
With it's more powerful CPU increasing the power draw to an idle of ~500mA
.[
RaspberryPiFoundation2018
.]
powering this from a battery wouldn't be ideal. Instead it should be used to connecting a LTE adapter or Ethernet cable to connect the endpoints to the larger LAN or WAN for sending information back to a central server.

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

.IMAGE
.TS
centre;
c.
.I
Fig 5: Raspberry Pi 3B+
.[
RaspberryPiFoundation2018a
.]
.R
.TE

.SH 3
Other

.PP
Many other SoC's include the ASUS tinker board and BeagleBoard among many others.
Other SoC's target features found lacking in the Raspberry Pi, namely Gigabit Ethernet and increased RAM or reducing power consumption and SoC size.
These make them compelling choices in scenario's where size or bandwidth etc. are essential however these other board's are often more expensive and even more difficult to source.

.SH 3
Comparison

.PP
.bl
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
.bl

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

.IMAGE
.TS
centre;
c.
.I
Fig 6: Arduino Nano
.[
Mellis2010
.]
.R
.TE

.RS
.RS
.RS
.[
MouserElectronics
.]
.RE
.RE
.RE

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

.I
ZigBee vs. a number of other wireless network
.[
RaspberryPiFoundation2018
.]
.[
RaspberryPiFoundation2017
.]
.R
.RE
.bl

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
The Arduino suits this role more than the Raspberry Pi Zero in terms of power consumption and having the Analog pins available with no additional modules necessary.

.PP
In contrast it's clear the lack of computational power on the Arduino Uno makes the Raspberry Pi 3B+ the clear winner for the command and control 'server' for the endpoints to report back to.
It's increased power consumption can easily be offset if it is placed in a position with a hard line power source which may not be able to reach the other devices.
Further if Ethernet/ADSL can be used it far better placed to interface with a physical connection.
Alternatively the additional demands on the hardware of a GSM/LTE adapter and connection will be offset with the more beefy device.
.bl

Network choice is majorly dependant on the topography of the terrain the devices are being deployed in.
If foliage is a major issue then the already weak WiFi is going to be inoperable and ZigBee will be essential, however if there is little vegetation then WiFi may be viable alternative to keep costs and complexity low.
.bl

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
.B "Raspberry Pi Zero"
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

.TS
centre;
c.
.I
Fig. Mesh Network with four nodes.
.R
.TE

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

.TS
centre;
c.
.I
Fig. Mesh Network with six nodes.
.R
.TE

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
.bl

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
.bl
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

.bl
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

.bl
.R
Whereas running the
.CW "git log"
with the arguements
.CW "--no-pager log --oneline -n 1"
would produce the following.

.bl
.CW
.TS
box centre;
l.
.SM
$ git log --no-pager log --oneline -n 1
63701fb (HEAD -> master) fix heading type
.TE
.bl

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
.bl
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
.bl
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

.bl
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
.bl

This is somewhat more legible than the archiac but simple crontab layout;

.bl
.CW
.TS
box centre;
l.
.SM
@reboot /path/to/foo.bar
.TE
.R
.bl

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
The hardware used in for the development of the project are the expected deployment targets, as discussed before.
The ubiquitous
.I "Raspberry Pi 3B"
and it's
.I "Pi Zero"
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
.bl



.bp
.NH
Implementation
.PP

.SH 3
Network Oddities

.PP
Some networks however, such as the
.I "eduroam"
network on campus, does not correctly assign IP Address' inside the mesh network.
To account for this our network will have need to have two "types" to handle occasions such as this.



.NH 2
Deployment Tools
.PP
This project has relied heavily on Git to provide a versioning of the code.
As previously stated the project is divided across different Repositories, this allows seperate releases to be produced, which the setup script can pull (if not building from source).
\# TODO : Expand

.NH 2
Setup Tools
.PP
The setup tools are provided by the primary repository for the code.
The primary file for the project deployment is the
.CW "prepare-sd.sh"
file which provides the setup for the document.
The output from this depends on the provided options, an example setup for a Raspberry Pi Zero, which uses the ARMv6 architecture, is below.
.bl
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
.bl
.R
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
A final confirmation before writing to the selected disk, this option defaults to no.
.PP
This allows a multitude of differing options to be provided with the minimal amount of requirements for running the script.
.NH 2
Node Software
.PP
The nodes have a go binary deployed on them by the
.CW "prepare-sd.sh"
script which reports the information from the sensor attached to the
.CW "HTTP API"
of the
.B "InfluxDB"
instance running on the bridge Pi.
Golang was chosen as it does not require any dependencies to run once compiled.
In addition it has the ability to
.I "cross-compile"
to other architectures, meaning the device building code does not need to be the same architecture of the device running it.
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
.bl
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
