# Docker for Testing Purpose
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    sudo dialog dmidecode smartmontools inxi acpi x11-xserver-utils \
    python3 enscript ghostscript htop upower hardinfo mplayer \
    cheese ffmpeg alsa-utils curl mesa-utils glmark2 \
    libatasmart-bin nmon iptraf-ng s-tui stress-ng stress vim \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY . /home/devuser/scripts/
RUN chown -R devuser:devuser /home/devuser/scripts

USER devuser
WORKDIR /home/devuser

CMD ["/bin/bash"]
