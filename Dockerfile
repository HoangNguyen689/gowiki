FROM golang:1.20

WORKDIR /app

COPY go.mod go.sum ./

COPY *.go ./
COPY tmpl/* ./tmpl/
COPY TestPage.txt ./

RUN go build -o /gowiki

CMD ["/gowiki"]