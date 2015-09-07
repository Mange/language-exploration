package main

import (
	"encoding/json"
	"fmt"
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

const (
	Text = "text/plain"
	JSON = "application/json"
)

// We do really bad content-negotiation here but there's no library to do content negotiation in Go yet...
func negotiate(accept string, fallback string) string {
	if len(accept) == 0 {
		return fallback
	}

	parts := strings.Split(accept, ",")
	for _, part := range parts {
		if part == "*" || part == "*/*" {
			return fallback
		} else if part == Text || part == "text/*" {
			return Text
		} else if part == JSON || part == "application/*" {
			return JSON
		}
	}

	return fallback
}

func currentTimeApi(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	accepted := negotiate(r.Header.Get("Accept"), Text)

	if accepted == JSON {
		currentTimeApiJson(w, r, p)
	} else {
		currentTimeApiText(w, r, p)
	}
}

func currentTimeApiText(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	currentTime := time.Now()

	w.Header().Set("Content-Type", "text/plain; coding=utf-8")
	fmt.Fprintf(w, currentTimeText(currentTime))
}

func currentTimeApiJson(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	currentTime := time.Now()

	w.Header().Set("Content-Type", "application/json; coding=utf-8")
	fmt.Fprintf(w, currentTimeJson(currentTime))
}

type TimeStruct struct {
	Stamp     int64   `json:"stamp"`
	Fullstamp float64 `json:"fullstamp"`
	String    string  `json:"string"`
}

func currentTimeText(time time.Time) string {
	if time.Minute() >= 30 {
		return fmt.Sprintf("half past %d", time.Hour())
	} else {
		return fmt.Sprintf("%d O'clock", time.Hour())
	}
}

func currentTimeJson(currentTime time.Time) string {
	payload := TimeStruct{
		Stamp:     currentTime.Unix(),
		Fullstamp: (float64(currentTime.UnixNano()) / 1.0E9),
		String:    currentTime.Format(time.RFC3339),
	}

	body, err := json.Marshal(payload)
	if err != nil {
		log.Panic(err)
	}

	return string(body)
}

func main() {
	router := httprouter.New()
	router.GET("/api/current-time.txt", currentTimeApiText)
	router.GET("/api/current-time.json", currentTimeApiJson)
	router.GET("/api/current-time", currentTimeApi)

	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "3000"
	}
	log.Print(fmt.Sprintf("Starting server on localhost:%v", port))
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", port), router))
}
