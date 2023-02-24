FROM rust:1.67 as builder
WORKDIR /usr/src/app
COPY ./ ./
RUN cargo install --path .

FROM debian:bullseye-slim
COPY --from=builder /usr/local/cargo/bin/cmsrs /usr/local/bin/cmsrs
CMD ["cmsrs"]
