# Hob on Railway: the official image (FFatTiger/hob 1.5.0, MIT), unmodified,
# plus a start script that listens on [::]:$PORT and fixes ownership of Railway's root-owned /data
# volume and then drops to the unprivileged node user.
# HOB_PASSWORD is generated per deploy by the template and hashed into /data
# on first start, so there is no open first-visitor setup.
FROM ghcr.io/ffattiger/hob:1.5.0@sha256:66e23529432890f7680bcf2b9589ac0364790dca3d736179bdb6806c09634b0a
USER root
COPY railway/start.sh /usr/local/bin/hob-railway-start
RUN chmod 755 /usr/local/bin/hob-railway-start
ENV HOB_HOME=/data HOB_HOST=:: PORT=8080 TZ=UTC
EXPOSE 8080
ENTRYPOINT ["tini", "--", "/usr/local/bin/hob-railway-start"]
CMD []
