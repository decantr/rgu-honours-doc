.TL
Distributed Mesh Sensor Network using Raspberry Pi's
.AU
Shaw Eastwood
.AI
Robert Gordon University
.SH
Introduction
.XP
The Internet Of Things (IoT) is an ever growing market with ZigBee and WiFi powered devices becoming more and more prevalent in peoples homes.
Much of this stems from the rise of (Ultra)-Low Power IoT Devices (LPIoTD) that are used by enterprise to deploy sensors to inform automation systems.
This is commonly used for things such atmospheric control where a number of sensors in a room will allow a central server control temperature and air conditioning to each room individually.
The use of these LPIoTD is expanding into other areas, such as river monitoring, as described in my literature review, which was previously a manual task performed weekly.
.XP
By harnessing this technology we can gain a deeper understanding of how variables from different aspects of life can have an affect.
Unfortunately the majority of these implementations are proprietary.
Anyone interested in deploying such a network would be required to obtain a bulk purchase of potentially hundreds of Single Board Computers
.B "SBC" ) (
which are purpose built for the task and pay licensing fees.
Thanks to the rise of the Non Profit "Raspberry Pi Foundation" and its (mostly) open source "Raspberry Pi" line, we have access to a plethora of Low Power SBC'S which we can leverage to produce our own LPIoTD.
.SH
Project Aims
.XP
This project aims to provide an open source and easy to deploy utility for setting up a monitoring system.
It will provide a framework to allow others use or build a top, opening up the field to a wider range of people from enthusiasts to small business.
A reliable backbone will be essential to providing a useful piece of software and built using secure and stable software.
.SH
Methods
.PS
lineht = lineht / 4

SB: box width 2 "sensor-bridge"

left
line <- from SB.w
line
circle rad .4 "\fIsensor-x"

up
line <- from SB.n
line
circle rad .4 "\fIsesnor-y"

down
line <- from SB.s
line
circle rad .4 "\fIsensor-z"

right
line -> from SB.e
box "influxDB"

line <->
box "\fRWeb UI"
.PE
.XP
The project is divided into three distinct sections, the setup scripts written in POSIX complaint shell, a program to facilitate the reporting of readings from the sensors written in Golang, due to its ability to cross compile binaries, and a Spartan Web UI.
This UI is expected to be expanded up on by users of the tool as different data types will require different forms of representation.

.SH
Figures
.XP
.SH
Results
.XP

.SH
Conclusion
.XP
.SH
Acknowledgements
.XP
.SH
References

