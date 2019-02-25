FROM ubuntu:bionic
ARG  requirements=requirements.txt
RUN mkdir /code
ADD apt.txt /code/apt.txt

# project dependencies
RUN apt-get update
RUN apt-get install -y $(grep -vE "^\s*#" /code/apt.txt  | tr "\n" " ") && apt-get clean all && apt-get autoclean
RUN apt-get upgrade -y
RUN useradd -ms /bin/bash django --uid 1000
WORKDIR /code

ADD *requirements.txt /code/
ADD manage.py /code/manage.py
ADD README.md /code/README.md

ADD losamax /code/losamax
RUN chown django:django -R /code
USER django
RUN python3.6 -m venv venv
RUN /code/venv/bin/pip3.6 install setuptools wheel -U
RUN /code/venv/bin/pip3.6 install --no-cache-dir -r ./{requirements}$ --upgrade
USER django
RUN mkdir -p /code/public/static /code/public/media
