FROM python:3
COPY hello.py /
CMD [ "python", "./hello.py" ]

