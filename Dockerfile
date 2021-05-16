FROM python:3.9.5-slim-buster

# renovate: datasource=github-tags depName=DuckBoss/JJMumbleBot versioning=semver
ENV JJMUMBLEBOT_VERSION v5.1.1

RUN set -ex; \
    \
    groupadd --force --system --gid 608 mumblebot; \
    useradd --no-log-init --system --gid mumblebot --no-create-home --uid 608 mumblebot || true; \
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
VOLUME [ "/app/JJMumbleBot/cfg" ]

USER mumblebot:mumblebot

ENTRYPOINT ["python", "/app"]
