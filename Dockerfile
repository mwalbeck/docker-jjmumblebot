FROM python:3.10.7-slim-bullseye@sha256:90b7cdff7f8bdbf43778bd5131bb62f7c83495462f562bd62baefdb69bf09bca

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
