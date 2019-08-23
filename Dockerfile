FROM ubuntu AS base
FROM base AS az

RUN apt-get update
RUN apt-get install -y curl
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


FROM base AS builder

RUN apt-get update
RUN apt-get install -y python3-pip
RUN pip3 install pipenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Hack to avoid runtime error
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY Pipfile* /tmp/
RUN cd /tmp && pipenv lock --requirements > requirements.txt
RUN pip3 install -r tmp/requirements.txt

RUN useradd --create-home appuser
USER appuser
WORKDIR /home/appuser

COPY app.py .


FROM az

RUN useradd --create-home appuser
USER appuser
WORKDIR /home/appuser

COPY --from=builder /home/appuser .
COPY --from=builder /opt/venv /opt/venv

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD [ "python", "app.py" ]

