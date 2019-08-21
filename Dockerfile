FROM python:3.7.4-slim-buster

COPY requirements.txt /tmp/
RUN pip install -r tmp/requirements.txt

RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser

COPY app.py .

CMD [ "python", "app.py" ]

