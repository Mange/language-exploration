# language exploration

> Cause the world needs more usless microservices

I wanted to try out Rust a bit. I wanted to see how mature it was, how easy it was to get started and how the tooling worked. I decided to implement a useless microservice in Ruby, Go and Rust so I can compare them and get some insights.

I'm a total n00b in both Go and Rust, so don't expect any magic in here.

## Using ##

Run `rake` to install everything and `rake test` to verify that the different implementations work correctly.

You will need to install `rust`, `ruby`, `go` and `node.js`.

### rust ###

As of this writing, you may need to latest Rust `master`. This is due to a bug in `cargo 0.4.0`, which is included in the latest `1.2.0` release. If this is no longer the most recent stable, go with stable instead of `master`.

### Go ###

Install Go and set up your `$GOPATH` according to the instructions.

**tl;dr:**

```bash
mkdir -p ~/gopath
echo "export GOPATH=\"$HOME/gopath\"" >> ~/.bashrc
export GOPATH="$HOME/gopath"
```

### Ruby ###

Make sure you are on a recent Ruby and that you have `bundler` installed. The `rake` tasks take care of the rest.

### node ###

Make sure you have `node` and `npm` installed.

### Crystal ###

Install crystal and run `crystal/server`.

To compile a binary run
```
$ crystal build crystal/server.cr --release
```

## Service definition ##

Create a service with the following API:

### `GET /api/current-time(.ext)?` ###

#### Content type ####
  1. When extension is `.json`, force JSON response.
  2. When extension is `.txt`, force plaintext response.
  3. When extension is missing, look at the `Accept` header to determine response.
  4. On no `Accept` header, a `*/*` MIME type, no supported MIME type, or invalid MIME type, force plaintext response.

##### Plaintext format #####

Respond with `14 O'clock` if local time is between (14:00-14:30].
Respond with `half past 14` if local time is between (14:30-15:00].

##### JSON format #####

Respond with the following document:

```js
{
  "stamp": 1441402488,                 // UNIX time
  "fullstamp":1441402488.379437,       // UNIX time, with decimals for precision
  "string":"2015-09-04T23:34:48+02:00" // RFC3339 formatted string
}
```
