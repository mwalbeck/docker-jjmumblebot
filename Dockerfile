FROM python:3.10.11-slim-bullseye@sha256:0d7277d8f2ddfada20efedb1e9bc7e2cc3f7b0c7a7e59f9ba72c3f8145decdb5

# renovate: datasource=github-tags depName=DuckBoss/JJMumbleBot versioning=semver
ENV JJMUMBLEBOT_VERSION v5.2.0
ENV JJMUMBLEBOT_PLUGIN_STREAM_VERSION master

RUN set -ex; \
    \
    groupadd --force --system --gid 608 mumblebot; \
    useradd --no-log-init --system --gid mumblebot --home-dir /tmp/mumblebot --uid 608 mumblebot || true; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        vlc \
        libopus0 \
        gcc \
        libc-dev \
        openssl \
        git \
    ; \
    \
    git clone --branch $JJMUMBLEBOT_VERSION https://github.com/DuckBoss/JJMumbleBot.git /app; \
    \
    git clone --branch $JJMUMBLEBOT_PLUGIN_STREAM_VERSION https://git.walbeck.it/mwalbeck/JJMumbleBot-plugin-stream.git /app/JJMumbleBot/plugins/extensions/stream; \
    \
    pip install --no-cache-dir -r /app/requirements/requirements.txt -r /app/requirements/web_server.txt; \
    \
    apt-get purge -y --autoremove \
        gcc \
        libc-dev \
        git \
    ; \
    rm -rf \
        /var/lib/apt/lists/* \
        /app/.git \
        /app/.gitattributes \
        /app/.github \
        /app/.gitignore \
        /app/.travis.yml \
        /app/Dockerfile \
        /app/conftest.py \
        /app/docker-compose.yml \
        /app/pytest.ini \
        /app/requirements \
    ; \
    chown -R mumblebot:mumblebot /app;

EXPOSE 7000
WORKDIR /app
VOLUME [ "/app/JJMumbleBot/cfg", "/tmp/mumblebot" ]

USER mumblebot:mumblebot

ENTRYPOINT ["python", "/app"]
