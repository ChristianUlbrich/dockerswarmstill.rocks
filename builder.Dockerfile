FROM python:3.11-bookworm

COPY . /opt/build

WORKDIR /opt/build

RUN pip install -r requirements-docs.txt

ENTRYPOINT ["/usr/local/bin/python", "scripts/docs.py"]

