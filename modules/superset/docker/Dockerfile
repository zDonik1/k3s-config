FROM apache/superset:latest

ARG INCLUDE_CHROMIUM="true"

USER root

RUN . /app/.venv/bin/activate && \
    uv pip install \
    .[postgres] \
    Authlib

USER superset

CMD ["/app/docker/entrypoints/run-server.sh"]
