# Global ARG, available to all stages (if renewed)
ARG WORKDIR="/app"
FROM python:3.11
# AS builder

# Renew (https://stackoverflow.com/a/53682110):
ARG WORKDIR

# Don't buffer `stdout`:
ENV PYTHONUNBUFFERED=1
# Don't create `.pyc` files:
ENV PYTHONDONTWRITEBYTECODE=1



RUN pip install poetry && poetry config virtualenvs.in-project true



WORKDIR ${WORKDIR}

COPY --chown=1000:1000 . .

# Install dependencies globally with poetry
RUN poetry install --only main

# If seperated in builder and runner, add user in runner
# RUN adduser app -DHh ${WORKDIR} -u 1000
RUN useradd -ms /bin/bash -u 1000 app
USER 1000

#FROM python:3.11-alpine
#
#ARG WORKDIR
#
#WORKDIR ${WORKDIR}
#
## For options, see https://boxmatrix.info/wiki/Property:adduser

#COPY --chown=app:app --from=builder ${WORKDIR} .


ENV TZ="UTC"
ENV HS_SERVER="http://localhost/"
ENV KEY=""
ENV BASE_PATH="http://127.0.0.1/"



VOLUME /headscale
VOLUME /data

EXPOSE 5000/tcp

ENTRYPOINT ["/app/entrypoint.sh"]

#CMD ["uwsgi","--http", "0.0.0.0:5000", "--master", "-p", "4", "-w", "server:app"]
# CMD ["gunicorn","-w", "4", "-b", "0.0.0.0:5000", "server:app"]
CMD gunicorn -w 4 -b 0.0.0.0:5000 server:app