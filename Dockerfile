FROM debian:stretch
RUN apt-get update && apt-get install -y openjdk-8-jre openjdk-8-jdk unzip wget 
RUN wget -O payara https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/5.201/payara-5.201.zip
RUN unzip payara
ENV PASSWORD_FILE="password" \
PAYARA_DIR="payara5" \
ADMIN_USER="admin" \
ADMIN_PASSWORD="admin"
EXPOSE 8080
EXPOSE 4848
RUN printf "%b""AS_ADMIN_PASSWORD=$ADMIN_PASSWORD" >> $PASSWORD_FILE
RUN printf "%b""AS_ADMIN_PASSWORD=\n AS_ADMIN_NEWPASSWORD=$ADMIN_PASSWORD" >> tmpfile
RUN ${PAYARA_DIR}/bin/asadmin start-domain --interactive=false && \
$PAYARA_DIR/bin/asadmin --user $ADMIN_USER --passwordfile=tmpfile --interactive=false change-admin-password && \
$PAYARA_DIR/bin/asadmin --user $ADMIN_USER --passwordfile=${PASSWORD_FILE} --interactive=false enable-secure-admin  && \
#$PAYARA_DIR/bin/asadmin --user $ADMIN_USER --passwordfile=${PASSWORD_FILE} set-hazelcast-configuration --clusterMode=multicast --multicastGroup=224.2.2.3 --multicastPort=54327 --dynamic=true  && \
#$PAYARA_DIR/bin/asadmin --user $ADMIN_USER --passwordfile=${PASSWORD_FILE} --interactive=false deploy --availabilityenabled=true /login.war && \
${PAYARA_DIR}/bin/asadmin stop-domain
ENTRYPOINT $PAYARA_DIR/bin/asadmin --interactive=false start-domain --verbose


