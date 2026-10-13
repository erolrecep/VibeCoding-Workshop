# Multi-stage build for Go present tool
FROM golang:1.24-alpine AS builder

# Install the official Go present tool
RUN go install golang.org/x/tools/cmd/present@latest

# Minimal runtime image
FROM alpine:3.21

RUN apk add --no-cache ca-certificates

WORKDIR /app

# Copy compiled present binary from builder
COPY --from=builder /go/bin/present /usr/local/bin/present

# Copy slides and assets
COPY . /app

# Expose Go present default port
EXPOSE 3999

# Run present server binding to all interfaces with play disabled for safety
CMD ["present", "-http=0.0.0.0:3999", "-play=false"]
