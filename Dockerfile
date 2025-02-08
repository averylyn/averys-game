# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set environment variables
ENV IBC_VERSION=3.8.1
ENV IBG_VERSION=1012.2g
ENV TWS_API_VERSION=9.72.18

# Set the working directory in the container
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Download and install IBGateway
RUN wget https://download2.interactivebrokers.com/installers/ibgateway/${IBG_VERSION}/ibgateway-${IBG_VERSION}-standalone-linux-x64.sh \
    && chmod +x ibgateway-${IBG_VERSION}-standalone-linux-x64.sh \
    && ./ibgateway-${IBG_VERSION}-standalone-linux-x64.sh -q \
    && rm ibgateway-${IBG_VERSION}-standalone-linux-x64.sh

# Download and install IBC (IB Controller)
RUN wget https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip \
    && unzip IBCLinux-${IBC_VERSION}.zip -d /opt/ibc \
    && rm IBCLinux-${IBC_VERSION}.zip

# Download and install TWS API
RUN wget https://interactivebrokers.github.io/downloads/twsapi_macunix.972.18.jar \
    && mkdir -p /opt/twsapi \
    && mv twsapi_macunix.972.18.jar /opt/twsapi/

# Copy configuration files
COPY config.ini /opt/ibc/config.ini
COPY ibgwrapper.sh /app/ibgwrapper.sh
RUN chmod +x /app/ibgwrapper.sh

# Expose necessary ports
EXPOSE 4001 4002

# Start IBGateway with IBC
CMD ["./ibgwrapper.sh"]