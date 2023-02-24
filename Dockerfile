# FROM rust:1.67 as builder
# WORKDIR /usr/src/cmsrs
# COPY . .
# RUN cargo install --path .
# 
# FROM debian:bullseye-slim
# RUN apt-get update && rm -rf /var/lib/apt/lists/*
# COPY --from=builder /usr/local/cargo/bin/cmsrs /usr/local/bin/cmsrs
# CMD ["cmsrs"]

FROM rustlang/rust as builder

WORKDIR /opt/cmsrs

RUN apt-get update

COPY ["Cargo.toml", "Cargo.lock",  "./"]
# Make empty fake project
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN --mount=type=cache,target=/usr/local/cargo/registry cargo build --release

# Clobber fake project with real project
COPY src src
# RUN --mount=type=cache,target=/usr/local/cargo/registry <<EOF
  # set -e
  # touch src/main.rs
  # cargo install --path .
# EOF
RUN --mount=type=cache,target=/usr/local/cargo/registry set -e
RUN --mount=type=cache,target=/usr/local/cargo/registry touch src/main.rs
RUN --mount=type=cache,target=/usr/local/cargo/registry cargo install --path .

FROM debian:bullseye-slim

WORKDIR /opt/cmsrs

ENV TZ="America/Los_Angeles"

RUN apt-get update && apt-get install ca-certificates -yq

COPY --from=builder /usr/local/cargo/bin/cmsrs /usr/local/bin/cmsrs

ADD public public
ADD Rocket.toml .

CMD ["cmsrs"]
