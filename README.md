# Docker image for SAP/Sybase iq 16

The Dockerfile builds a SAP/Sybase iq 16 with 30 days evaluation license.

## Usage
- The installer download url can be get from : https://www.sap.com/community/topic/iq.html
- Clone the project : ``git clone https://github.com/ypiel-talend/sybase_iq_16``
- Build the image : ``docker build -t sybaseiq .``
- Run the container : ``docker run -p 2638:2638 sybaseiq``

The exposed port is the ``2638``. You can connect to the ``iQ1`` database within the user ``tujuser`` and its password ``tujuser``.

You can also connect with the dba account, login ``DBA``, password ``sql``, and use the ``utility_db`` database.

## Execute dbisql from the container
The following command run the image with X11 enabled : 
```bash
docker run  -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ -p 2638:2638 sybaseiq
```
Retrieve the id of the running image with ``docker ps``. Then connect into the container executing a bash inside with:
```bash
docker exec -it <container id> /bin/bash
```

You are then connected as root into the container. You can execute ``dbisql`` command.

## About the image
- The image is based on Centos 7
- The build image is based on this guideline : https://www.petersap.nl/SybaseWiki/index.php?title=Installation_guidelines_IQ_16
