FROM rust:1.67 as builder
WORKDIR /usr/src/cmsrs
COPY . .
RUN cargo install --path .

FROM debian:bullseye-slim
RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/cmsrs /usr/local/bin/cmsrs
CMD ["cmsrs"]
