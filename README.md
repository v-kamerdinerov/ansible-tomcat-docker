# Apache Cassandra Tomcat Docker

Ansible role to run the containerized version Tomcat web server and run .war application.

The role contains: 

 - Running monitoring stack `container_exporter/node_exporter`
 - Launching web application in tomcat via docker-compose


## Install
Use tags for installation:

 #### common
```bash
ansible-playbook -v deploy.yml --tags "monitoring"
```
To install all monitoring stack.
 #### app
```bash
ansible-playbook -v deploy.yml --tags "app"
```
To deploy web application.

Check on `http://you-instance-ip/sample`




## Security Hardening Measures

This Tomcat container was security hardened according to [OWASP recommendations](https://www.owasp.org/index.php/Securing_tomcat). Specifically,

-   Eliminated default Tomcat web applications
-   Run Tomcat with unprivileged user `tomcat` (via `entrypoint.sh`)
-   Start Tomcat via Tomcat Security Manager (via `entrypoint.sh`)
-   All files in `CATALINA_HOME` are owned by user `tomcat` (via `entrypoint.sh`)
-   Files in `CATALINA_HOME/conf` are read only (`400`) by user `tomcat` (via `entrypoint.sh`)
-   Container-wide `umask` of `007`


<a id="h-1BF7025D"></a>

### web.xml Enhancements

The following changes have been made to [web.xml](./web.xml) from the out-of-the-box version:

-   Added `SAMEORIGIN` anti-clickjacking option
-   HTTP header security filter (`httpHeaderSecurity`) uncommented/enabled
-   Cross-origin resource sharing (CORS) filtering (`CorsFilter`) added/enabled
-   Stack traces are not returned to user through `error-page` element.


<a id="h-BC90DBB0"></a>

### server.xml Enhancements

The following changes have been made to [server.xml](./server.xml) from the out-of-the-box version:

-   Server version information is obscured to user via `server` attribute for all `Connector` elements
-   `secure` attribute set to `true` for all `Connector` elements
-   Shutdown port disabled
-   Digested passwords. See next section.