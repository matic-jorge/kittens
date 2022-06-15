FROM ruby:2.4.9 AS base

RUN useradd -ms /bin/bash matic
RUN mkdir /app && chown matic /app

WORKDIR /app
USER matic

FROM base AS local_compose

COPY docker/air_1.40.1_linux_amd64 air
COPY docker/air.toml .

ENTRYPOINT [ "/app/air" ]
CMD [ "-c", "/app/air.toml" ]

FROM base as test

COPY . .
RUN echo "Starting to build" && \
	bundle config set --local path /app && \
	bundle install

FROM test as prod

COPY scripts/run.sh .

ENTRYPOINT [ "/app/scripts/run.sh" ]