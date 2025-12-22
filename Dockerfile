FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"
RUN flutter --version

WORKDIR /app
COPY . .
RUN flutter pub get
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]