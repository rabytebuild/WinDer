# Use a base image with Windows and PowerShell Core
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set the working directory
WORKDIR C:\app

# Download and install ngrok
RUN powershell -Command $ErrorActionPreference = 'Stop'; \
    Invoke-WebRequest -Uri 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip' -OutFile 'ngrok.zip'; \
    Expand-Archive -Path 'ngrok.zip' -DestinationPath C:\app; \
    Remove-Item -Path 'ngrok.zip'

# Configure ngrok authentication using an environment variable
ENV NGROK_AUTH_TOKEN=

# Enable Terminal Services and remote desktop access
RUN powershell -Command $ErrorActionPreference = 'Stop'; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0; \
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 1; \
    New-LocalUser -Name 'runneradmin' -Password (ConvertTo-SecureString -AsPlainText 'Rabiu2004@' -Force); \
    Add-LocalGroupMember -Group 'Administrators' -Member 'runneradmin'

# Set the command to create the ngrok tunnel
CMD ["powershell", "-NoProfile", "-Command", "./ngrok/ngrok.exe", "tcp", "3389"]
