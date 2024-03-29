FROM golang:1.17-alpine as build-env
 
# Set environment variable
#ENV APP_NAME sample-dockerize-app
#ENV CMD_PATH main.go
WORKDIR /main
# Copy application data into image
#COPY . $GOPATH/src/$APP_NAME
COPY . .
#WORKDIR $GOPATH/src/$APP_NAME
 
 RUN golang install
# Budild application
RUN CGO_ENABLED=0 go build -v -o /$APP_NAME $GOPATH/src/$APP_NAME/$CMD_PATH
 
# Run Stage
FROM alpine:3.14
 
# Set environment variable
ENV APP_NAME GO-WORK
 
# Copy only required data into this image
COPY --from=build-env /$APP_NAME .
 
# Expose application port
EXPOSE 8081
 
# Start app
CMD ./$APP_NAME