# Build stage
FROM golang:1.25 AS builder

WORKDIR /app

# Copy Go modules and download dependencies
# Copy only go.mod (skip go.sum if missing)
COPY go.mod ./
RUN go mod download || true


# Copy the source code
COPY . .

# Build the Go binary (optimized)
RUN go build -ldflags="-s -w" -o app main.go


# Final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /app/app .

CMD ["./app"]






