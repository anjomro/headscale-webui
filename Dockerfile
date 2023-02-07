FROM python:3.11

WORKDIR /app
COPY . /app
COPY requirements.txt  /

ENV TZ="UTC"
ENV HS_SERVER="http://localhost/"
ENV KEY=""

RUN pip install -r /app/requirements.txt

USER 1000:1000

VOLUME /headscale 
VOLUME /data

EXPOSE 5000/tcp

CMD ["uwsgi","--http", "0.0.0.0:5000", "--master", "-p", "4", "-w", "server:app"]