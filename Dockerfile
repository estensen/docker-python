FROM python:3.7.4-slim-buster AS base
FROM base AS builder

RUN pip install pipenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY Pipfile* /tmp/
RUN cd /tmp && pipenv lock --requirements > requirements.txt
RUN pip install -r tmp/requirements.txt

RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

COPY app.py .


FROM base
COPY --from=builder /home/appuser .
COPY --from=builder /opt/venv /opt/venv
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
CMD [ "python", "app.py" ]

