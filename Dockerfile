FROM python:3.8

RUN apt-get update && apt-get -y install \
    libpq-dev

WORKDIR /fastapi
ADD ./  ./
RUN pip install --no-cache-dir --upgrade -r ./requirements.txt


WORKDIR /fastapi/app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]