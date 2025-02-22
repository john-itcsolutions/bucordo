## PLEASE NOTE THAT THIS REPO HAS MOVED TO:

https://bitbucket.org/itotcca/bucordo

Thanks.









Bucordo - a table-based replication system: descended from bucardo https://github.com/bucardo/bucardo
        - This adaptation aimed at achieving Automated Trust - with the immutability and automatic Trust of a Blockchain:
	With heaps of data capacity, yet with no mining.

DESCRIPTION:
------------

This is version 0.0.1 of bucordo.

COPYRIGHT:
----------

    Copyright (c) 2005-2022 Greg Sabino Mullane <greg@turnstep.com> (Bucardo)
    And our Fork:
    Copyright (c) 2022 John Lloyd Olsen <john@itotchaincloud.com.au> 
    on behalf of IT/OT Chain & Cloud Australia. (Bucordo)

REQUIREMENTS:
-------------

    build, test, and install Perl 5                (at least 5.8.3)
    build, test, and install PostgreSQL            (at least 8.2)
    build, test, and install the DBI module        (at least 1.51)
    build, test, and install the DBD::Pg module    (at least 2.0.0)
    build, test, and install the DBIx::Safe module (at least 1.2.4)
    
    You must have at least one database that has PL/pgSQL and PL/Perl installed.
    Target databases may need PL/pgSQL.


WEBSITE:
--------

Please visit https://bucardo.org for complete documentation of the original Project.

DEVELOPMENT:
------------

To follow or participate in the development of bucardo, use:

git clone git@github.com:bucardo/bucardo.git

GETTING HELP:
-------------

For general questions and troubleshooting for bucardo, please use the bucardo-general@bucardo.org
mailing list.  GitHub issues which are support-oriented will be closed and referred to
the mailing list anyway, so help save time for everyone by posting there directly.

Post, subscribe, and see previous archives here:

https://bucardo.org/mailman/listinfo/bucardo-general

______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________

## THE NEW BUCORDO

This project is based on  Docker and the Debian/Ubuntu branch of Linux, as well as Lxd, Juju, Charms and Kubernetes; merged with Cyber Republic's Elastos Smartweb gRPC-based Blockchain and Database Server. Database ORM, reflection (at initialisation) and querying uses SQLAlchemy. There has been a major shift in the foundations of our seminal Repo 'cheirrs' (https://github.com/john-itcsolutions/cheirrs), with a new discovery by us, of research by IBM from 2019, which could potentially remove the need for our customers to actually invest any more than a modicum of Trust in ITOTCCA (quite transparently), with the concept of "Blockchain meets Database". The blockchain end of a transaction still occurs first, followed by writing or reading of data to or from Postgres, via the "etcd" (or you can use redis) cluster on the Kubernetes installation. However our intention is to follow the lead of research from IBM in India, where apparently a practical way of making a database as immutable and tamper-proof as a blockchain, has been discovered, for the purposes of Smart Contract Trading and any internetworked (or non-internetworked) transactions. The paper, Blockchain Meets Database: Design and Implementation of a Blockchain Relational Database
∗
Senthil Nathan 1 , Chander Govindarajan 1 , Adarsh Saraf 1 ,
Manish Sethi 2 , and Praveen Jayachandran 1
1
1
IBM Research India, 2 IBM Industry Platforms USA
(snatara7, chandg12, adasaraf, praveen.j)@in.ibm.com, 2 manish.sethi1@ibm.com

.. refer to this link:  https://arxiv.org/pdf/1903.01919.pdf ..


has revealed that it is possible to provide Trust in a natural way in networking between Companies, whilst basically distrusting each other, by making a network of Postgres Databases behave like a large-data-capacity blockchain. To ITOTCCA, this is revolutionary. Prospective customers will no longer have to trust our company to any extent as far as daily operational security is concerned. Neither do they have to trust other companies. The idea is to allow the machines operated by each Company to keep each other honest. There is a hole in the plan, in that if globally over 50% of Ordering nodes were to be caused to act fraudulently, the factor of Trust would be destroyed. Elsewhere (on our website at itotchaincloud.com.au/security) we note the contribution of Rong Chen and Elastos in devising a hardware enhancement which is necessary for Blockchain Miners to be fitted with in order to be able to participate in Mining. This device ensures by design that no corps can act together in a gang of >50% ownership and direction. The idea is currently operational with Elastos. If a similar device were fitted to ordering servers, collusion could possibly be prevented. This requires investigation. Alternatively, it may be possible to utilise the Elastos Blockchains to provide a Fraud Check service against the database.

These developments have caused ITOTCCA to review our monolithic design, opting now for an isolation of Business Networks at the permissions level from each other and restricting the scope of connectivity to be strictly internal to each separate Business Network (of course external web-connections will still be possible, but safely shielded by whitelists under Carrier (see itotchaincloud.com.au/security). Future enterprise growth in network demand requires networks to be performance optimised and segmented (isolated) to provide access with performance. The design is now to have a range of cloud servers per Business Network, usually with one "site" per Member Class. Each member-class (represented by its own schema) would ideally take responsibility for its own virtual hardware. The virtual servers are all to be  linked between member-class nodes within a Master/Master replication system. All member-classes carry identical copies of the entire network's databases, with one strictly private Business Channel per member (company), enforced by the hardware/software in the cloud, including the RBAC (Role Based Access Control) permissions system. Here, the machines are designed with the goal of ensuring clean play all the time, following the blockchain model.

However, in the above article, it is envisaged that a section of non-internetworked transactions would be outside the network. This implies that a company's own employees, and their connecting devices, can be trusted more than the internetworked transaction parties. We believe this to be highly questionable.

To this end, we are striving to implement a Hybrid model with 2 layers. We intend to offer a system which, for even the most trivial of transactions or actions, records traces on the Elastos Blockchains, an immutable source of Truth which also provides a Distributed Identity Blockchain (DID Sidechain). This will mesh with the Postgres 'DataChain' (or 'BlockBase') to provide indisputable Identification of players across the entire system (so-called Non-Repudiability of transactions). Elastos is a Global Network Operating System with permissioned Blockchains. Naturally the bulk Corporate Data will belong on the new databases, but there is a role to be played by the  flexibility and mobility of the Elastos system, especially when we consider the strengths of Elastos Essentials and dApps, Carrier's security and the DID Sidechain together. So we still intend to utilise the Elastos-Smartweb-Service github repo and docker image to play the role of joining the DataChains systems to the Blockchains systems, by acting as a very smart webserver and database server and blockchain server; all at once.

gRPC protocols replace the older style REST APIs, for communicating requests, and data inputs, from the client, and responses from the blockchain &/or database back to the client; all this occurs through the smart-web server, employing a "microservices" architecture. Here the gRPC protocols are implemented in Python. The smart-web server has Carrier installed onboard, guaranteeing security. Carrier is also installed via plugin on the Ionic dApp clients (which are developed hierarchically inside Elastos.Essentials - which we admit to having a defcit in technical capacity for in development) as well as manually on the IoT Edge client/servers (running 'node-red').

To tackle the full set of Kubernetes installations locally, ideally you would need (for 3 multipass vm's with a microk8s installation on each) a 64 GB RAM (minimum); 16 core cpu; 250+ GB SSD; + second HDD: PC (x86_64). eg an Extreme Gaming Computer. If you intend to include Machine Learning/AI capabilities, you really need an Accelerator NVIDIA GPU of at least 10GB vRAM. This allows approximately three member classes with corresponding Ordering Services (residing on the second workers) to develop with. However the most powerful way to develop here is to use Docker (see below). The current state of our Infrastructure can be represented figuratively:

<img src="./ITCSA_Plan_3.png">


The following figure represents any of the 'master-x' controllers with their 'werk-x' models.  
We are still working on the design of the Transaction Ordering Service (based on bucordo).

We base initial development such as this locally. It's cheaper!



<img src="./kubernetes-02-05-2022.png">

The schema above are labeled G(n,m) for the internetworked, multiple member class dApps. In reality there is one schema/member-class 
(m-c: see https://itotchaincloud.com.au/the-general), across all business subnets. The single member classes, ie non-internetworked 
dApps (F(i)), are likewise constituted of all members of a network or dApp subscribers' group, on their own single-member-class 
schema. Although this is the case with the set F(i), within a single network ie schema ie dApp (in the F(i) case), we will be 
able to use the field for a member's id to distinguish between members' different dApp requirements and proliferate different 
(custom) tables and processes within a single network/dApp/schema. While the same is ideally the case for the G(n,m) set, such 
individual member Tables and dApps being theoretically possible, the design and coding would be expensive. Thus, by following the 
IBM research lead, we can say there would be one copy of the above installation per member-class, and arranged, configured and 
coded to ensure these databases interact as Masters in a data-intensive Blockchain-type assemblage. Therefore possibly as many as 
3 for cheirrs, chubba morris and convey-it, plus as many of the internetworked member classes as existed on their own Business 
Subnets alongside other member-classes from other Business Subnets. eg member-class(n,m) with n == business sub-network id and 
m == member-class id. Within member classes there may be many (or few) actual independent members (Companies).

# BlockBases or DataChains

This is a schematic of our 3 + 1 node (Kubernetes) development setup.

<img src="./devel-schematic-03-07-2022C.png">

At the virtual server level, there will be one virtual Master copy of a database-and-server per member class, with the network 
extending across all private business subnets. This means that all signed-up Business Networks actually constitute sub-Networks 
of the entire system, where member-classes constitute 2nd level sub-networks, in their own combined Business Level network, ie 
subnets as network members of ITOTCCA's overall network including all signed up Business Networks. Please refer to the following 
figures.


<img src="./datachains-slide1_2.png">


<img src="./datachains-slide2.png">


<img src="./datachains-slide3_4.png">


<img src="./datachains-slide4.png">


<img src="./datachains-slide5_2.png">



The Internet of Things (IoT) system revolves around the IoT node-red servers on the Edge Client/Servers, being in communication with node-red server residing in the cloud and communicating via gRPC protocol buffers with separate Smart-Web server. The smart-web server receives notifications from the node-red server and passes on relevant IoT events to both blockchains and database, also communicating with the IoT Admin dApp.

This system also has the capacity for the Smart-Web server to intercept orders (for example) requiring Operational Technology Domain events to occur (eg manufacturing) and to send an order summary as a python dictionary-styled object in text to the Node-Red server using node.js. The text is converted to a JavaScript object and operated-on by Node-Red, penetrating into the OT domain safely (possibly involving the Ctrl-X movement automation platform).

The actual "Things" generating messages and signals are connected at the sites by raspberry-pi "edge" clients or similar (eg one of Canonical's Partners offers "Industrial Pi" with Ubuntu Certification, ready for the Ubuntu "Core" reduced-footprint Operating System). The administration of the IoT system occurs on the IoT dApps, connected by node-red as well as python-grpc to the server(s) and by the IOTA onboard client to the "Tangle" for event validation (as for the node-red cloud  server and the edge server). The IoT Admin dApp can be split effectively to allow networks to be under your own control and respomsibility. Both notification and actuation are possible, however with actuation, the response time of the system needs to be considered, as a cloud based server may not satisfy the sub-millisecond requirements of some machinery. Edge-based servers would need to handle such operations. The systems such as this are communicating Notifications to the Smart-Web Servers for database and blockchain recording purposes and to allow IoT Administrators to act as appropriate. Also the SmarWeb server will be able to direct an Enterprise Data Item received which requires IoT (Operationaal Technology) actuation (eg a Sales Order for manufacturing) to the Node-Red server to be introduced into a production line. Flexible manufacturing. That is, any electronic control required is provided either by the IoT devices themselves, or via components like Industrial Pi servers, locally, for groups of devices, but some types of initiation can occur through the Enterprise IT system. All communications are shielded securely on networks by Elastos Carrier, requiring the Carrier-Native and its Nodejs and Cordova "wrapper" packages to allow node.js and typescript apps to access Carrier.

ITOTCCA chooses to implement the industrial version "node-red-industrial" of node-red. Both these packages enable the visual programming of connections between IoT devices, edge client/servers and the main IoT server in the cloud, including the specification of node.js functions and system calls to be generated upon events, all varietiies of networked intercommunications, ordering of connections, etc. The main differences between node-red and node-red-industrial are concerned with Industry 4.0 readiness, with the industrial version implementing such features as an interface for Bosch-Rexroth's ctrl-X automation-of-movement Operational Technology system, for factories of the future. 

Usually IoT notifications are dealt with on a "Report-by-Exception" basis, at the cloud level, however a continuous set of signals is often required at the edge level, to maintain control. 

The technology of the fee-free IOTA "Trust Layer", being developed for IoT, is already at version 2.0 and has plans to implement Smart Contracts (presumably fee-less also). ITOTCCA is incorporating IOTA as our provided Trust Layer of choice for IoT operations. IOTA adds a layer of reference against which all IoT actions can be validated. The absence of fees is made possible by having each transaction validate 2 others before completion. In this way there is no "Mining" involved, as such. IOTA is designed to support Industry 4.0 Standards, and is currently popular in Europe (due to the German-originated Industrie 4.0 standards, with IOTA's headquarters in Berlin. Language translation is natively provided in German, French and Italian). The IOTA response  cycle-time is measured in seconds.

We utilise one "oseer" schema per member-class, so there is one schema for each of the n x m member-classes across all sub-networks, and one for each of the F(i) non-internetworked future dApps, as well as one for each of the A, B and C dApps (Community Housing, RealEstate and convey-IT, respectively). Our schema called 'das_fuhrwerk' is the Head Overseeing Schema, for top level customer on-boarding, usage tracking and payments, to "oversee the overseers" and to provide our own company's Enterprise dApp for our accounting, planning and administration purposes.

You need to develop initially on docker. ITOTCCA uses Ubuntu 22.04 as the host platform, with Python 3.8. DO NOT TRY TO USE PYTHON 3.10 (as is default on JammyJellyfish Ubuntu 22.04) for THE Elastos components of development on Docker.
You will not need an Extreme Gaming level of computer for Docker-based (initial - eg. database) work without Kubernetes. We have a 26 schema system taking about 16GB of RAM and not stressing the cpu at all.

See our website at https://www.itotchaincloud.com.au/kubernetes-yaml-file-example/ for an older but more visual idea of this project and others.

The Front End dApp (Ionic only version) corresponding to this ("cheirrs") project is at https://github.com/john-itcsolutions/au.com.itcsolutions.cheirrs.0.01. It uses the Ionic Platform for web app (in our cases, "distributed app") development. However the Ionic system must be used in conjunction with the newly developing 'Elastos Essentials' package. This package will include all necessary interfaces for the Elastos Ecosystem from the points of view of both developers and users. You can follow this development process (expected to introduce the first stable distribution around July, 2021) at:

https://github.com/elastos/Elastos.Essentials

Note that you may develop entirely on and for desktop computers with Ionic to get to a stage ready for deployment, however to make that dApp work with Elastos you would be required to employ the Elastos.Essentials utilities to connect to the required systems. If you develop also for mobile devices you need to upload the Essentials ".apk" file for Android and obtain various DID's and keys to securely connect on (for example) a USB-connected real mobile device using the Android Studio's "adb" tool. Aside from Android, iOS systems are currently being developed by Elastos for Essentials.

There is, additionally, a template dApp Front-End gui at https://github.com/john-itcsolutions/a-general to match the needs of an internetworked company in a supply chain or other system.

(As noted above, ITOTCCA admits we do not have the in-house capacity to push further with the development of Ionic dApps in association with the Elastos.Essentials package.)

You would also require some dev tools and the openjdk for Java, as well as nodejs@14.x:

# Base requirements 
`sudo apt -y install openjdk-11-jdk build-essential curl dirmngr apt-transport-https lsb-release ca-certificates git`
     
# Install NodeJS 14
     
`sudo apt update`
     
`curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -`
     
`cat /etc/apt/sources.list.d/nodesource.list`
     
`sudo apt -y install nodejs`
     
     Check version:
     
`node  -v`


As well as installing Ionic & Cordova (which enables single-pass coding for iOS and Android as well as desktop - ie browser - platforms):

`sudo npm i -g @ionic/cli`

`sudo npm i -g cordova`

The Ionic docs are at:

https://ionicframework.com/docs

In an Ionic dApp (either React or Angular-based) you will find `manifest.json`.

This file is where you can whitelist websites (including the cloud database/blockchains and server site, even if local).

All websites are blacklisted by default, until you whitelist the sites required by your dApp.

This enables the Elastos Carrier system to do its magic and connect in a private and ultra-secure way to websites, with no websockets used.

(see the Elastos Whitepaper at https://www.elastos.org/downloads/elastos_whitepaper_en.pdf)

Currently (July 2021) the Elastos Developer Documentation does not address development with the new Elastos Essentials.

Our dApp Front End (Ionic-alone version) looks like this at the current stage of development:

<img src="./cheirrs_1.png">


Our dApp for general internetworked supply and trading business situations looks like this (The General):

The source code (such as it is), is at https://github.com/john-itcsolutions/a-general


<img src="./a-general.png">



In order to progress to a version of our dApp (at au.com.itcsolutions.cheirrs.0.01) that can provide connection to the Elastos DID, 
Hive and other systems, we have had to carefully insert that repo's files into a copy of the Elastos.Essentials repo locally 
(at Elastos.Essentials/App/src/). There are some files (such as src/app/app-routing.module.ts) which need to be merged very 
carefully. We also added a "pages" directory in src/app/ and copied all our hundreds of developed pages there. 
There is still work to be done in this area, but note that as we do not own the Elastos.Essentials wrapper app we are unable to 
host our own merged code on any git repo. This development seems to have to be completed entirely locally. 

A selective approach must be taken when considering whether files should be copied as-is or not copied or merged with existing 
files at a finer-grained level. The benefits are that a secure and fully authenticated environment is gained for an otherwise 
straightforward Ionic App, where consumers/clients own their data in a hybrid web2/web3 arrangement. The web2 part refers to 
the necessary centralised database in the cloud on Kubernetes, and the web3 part refers to the blockchains and general Elastos 
connectivities. There are now greatly minimised risks to our clients due to the necessity of using a centralised database. This 
"web2" side of the arrangement is now as secure as a Blockchain. We cannot physically store all enterprise data on chains. They 
become choked. This means we require a tight plan to ensure the security of our databases from fraud and other tampering. 
Reference to itotchaincloud.com.au/security should ease potential clients' minds. Vigilance is part of the answer to this problem. 
The other part is developing a DataChain or BlockBase as detailed above. 
The database thereby becomes immutable, just like a BlockChain.


## If doing initial work, where, for example, database development is involved, consider getting:

Docker for Ubuntu: https://docs.docker.com/engine/install/ubuntu/  - SAFEST WAY!

Alternatively, for an ubuntu vm with docker already set up, such that you can use the system directly from Ubuntu Host Desktop:

-- get multipass:

`sudo snap install multipass`

Launch docker:

`multipass launch docker`

(Very Simple!)

Remember to

`sudo usermod -aG docker $USER && newgrp docker`

after install is complete, in every terminal you wish to use to interface to Docker.

You will also require docker-compose

`sudo apt install docker-compose`

The docker-based development on this project is partly adapted from the code in:

https://github.com/cyber-republic/elastos-smartweb-service  (smartweb-server, providing blockchain access, containerised by ITOTCCA)

and

https://github.com/cyber-republic/python-grpc-adenine  (smartweb-client, database query client with Python)

and

lxd, juju, kubernetes. Also:

https://jaas.ai/u/stub/postgresql (PostgreSQL without PostGIS initially)

We rely on the "etcd" cluster of the kubernetes charmed ecosystem to provide the in-memory, "key-value" query cache servers for the database transactions,
however you can use the "redis" bundle (see below).

The predominant language used to code for this project is Python (here, mainly version 3.8). The Front End dApp is in typescript, a version of javascript. On the full-fledged Kubernetes version, the IoT system ("node-red") is written in node.js, a server-compataible version of javascript, both for edge and server machines. Both the Front End dApp and the IoT system communicate with the smart-web blockchain-and-database server using the python gRPC protocol buffers, which can be found in the python-grpc-adenine github repo by cyber-republic (https://github.com/cyber-republic/python-grpc-adenine). All communications between sites and servers are protected by the Elastos 'Carrier" ultra-security system.

##  DOCKER-BASED DEVELOPMENT (Using pgadmin4_container to bind to postgis_container with database development & administration on 0.0.0.0:5050)

Proceed as follows:

Get Docker and Docker-compose (see above). Pull 2 container images:

`docker pull dpage/pgadmin4`

`docker pull postgis/postgis`

For our trusted collaborators, you can pull our docker bucordo image (1.05GB)

`docker pull johnitcsolutionscomau/bucordo-db`

create one home folder for each of your "member_class_x" projects `mkdir path/to/my-project-x && cd path/to/my-project-x`

Make a set of files all called docker-compose.yml in each my-project-x folder:

`nano docker-compose.yml`

Insert the following text, varying "x" and the names of the "db" container, in each folder:
```
version: '3.3'
networks:
  static-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  pgadmin:
    container_name: pgadmin4_container
    image: dpage/pgadmin4
    restart: always
    networks:
      static-network:
        ipv4_address: 172.20.128.3
    environment:
      PGADMIN_DEFAULT_EMAIL: you@example.com
      PGADMIN_DEFAULT_PASSWORD: your_password
    ports:
      - "5050:80"
      
  db-0_0:
    container_name: member_class_0_0
    image: postgis/postgis
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=gmu
      - APP_DB_PASS=gmu
      - APP_DB_NAME=lagerhaus
    networks:
      static-network:
        ipv4_address: 172.20.128.43
    volumes:
      - ./data_46:/var/lib/postgresql/data
    ports:
      - "5473:5432"

```

There also needs to be a set of replicating/ordering servers (one for each member-class schema) set out as follows:

```
  db-bucordo-0_0:
    container_name: bucordo_0_0
    image: postgis/postgis
    restart: always
    environment:
      - POSTGRES_USER=bucordo
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=bucordo
      - APP_DB_PASS=bucordo
      - APP_DB_NAME=bucordo
    networks:
      static-network:
        ipv4_address: 172.20.128.51
    volumes:
      - ./data_54:/var/lib/postgresql/data
    ports:
      - "5481:5432"
```
Or, for trusted workers:

```
  db-bucordo-0_0:
    container_name: bucordo_0_0
    image: johnitcsolutionscomau/bucordo-db
    restart: always
    environment:
      - POSTGRES_USER=bucordo
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=bucordo
      - APP_DB_PASS=bucordo
      - APP_DB_NAME=bucordo
    networks:
      static-network:
        ipv4_address: 172.20.128.51
    volumes:
      - ./data_54:/var/lib/postgresql/data
    ports:
      - "5481:5432"
```


These containers need to be run in turn by entering the all-sub-projects parent folder and always including the pgadmin4 container but altering the db and db-bucordo containers copied and pasted from their sub-project folders (dummy docker-compose.yml files) one at a time in separate terminals (all located at the sub-projects' parent directory (where all "docker-compose up" commands are run) to enable multi-threading.

Before running the elastos run script you would usually need to restore the schemata you have in the form of 
schema-backups (safest in .sql format). Consistent with following text, we show how our company has developed 
2 simple scripts to restore the entire database (including all schemata) at once. This assumes you have developed
at least some of your own schemata already. As noted below we do not release our actual schema backups.

Nevertheless as a model of how to proceed, you will require 2 shell scripts following these patterns:

In root directory of each project;

`nano docker_dbase_resetup.sh`

Insert the following content, follow the pattern,  and adapt as required to your own db and schema names. Create a folder "essentials" and copy the script there. Inside that folder

```
#!/bin/bash

# docker_dbase_resetup.sh script

createuser gmu && createdb lagerhaus && psql lagerhaus < das_fuhrwerk_backup.sql && echo "das_fuhrwerk" && psql lagerhaus < das_fuhrwerk_oseer.sql && echo "das_fuhrwerk_oseer" && psql lagerhaus < cheirrs_backup.sql && echo "cheirrs" && psql lagerhaus < cheirrs_oseer_backup.sql && echo "cheirrs_oseer" && psql lagerhaus < chubba_morris_backup.sql && echo "chubba_morris" && psql lagerhaus < chubba_morris_oseer_backup.sql && echo "chubba_morris_oseer" && psql lagerhaus < convey_it_backup.sql && echo "convey_it" && psql lagerhaus < convey_it_oseer_backup.sql && echo "convey_it_oseer" && psql lagerhaus < iot_backup.sql && echo "iot" && psql lagerhaus < member_class_0_0_backup.sql && echo "member_class_0_0" && psql lagerhaus < member_class_0_0_oseer_backup.sql && echo "member_class_0_0_oseer" && psql lagerhaus < member_class_0_1_backup.sql && echo "member_class_0_1" && psql lagerhaus < member_class_0_1_oseer_backup.sql && echo "member_class_0_1_oseer" && psql lagerhaus < member_class_0_2_backup.sql && echo "member_class_0_2" && psql lagerhaus < member_class_0_2_oseer_backup.sql && echo "member_class_0_2_oseer" && psql lagerhaus < member_class_1_0_backup.sql && echo "member_class_1_0" && psql lagerhaus < member_class_1_0_oseer_backup.sql && echo "member_class_1_0_oseer" && psql lagerhaus < member_class_1_1_backup.sql && echo "member_class_1_1" && psql lagerhaus < member_class_1_1_oseer_backup.sql && echo "member_class_1_1_oseer" && psql lagerhaus < member_class_1_2_backup.sql && echo "member_class_1_2" && psql lagerhaus < member_class_1_2_oseer_backup.sql && echo "member_class_1_2_oseer" && psql lagerhaus < member_class_1_3_backup.sql && echo "member_class_1_3" && psql lagerhaus < member_class_1_3_oseer_backup.sql && echo "member_class_1_3_oseer" && psql lagerhaus < member_class_1_4_backup.sql && echo "member_class_1_4" && psql lagerhaus < member_class_1_4_oseer_backup.sql && echo "member_class_1_4_oseer" && psql lagerhaus < iot_backup.sql && echo "iot" && echo "iot and thus FINISHED main section!" && echo "DONE!"

```

Now create a follow-up script in the same directory

`nano docker_dbase_setup_1.sh`

Insert the following text and replace with your own container & db_name, and note the final 2 sql scripts adress elastos requirements):

```
#!/bin/bash

# docker_dbase_setup_1.sh

psql lagerhaus -c '\i create_table_scripts.sql' && psql lagerhaus -c '\i insert_rows_scripts.sql'
```

These scripts are found in the elastos repo.

In the essentials folder you require a full set of your own schemata sql backup files.

Next create a "bucordo" folder next to "essentials".

Then add the following set of files (in correspondence with the schemata in "essentials" 
but prefixed with "bucordo_" as a set of names. 


{A PostgreSQL backup of our contribution to the original bucardo file, now refactored to "bucordo",
and preparing to cope with organising transactions into Blocks, is as follows:

```
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Debian 13.5-1.pgdg110+1)
-- Dumped by pg_dump version 13.5 (Debian 13.5-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bucordo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bucordo;


ALTER SCHEMA bucordo OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blocks; Type: TABLE; Schema: bucordo; Owner: postgres

CREATE TABLE bucordo.blocks (
    id bigint NOT NULL,
    tx_set json NOT NULL,
    consensus_metadata json NOT NULL,
    prev_block_hash character varying(256) NOT NULL,
    curr_block_hash_a_b_c_d character varying(256) NOT NULL,
    sig_on_hash_curr_block_by_order_node character varying(256) NOT NULL
);


ALTER TABLE bucordo.blocks OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: bucordo; Owner: postgres
--

CREATE TABLE bucordo.transactions (
    client_uname character varying(128) NOT NULL,
    proc_and_args json NOT NULL,
    block_id bigint NOT NULL,
    hash_a_b_c character varying(256) NOT NULL,
    sig_a_b_c_d_client_priv_key character varying(256) NOT NULL
);


ALTER TABLE bucordo.transactions OWNER TO postgres;

--
-- Data for Name: blocks; Type: TABLE DATA; Schema: bucordo; Owner: postgres
--

COPY bucordo.blocks (id, tx_set, consensus_metadata, prev_block_hash, curr_block_hash_a_b_c_d, sig_on_hash_curr_block_by_order_node) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: bucordo; Owner: postgres
--

COPY bucordo.transactions (client_uname, proc_and_args, block_id, hash_a_b_c, sig_a_b_c_d_client_priv_key) FROM stdin;
\.


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: bucordo; Owner: postgres
--

ALTER TABLE ONLY bucordo.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: bucordo; Owner: postgres
--

ALTER TABLE ONLY bucordo.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (hash_a_b_c);


--
-- PostgreSQL database dump complete
--

```
}


These files should be created by editing and replacing the schema name repeatedly, then "saving as".

There should be, au fin du jour, as many bucordo_x_y.sql files as exist in the essentials folder, but residing in the "bucordo" folder.

Each corresponding bucordo schema is associated with its own main database schema as a part of the transaction ordering system.

You need a copy of any one of the docker-compose.yml files to reside like an anchor in the parent directory of all your project folders. The name of the parent directory gives the overall network a name so every database copy can see each other one. You will be running your "docker-compose up" commands from this directory, but you need to copy and paste the section as follows from each project directory's docker-compose.yml into the parent folder's docker-compose.yml file - the copied section goes OVER the existing db code every time, as you roll out the containers, each one in a new terminal (but from the same directory). NOTE 1: You must retain the static network and pgadmin4 sections in each "docker-compose up" invocation. NOTE 2: You will be required to paste the following into these terminals to allow non-root access:

`sudo usermod -aG docker $USER && newgrp docker`

In the end, this procedure gives a multi-threaded set of containers all connected to pg-admin4:

```
db-0_0:
    container_name: member_class_0_0
    image: postgis/postgis
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=gmu
      - APP_DB_PASS=gmu
      - APP_DB_NAME=lagerhaus
    networks:
      static-network:
        ipv4_address: 172.20.128.43
    volumes:
      - ./data_46:/var/lib/postgresql/data
    ports:
      - "5473:5432"

```
 fresh each time you start a member_class's server (so the ipv4 address and port number change as well as the name of the container you are running).

The ordering nodes require a different docker-compose fragment (from above):

```
  db-bucordo-0_0:
    container_name: bucordo_0_0
    image: postgis/postgis
    restart: always
    environment:
      - POSTGRES_USER=bucordo
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=bucordo
      - APP_DB_PASS=bucordo
      - APP_DB_NAME=bucordo
    networks:
      static-network:
        ipv4_address: 172.20.128.51
    volumes:
      - ./data_54:/var/lib/postgresql/data
    ports:
      - "5481:5432"
```

Or, for trusted workers:


```
  db-bucordo-0_0:
    container_name: bucordo_0_0
    image: johnitcsolutionscomau/bucordo-db
    restart: always
    environment:
      - POSTGRES_USER=bucordo
      - POSTGRES_PASSWORD=your_password
      - APP_DB_USER=bucordo
      - APP_DB_PASS=bucordo
      - APP_DB_NAME=bucordo
    networks:
      static-network:
        ipv4_address: 172.20.128.51
    volumes:
      - ./data_54:/var/lib/postgresql/data
    ports:
      - "5481:5432"
```

Now we have a running database on each port 54xy but if you go to 0.0.0.0:5050 (pg-admin4) each database server will be on 5432 since pg-admin works with in-container ports. To see each database we need to register a server for each member_class database copy, making the name of the server correspond to the directory name of each member-class. Insert ip address (but always use port 54xy:5432 here, varying x and y uniquely) from the appropriate docker-compose.yml. 

So, in the parent folder of "essentials" compress the folder with:

`tar zcvf essentials.tar.gz ./essentials`

Then "docker cp" essentials.tar.gz to every db container .

Inside each non-ordering container - 

`docker exec -it container_name bash`

- then

`mkdir postgres && chown postgres postgres && mv *.tar.gz postgres/ && su postgres`

and

`cd postgres`

Untar the file and run the script(s) - 2 scripts in "essentials". This will restore the lagerhaus database in the appropriate containers.

And wait until complete.

Then:

in each ordering server proceed as follows (unless you have access to the "trusted workers'" docker image,
in which case the container is already set up).

`docker exec -it bucordo_x_y bash`

`adduser bucordo`

`docker exec -it <container-name-bucordo-x-y>`

`apt install postgresql-plperl-13`

`perl -MCPAN -e 'install Bundle::DBI'`

`perl -MCPAN -e 'install DBD::Pg'`

`perl -MCPAN -e 'install DBIx::Safe'`

`su bucordo`

`psql bucordo`

`CREATE EXTENSION plperl;`

`\q`

Ensure the existing "bucordo.schema" file (from this repo) is copied (docker cp) to each ordering server.

Then, in each server:

`su bucordo`

In the folder to which you copied bucordo.schema:

`psql bucordo < bucordo.schema`

Each bucordo node must be 'subscribed' to its own Member Class server (only), to receive update notifications, yet configured to broadcast updates to the other bucordo servers (only) in the node-cluster.

All the bucordo servers will be updating each other with current transactions from their own substrate databases.

There then will need to be an Ordering Process (Consensus Seeking) to determine the order in which the current block of transactions will be committed. Please refer to the above-mentioned IBM article.

The next step is to investigate how to involve the Ordering Service in the ordering of transactions by consensus from the other servers, and propogating the finalised Blocks throughout the system.


# About the docker-compose.yml file to run:

The above code needs to be copied (as for the previous set) to the overall parent Project Directory, but only over the "services \ db-z: .. etc" section, in the existing docker-compose.yml file, leaving the first (network definition) section and pg-admin4 sections intact so as to preserve the pgadmin4 and static network settings. 


When the databases from this "partition" are rolled out they will have a structure of schemata, tables and columns identical to each other, but the ordering nodes have a much simpler set corresponding to the existing "Bucardo" system but with an extra 2 tables per server ("Transactions" & "Blocks"), (identical) in each schema.

Transactions has a. username of client b. procedure executed and arguments (json) c. block_id d. Unique identifier == hash (a, b, c) e. Signature on hash(a, b, c, d) using client's private key. 

Block Table has a. Block-id b. set of transactions (json) c. metadata associated with the consensus protocol d.hash of the previous block e. hash of the current block, i.e., hash (a, b, c, d) f. Digital signature on the hash of the current block by the orderer node.

At the current stage the remaining Bucordo tables correspond exactly to the Bucardo tables.

________________________________________________________________________________________________________________________


Our final (nearly!) Docker Installation of 26 (= 2 x 12 + "iot" +"public"  -  where iot and public have no "oseer" schemata, but the others do) servers linked to a pgadmin4 container looks like:

<img src="./Docker_3.png">

Next we have to clone the Elastos Smartweb blockchain and database server package to the Sub-Project root directories:

`git clone --recurse-submodules https://github.com/cyber-republic/elastos-smartweb-service.git`

With the development of the database enabled after we run the docker-compose file (administer and develop at 
0.0.0.0:5050 on your Host), the "run.sh" script as defined in the Elastos repo we just cloned needs to be edited.

Open elastos-smartweb-service/run.sh in an editor and comment out the top lines as shown here:

```
#!/bin/bash

# Run postgres server as a docker container
#cd tools
#./postgres.sh
#cd ..
virtualenv -p /usr/bin/python3.8 venv

source venv/bin/activate

pip install -r requirements.txt

export PYTHONPATH="$PYTHONPATH:$PWD/grpc_adenine/stubs/"

python grpc_adenine/server.py
```

so that the run.sh script does not attempt to start any "postgres" container (we are using "postgis/postgis" 
image as the postgis_container, however it will already be running when "./run.sh" is executed - see below)

Note that for postgres database development the progress is easier if you are user "postgres" on the Host.

You now need to edit the `elastos-smartweb-service/.env.example` file to reflect your own docker network addresses. The database ip-address
is found as above from 

`docker container inspect postgis_container`

The container ip-address should be inserted in env.example together with the Gateway address (found in `docker container inspect postgis_container`), which should be inserted as the blockchain access addresses in the same file. Next, alter port for database to 5432 and give it your own database's name. Then save the `env.example` file as a) `.env`, and b) as `.env.test` with these edited settings.

Next we edit the `elastos-smartweb-service/grpc-adenine/database/__init__.py` file to insert the same database ip-address and your own database name.

Save all this work.

If you wish to get a sanity check on whether elastos is connected to your database after running, you can use the following to replace the 
`elastos-smartweb-service/grpc-adenine/database/__init__.py`:

```
import logging

from sqlalchemy import create_engine, MetaData
from sqlalchemy import inspect

from sqlalchemy_wrapper import SQLAlchemy
from decouple import config

# Set up logging
logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.DEBUG,
    datefmt='%Y-%m-%d %H:%M:%S'
)

# Connect to the database
db_name = config('DB_NAME')
db_user = config('DB_USER')
db_password = config('DB_PASSWORD')
db_host = config('DB_HOST')
db_port = config('DB_PORT')

database_uri = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

try:
    db_engine = create_engine(database_uri)
    connection = SQLAlchemy(database_uri)
except Exception as e:
    logging.fatal(f"Error while connecting to the database: {e}")

meta = MetaData()
insp = inspect(db_engine)

schemata = insp.get_schema_names()
num_sch = len(schemata)
num_tab = 0
for schema in schemata:
	num_tab += len(insp.get_table_names(schema))
print("There are ", num_sch, " schemata")
print("There are ", num_tab, " tables")
print("These are the schema names: ", schemata)

print("Done!")

```

Finally, we are in a position to issue the command (from <project_root>/elastos-smartweb-service/, or possibly from each of a set of containers built from an elastos webserver docker image, committed from a running, say, debian base container):

`./run.sh`

Unlike the cases following, where we develop in Kubernetes, the database is directly accessible via a gui 
(provided by PgAdmin4) in this form of development. You must develop tables, columns, views and a foreign key 
relationship system in the database itself.

In addition, the Python-gRPC protocol buffer services must be developed on the smartweb server to provide the 
Ionic/Cordova front end gui with target procedures to call from your Ionic Typescript code (to Python-encoded protobufs) 
via Carrier and the Python-gRPC client. These procedures will do the data input and output query work for your dApp 
on Postgis. You may also need to program trigger functions in PLpgSQL on the database in order to process data. 

## Instructions on how to build and run python-grpc-adenine locally
Clone the repository
```
git clone https://github.com/cyber-republic/python-grpc-adenine.git
cd python-grpc-adenine
```
Setup virtualenv:
```
virtualenv -p `which python` venv;
source venv/bin/activate;
```
Install dependencies:
```
pip3 install -r requirements.txt;
```
Setup environment variables and update variables if needed:
```
cp .env.example .env;
```
Run sample.py:
```
python sample.py
```

Remember it is more efficient to have postgis processing data wherever possible, and not having the smartweb server doing 
more than necessary. This is one good reason to learn PLpgSQL!

Postscript: Without knowing exactly how, I managed to start a separate process on tcp 8001, labelled as a Postgres process 
which I now understand to be the still-running "old" process from the previous "docker-compose up" command. This is actually 
one of the ports reserved for the grpc smartweb server. I killed that old process with 

`sudo kill -9 $(sudo lsof -t -i:8001)`

and all was well.

Also, do not try to use the elastos-smartweb-service repo with Python3.10. Version 3.8 is required. Trust us ...


______________________________________________________________
## KUBERNETES: Planning for the Cloud

# An Initial Model on a controller:

(The database schemata for ITOTCCA's project are private and available only under certain conditions.)
     
`sudo snap install multipass`

`multipass launch -n node-0 -c 6 -m 14GB -d 50GB`

`multipass launch -n node-1 -c 6 -m 14GB -d 50GB`

`multipass launch -n node-2 -c 6 -m 14GB -d 50GB`

`multipass launch -n pgadmin-n-red-dtop -c 2 -m 10GB -d 50GB`

     
     (You can tweak those settings)
     And end-up with 3 x LTS Ubuntu vm's which we will set up as 3 master nodes using "juju/lxd".
     
     
     Then mount a shared directory to enable access to your host:
     
     On each vm (`multipass shell node-x/pgadmin`)
     
`mkdir shared`

`exit`

`multipass mount path/to/your/working/directory node-<x>:~/shared/`


In each vm (ie node-x):

`sudo snap install juju --classic`

`juju bootstrap localhost node-<x>`

You may need to re-run the above command at the end to finish cleanly

`juju add-model werk-<x>`

`juju deploy kubernetes-core`

`juju remove-unit easyrsa/0 --force` 

(& repeated)

`juju remove-machine 0/lxd/0 --force`

(& repeated)

`juju add-unit easyrsa`

When all units are deployed except possibly the master (control-plane) and/or 
worker is in a wait state (but with ports assigned):

`juju deploy postgresql pg-lagerhaus`

(single Master)

`juju deploy postgresql bucordo`

(single Master on each node)

When settled, enter bucordo machine:

`juju ssh <machine-number-bucordo>`

`adduser bucordo`

`apt install postgresql-plperl-12`

`perl -MCPAN -e 'install Bundle::DBI'`

`perl -MCPAN -e 'install DBD::Pg'`

`perl -MCPAN -e 'install DBIx::Safe'`

Create 'bucordo' database:

`su bucardo`

`createdb bucordo`

`psql bucordo`

`CREATE EXTENSION plperl;`

`\q`

In location onboard each bucordo server, containing "bucordo.schema" file copied from this repo:

`psql bucordo < bucordo.schema`

`exit`

`exit`

Now back on node-x.

_______________________________________________________________________________________________

The database structure for 'bucordo' is incomplete presently.

_______________________________________________________________________________________________

Since Postgres does not natively provide for multi-master logical replication there is an existing open-source, 
Multi-Master replication system on a site called www.bucardo.org, however it relies on a single replicating 
bucardo master server to handle all replication using PLperl functions on a Postgres database. The present structure of 
that software is such that users must invest their trust in the superuser of the bucardo system. This is counter 
to our own principles of developing Automated Trust in our systems. To counteract this weakness in bucardo we are 
intending to develop an Open Source adaptation of the system that will use similar Perl functions as bucardo, however
will be employing as many "Bucordo" servers as there are Member-Class base-level database servers (as opposed to the 
single bucardo server). The Bucordo servers will be informed of updates only on "their own" database base-level servers 
and will then update the remaining Bucordo servers which will then update "their own" base-level database servers. The 
remaining work will involve an Ordering Process for each Block of transactions (similar to a Blockchain), designed to 
determine the "agreed" order in which transactions are to be committed after a consensus-seeking process between the 
Bucordo servers, following the method detailed in the above-mentioned IBM research paper. The process is completed with 
a checkpointing procedure as detailed in the paper, and readily available on Postgres.

## MY COMMUNICATION TO bucordo-general mailing list:

Hi everyone,

I initially sent emails elsewhere until I found this list. I am copying them here. The comments are in relation to an IBM Article from IBM India in 2019 to be found at

https://arxiv.org/pdf/1903.01919.pdf


"
Yes, Ben, I am searching for multi-master replication solutions, but with a difference .. the idea is to allow automated Trust to be developed on a database system by doing away with your standard single superuser system on bucordo and replacing it with multiple bucordo masters on top of multiple substrate masters..
My idea is to copy IBM's research and to build-in a consensus-seeking solution for the proposed multi-master bucordo system. The consensus being sought is intended to order transactions appropriately before final committing..Please refer to the previously attached IBM research paper"

"
Sorry to carry on before receiving any response, but I have been thinking about how to implement these Automated Trust ideas.

If there were as many bucordo servers as there were base-level database servers, and each bucordo server were configured to only replicate from changes on its own (base) database server, then the problem would reduce to obtaining consensus (per transaction "block") from all bucordo servers as to the order in which the executed transactions are to be committed. The Consensus Algorithm outlined in the IBM paper, is given in sufficient detail to reproduce on bucordo (I claim!)

I am now thinking I should look at your github site.

From our point of view as Enterprise Application developers and operators we are looking toward customers such as those companies involved in Supply Chain operations which require smart contracts you can implement on postgres databases, if bulk data is involved. Also we intend to provide distributed applications in non-internetworked areas eg Real Estate Agencies, NGO Housing Providers, Conveyancing etc. We organise our customers by "Member Class" meaning they would share IT "Mission" and a lot of activities daily (as far as what was actually done during the day) and fit into the same business network (if internetworked at all). One member Class per database server. Operated by a consortium-employed operator - a consortium of Members (Companies) in the Class. Our only involvement as a player, is to have the numbers of users etc etc reported monthly for Billing purposes. The idea that nobody has to trust anyone else during daily operations is attractive. Member Class Operators are being kept honest by the nature of the system, as are we. That is why I am hoping we can somehow organise an adaptation to bucordo for these purposes.

It is worth noting that we are looking towards the Elastos Blockchain with its "Carrier" security system for web communication as the provider of "Distributed" Id's to allow signing of every transaction securely The only thing in the IBM agenda of shortcomings of databases (from the point of view of a Blockchain) is how can we make a PLpgSQL function as "deterministic" as a transaction on a blockchain? We could also possibly utilise the insurance of Elastos to check the database for integrity (as, if more than 50% of bucordo servers were somehow caused to act fraudulently in concert, Trust would be destroyed).
"
We think this is a very attractive idea of IBM's and feel that bucordo could play a role in its development. bucordo would act both as replicating agent as well as ordering agent.

I have been thinking further on this subject.

It appears it would be essential to organise inter-master replication via the bucordo masters so that an event originally may occur on base-server-0 then it would communicate with bucordo-server-0 which would communicate with every other bucordo sevrer, which would then cause their own base-servers to be updated, and some time after this, enter into an ordering process (between the range of bucordo-servers) of a Block of transactions for committal. In this way bucordo servers only update "their own" base-servers unless the bucordo server is updating other bucordo servers on behalf of the base servers.


You may be wondering how we get "Automated Trust" from such an arrangement.

It appears to me we would have to insist that database administrators as much as developers be denied permission to write anywhere to the production databases and that we provide (as ITOTCCA) only ways for client devices to update the database including signing up new customers and creating new member-classes (performed by ITOTCCA's own database node (our own member-class)  servers via our own client devices). In this way each transaction can be signed with an Elastos-created DID and therefore becomes "Non Repudiable".


On reading through the "bucordo" file on github, I can see that my ideas would mean fundamentally altering bucordo.

If these ideas gain any creedence here, I am proposing to create a new adapted package called "Bucordo" to reference the idea of an ordering process (the transaction ordering to form a block, that will be necessary) but to relate to bucordo, still,  as an ancestor.

Once again,

I'm not exactly as expert as some in Perl and Postgres, however I am prepared to do as much as I can to achieve this goal and to "open source" it.

The use of the Elastos Smartweb blockchains and system is our company idea and need not be carried across (at least I don't think so) to general usage.

Anyone interested?"

___________________________________________________________________________________________________________

We are now commencing work on that adaptation. We have open sourced the bucordo project and repository.

See https://github.com/john-itcsolutions/bucordo .

Now, on kubernetes-worker-0:

`juju ssh <machine-number-worker-0>`

`git clone https://github.com/cyber-republic/elastos-smartweb-service.git`

In el*service, there is a hidden .env.example file you can find with 

`ls el* -a`

`nano .env*`

Edit the database details top suit and the target address for this elastos server
and save as .env and then as .env.test.

You need to supply a "run.sh" file to each elastos container:
	
`nano run.sh`

Insert:

```
#!/bin/bash

virtualenv -p `which python3` venv

source venv/bin/activate

pip install charmhelpers

pip install -r requirements.txt

export PYTHONPATH="$PYTHONPATH:$PWD/grpc_adenine/stubs/"

python3 grpc_adenine/server.py
```

Save then:
	
`juju scp run.sh kubernetes-worker/0:/elastos-smartweb-service/`
	
Now, open a blank file called __init__.py:
	
`nano __init__.py`
	
	Insert:
	
```
from sqlalchemy_wrapper import SQLAlchemy
from sqlalchemy import create_engine, MetaData, Table, Column, ForeignKey, inspect
from sqlalchemy.ext.automap import automap_base
import os
import sys
from decouple import config
from charmhelpers.core.hookenv  import (
    Hooks, config, relation_set, relation_get,
    local_unit, related_units, remote_unit)

import logging
# Set up logging
logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.DEBUG,
    datefmt='%Y-%m-%d %H:%M:%S'
)

# Connect to the database
db_name = 'lagerhaus'
db_user = 'gmu'
db_password = 'gmu'
db_host = 'ip-addr'
db_port = '5432'

database_uri = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

try:
    db_engine = create_engine(database_uri)
    connection = SQLAlchemy(database_uri)
except Exception as e:
    logging.fatal(f"Error while connecting to the database: {e}")

hooks = Hooks()
hook = hooks.hook

@hook
def db_relation_joined():
    relation_set('database', 'lagerhaus')  # Explicit database name
    relation_set('roles', 'reporting,standard')  # DB roles required
    relation_set('extensions', 'postgis,osm2pgrouting') # Get PostGIS
@hook('db-relation-changed', 'db-relation-departed')
def db_relation_changed():
    # Rather than try to merge in just this particular database
    # connection that triggered the hook into our existing connections,
    # it is easier to iterate over all active related databases and
    # reset the entire list of connections.
    conn_str_tmpl = "dbname={db_name} user={db_user} host={db_host} port={db_port}"
    master_conn_str = None
    slave_conn_strs = []
    for db_unit in related_units():
        if relation_get('database', db_unit) != config('database'):
            continue  # Not yet acknowledged requested database name.

        allowed_units = relation_get('allowed-units') or ''  # May be None
        if local_unit() not in allowed_units.split():
            continue  # Not yet authorized.

        conn_str = conn_str_tmpl.format(**relation_get(unit=db_unit))
        remote_state = relation_get('state', db_unit)

        if remote_state == 'standalone' and len(db_unit) == 1:
            master_conn_str = conn_str
        elif remote_state == 'master':
            master_conn_str = conn_str
        elif remote_state == 'hot standby':
            slave_conn_strs.append(conn_str)

    update_my_db_config(master=master_conn_str, slaves=slave_conn_strs)

# Utilise metadata inspection to reflect database/schema details
meta = MetaData()
insp = inspect(db_engine)
cols = 0
n = 0
m = 0
l = 0
p = 0
Max = [[]]
mAX = 0
tables_totals_summary = [[]]
schemata_names = insp.get_schema_names()
f = open('/home/ubuntu/dbase_report.txt', 'w')
for schema in schemata_names:
    n += 1 
    if n > 1:
        Max.append((last_schema, 'Tables =', m, 'Schema Id', n-1))
        mAX += m
        m = 0
    if len(list(insp.get_table_names(schema))) == 0:
        print(schema, '. NULL')
        last_schema = schema
        m = 0
    for table in insp.get_table_names(schema):
        this_table = Table(table, meta)
        insp.reflect_table(this_table, None)
        f.write('\n\n' + schema + '.' + str(this_table) + '\n\n')
        for column in this_table.c:
            f.write(str(column) + '\n')
            cols += 1
        m += 1
        l += 1
        if str(this_table)[0:3] == 'acc':
            p += 1
        print(schema, '.', this_table)
        last_schema = schema
    tables_totals_summary.append((last_schema, 'Total Tables =', m, 'Accounting_Tables =', p, 'Other_Tables =', m-p, 'Schema Id', n))
    p = 0
f.close()
Max.append((last_schema, 'Tables =', m, 'Schema Id', n))
mAX += m 
if n == len(schemata_names):
    print('All', n, 'schemata, with', l, 'total tables reflected')
else:
    print('WARNING!! Number of Schemata does not match! \nie', n, '(after processing), and', len(schemata_names), '\n(latter is original schemata_names list length')

print(str(tables_totals_summary).replace("),", "),\n"))

print('Total tables by "Max" =', mAX)
if mAX - l == 0:
    print('Totals for Tables agree.')
else:
    print('WARNING!! Totals for Tables not equal! ie', mAX, 'and', l)
print('Total Columns =', cols)
print('Summary available in "~/dbase_report.txt"')
print('Done!')
if __name__ == '__main__':
    hooks.execute(sys.argv)
```

Copy __init__.py to the 3 elastos-x containers:
	
	
	
This completes the servers' setup. (When done in each of the 3 vm's).

________________________________________________________________
 
# DATABASE: Internals

You will need a set of 3 member-class schemata (one covering iot) with another 2 overseer schemata (we use 2 - the_general, 
and the_general_oseer  and copied them 2 times, at this early stage, with our own iot schema - having no "oseer") to serve as material for development. 

The bucordo ordering and replication service strictly requires at least 2 other replicating bucordo databases connected to 
their associated base servers, themselves connected to an elastos-smartweb-service.

In our case, if a single member-class network existed solo (such as any of our Real Estate Property dApps) we would be required 
to separate the existing networks into 3 (to provide a 'Mexican Standoff' arrangement) servers designed to keep everyone honest. Das_Fuhrwerk would provide one extra, with any third member acting as a dummy policing server only (if necessary due to lack of second customer).
	
The ordering services will run alongside (in parallel with) the main system.	

In our case, with The General, we started the process of building the main databases from 3 schema backup .sql files,
and put all backups and scripts into a single folder, and copied '*' to postgres masters.

## Getting PostGIS and Open Street Maps
	
	As user 'ubuntu' in each vm's pg-lagerhaus master:
	
	Inside postgres vm's as user ubuntu:

`sudo add-apt-repository ppa:ubuntugis/ppa`

`exit`
	
	Now on node-x:
	
`juju scp dbase_setup_2.sh <machine number pg-lagerhaus>:/`
	
`juju scp dbase_setup_3.sh <machine number pg-lagerhaus>:/`
	
`juju ssh <machine-number-pg-lagerhaus>`
	
	Inside pg-lagerhaus, again as 'ubuntu':

`./dbase_setup_2.sh`
	
`su postgres`
	
`./dbase_setup_3.sh`
	
This completes pg-lagerhaus database setup.

                                                                                                                
_______________________________________________________________


# NOTE:
	As we don't own or control the elastos sub-modules, and since the `elastos-smartweb-service/grpc_adenine/database/__init__.py` file is not fully usable as it is, in the elastos-smartweb-service module (as-cloned), we have included ITOTCCA's version of `__init__.py` in a folder in the cheirrs root directory. This version caters for initialising the SQLAlchemy interface from the existing database, and generating a full set of Database Models, using SQLAlchemy's ORM & methods of Database Metadata Reflection. However you need to edit this file carefully to suit your own database, at your
`shared/cheirrs/TO_BE_COPIED_INTO_smartweb-service/TO_elastos-smartweb-service.grpc_adenine.database/__init__.py` 
(in the shared directory on "primary" with a local clone of this repo) to enable it to work properly as a Python init file. This init file will be run by the system before running the server at /grpc_adenine/server.py. You would have to keep these 2 versions of `__init__.py` in sync with each other if you need to edit `__init__.py`, and want to use your own github account, for example.

     
The blockchain server ip-addresses in the .env, and .env.test files on each elastos pod, need to match the address of the targeted pod. Also the database details will require alteration.

`cd ....path/to/shared/cheirrs`

Now perform each of the following 2 steps for each vm, and within that, for each worker, paying particular attention to the .env, .env.test and __init__.py files,  where the database host address will need to be edited for each target-pod ie worker node, and similarly for the elastos pod addresses (== worker/0-OR-1 addresses) on each node in .env & .env.test:
     
     1:

`juju scp shared/cheirrs/TO*/*service/* <worker-0>:/elastos-smartweb-service/`

`juju scp shared/cheirrs/TO*/TO_.env_in_elastos-smartweb-service_<vm-"master-number"eg 1>/.env elastos-<x>:/elastos-smartweb-service/`

`juju scp shared/cheirrs/TO*/TO_.env_in_elastos-smartweb-service_<vm-"master-number"eg 1>/.env.test elastos-<x>:/elastos-smartweb-service/`
	
     2:
     
`juju scp shared/cheirrs/TO*service/TO_elastos-smartweb-service.grpc_adenine.database_<node-number-eg 1>/__init__.py elastos-<x>:/elastos-smartweb-service/grpc_adenine/database/__init__.py`


 After you have covered the 3 node-x nodes:
 
in each:

`juju ssh <worker-0>` 
	
`sudo kill -9 $(sudo lsof -t -i:8001)`
	
`cd elastos-smartweb-service && ./run.sh`
.. and wait and watch .. and examine logs in case of errors, which are available at (TODO). 
     If all is well, you should be looking at the blockchains' log, on stdout, as the cycles roll every 30 seconds.
     
     There is also a dbase_report.txt (just a structural summary) at /home/ubuntu on each pod.


_________________________________________________________________________________________________


## TESTING the smartweb-service/Blockchains/Postgresql System

     Copy test.sh to the elastos-x's after editing along the lines of run.sh, enter elastos-x and:
     
     `cd el*`
     
     `./test.sh`
     
     We are having difficulties with the jwt token and key system for entry authentication to the smart-web server ..
     
To be continued ..
_____________________________________________________________
 
## In node-0, node-1, and node-2 (in turn) enter worker-0, to set-up an IoT server with Python-gRPC, 
## node-red-industrial, Carrier and IOTA client.
     
`juju ssh <kubernetes-worker-0>`

(To install nodejs and npm, needed for Node-red, the Carrier wrapper and to connect 
with gRPC as well as the IOTA node.js client:)
     
# Install NodeJS 14
     
`sudo apt update`
     
`curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -`
     
`cat /etc/apt/sources.list.d/nodesource.list`
     
`sudo apt -y install nodejs`
     
     Check version:
     
`node  -v`
     
     To get Node-Red-Industrial:
     
`sudo snap install node-red-industrial`
     
             on the Host (acting as an Edge server)
     
Also, in worker-0 (`juju ssh <machine-number-worker-0>`),
     
`sudo snap install node-red-industrial`

You will require a desktop remote client to be installed (see below).
	
	You can then visit (on the Host) `<worker-0-ip-addr>:1891`
     
     Eventually the idea is to be able to "log" and respond (in appropriate timeframes
     corresponding to the message origin and content) to events considered as "exceptional"
     in some way. The events and messages (originating on iot devices connected to "edge" 
     raspberry-pi (or Industrial Pi) units or similar, in the field) will be logged on the IOTA 
     Tangle and your database, via javascript functions in node-red wrapped in Carrier and 
     using the gRPC protocols on worker-0, to the "smart-web" server.
     
     As noted elsewhere, the required response times of some machinery and systems means 
     sub-millisecond cycles, which cannot be achieved without dedicated Edge-client/server 
     support geographically close to sites, when actuation is involved. Otherwise, 
     notification functions can be handled directly to the Cloud. 
     
     Follow the README.md instructions on the repo site to build the client.
     
     Similarly we need to allow (Elastos) Carrier-shielded communication between "edge" (here, Host),
     and worker-0. For this, on both Edge (Host here) and worker-0, we require the Carrier Native SDK and to follow this by installing the 
     Carrier Nodejs Wrapper package. This would need to also occur on Real-World Edge Clients running node-red-industrial.
     
     https://github.com/elastos/Elastos.NET.Carrier.Nodejs.SDK and 
     https://github.com/elastos/Elastos.NET.Carrier.Native.SDK have details.
     
The installation of IOTA client proceeds as follows (repeat for Host - ie Edge):
     
     In worker-0:
     
`mkdir iota && cd iota`
     
`npm init`  (accepting all defaults will do)
     
`npm install @iota/core @iota/converter @iota/client`
     
     Add a file called `index.js` with the following content:
     
```
     async function run() {
     const {
     ClientBuilder
     } = require('@iota/client');
    // client connects to a node that has MQTT enabled
     const client = new ClientBuilder()
     .node('https://api.lb-0.h.chrysalis-devnet.iota.cafe/')
     .build();
     client.subscriber().topics(['milestones/confirmed', 'messages', 'messages/referenced']).subscribe((err, data) => {
     console.log(data);        // To get the message id from messages `client.getMessageId(data.payload)` can be used
     })
    await new Promise(resolve => setTimeout(resolve, 1500));    // unsubscribe from 'messages' topic, 
     //will continue to receive events for 'milestones/confirmed', etc
     client.subscriber().topics(['messages']).unsubscribe((err, data) => {
     console.log(data);
     })
     }
run()
```
     
The approach we have taken here is to rely on Message exchanges on MQTT 
for validation of IoT actions and events.
     Please refer to https://client-lib.docs.iota.org/docs/libraries/nodejs/examples 
     for a full explanation of all "topics" to which an application may subscribe on IOTA. 
     
     The launch of the client, on both Edge (Host) and elastos-x, occurs with:
     `node index`   from the iota root directory.
     
     By choosing the node.js version of the IOTA client, we get the ability to easily communicate with the other 
     apps on the worker-0 vm, and on the Edge server (Host here).
     
     _________________________________________________________________

   ## My LinkedIn:
                                                                              
   https://www.linkedin.com/in/john-lloyd-olsen/                                                                           
_________________________________________________________________
