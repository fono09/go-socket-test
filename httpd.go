package main

import (
	"fmt"
	"net"
	"net/http"
	"os"
)

func main() {

	fmt.Println("Unix HTTP server")
	var sock_path = "/var/run/gopher/go-socket-test.sock"

	root := "."
	os.Remove(sock_path)

	server := http.Server{
		Handler: http.FileServer(http.Dir(root)),
	}

	unixListener, err := net.Listen("unix", sock_path)
	if err != nil {
		panic(err)
	}
	server.Serve(unixListener)
}
