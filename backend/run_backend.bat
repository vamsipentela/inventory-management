@echo off
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot"
set "PATH=%JAVA_HOME%\bin;%~dp0apache-maven-3.9.6\bin;%PATH%"
cd /d "%~dp0"
echo Starting Spring Boot backend...
mvn.cmd spring-boot:run
