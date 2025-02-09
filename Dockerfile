# use the openjdk 11 image because ib-gateway requires java 11
FROM openjdk:11-jre-slim

# set the working directory
WORKDIR /averysgame

# copy the jar file for ib-gateway into the container
RUN mkdir -p /averysgame/ib-gateway
COPY ibgateway-latest-standalone.jar /averysgame/ib-gateway/ibgateway-latest-standalone.jar

# install python to the image and packages for the project
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install ib_async pandas numpy scikit-learn tensorflow jupyter

# copy the ib-gateway configuration file into the container
COPY .docker-image/ibgateway.ini /averysgame/ib-gateway/ibgateway.ini

# expose the ib-gateway and jupyter notebook ports respectively
EXPOSE 4000
EXPOSE 8888

# define environment variables
ENV IBGATEWAY_DIR=/averysgame/ib-gateway

# run ib-gateway
CMD ["java", "-jar", "/averysgame/ib-gateway/ibgateway-latest-standalone.jar"]