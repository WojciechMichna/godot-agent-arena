FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    xvfb \
    x11vnc \
    websockify \
    openbox \
    x11-apps \
    wget \
    tar \
    xz-utils \
    xvfb \
    libasound2 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libx11-xcb1 \
    libxt6 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libnss3 \
    libatk1.0-0 \
    libcups2 \
    libxss1 \
    libxshmfence1 \
    apache2-utils \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz /tmp/novnc.tar.gz

RUN mkdir -p /opt/novnc && \
    tar -xzf /tmp/novnc.tar.gz -C /opt/novnc --strip-components=1 && \
    rm /tmp/novnc.tar.gz && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

ENV DISPLAY=:99

RUN mkdir -p /etc/docker_boot.d

COPY 78-start-vnc.sh /etc/docker_boot.d/78-start-vnc.sh

RUN chmod +x  /etc/docker_boot.d/78-start-vnc.sh

ENV PATH=/opt/miniforge3/bin:${PATH}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" && tar xJf firefox.tar.bz2

RUN wget -q https://github.com/godotengine/godot/releases/download/4.6.2-stable/Godot_v4.6.2-stable_linux.x86_64.zip -O /tmp/godot.zip && \
    unzip /tmp/godot.zip -d /opt && \
    rm /tmp/godot.zip && \
    chmod +x /opt/Godot_v4.6.2-stable_linux.x86_64 && \
    ln -s /opt/Godot_v4.6.2-stable_linux.x86_64 /opt/godot

COPY 79-start-godot.sh /etc/docker_boot.d/79-start-godot.sh

RUN chmod +x /etc/docker_boot.d/79-start-godot.sh

EXPOSE 9488

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]
