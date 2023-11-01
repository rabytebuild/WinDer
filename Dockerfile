# Use a base image with Ubuntu
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip xrdp openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O ngrok.zip && \
    unzip ngrok.zip && \
    rm ngrok.zip

# Authenticate ngrok
RUN ./ngrok authtoken 2Hd7yeF4INCKbg2aP9rGMLnDqBX_5K7WhATjW8eUxS6UoHSRa

# Enable xrdp
RUN sed -i 's/^#\(.*xrdp.*\)/\1/' /etc/xrdp/xrdp.ini

# Start xrdp service
RUN service xrdp start

# Set user password
RUN echo 'runneradmin:Rabiu2004@' | chpasswd

# Enable SSH access
RUN systemctl enable ssh && systemctl start ssh

# Expose the necessary ports
EXPOSE 3389

# Command to create the ngrok tunnel
CMD ["./ngrok", "tcp", "3389"]
