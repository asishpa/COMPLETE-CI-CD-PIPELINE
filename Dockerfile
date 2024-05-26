FROM tomcat:10.1.24-jre17
EXPOSE 8080
COPY target/demo-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
