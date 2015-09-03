extern crate time;
extern crate rustc_serialize;
extern crate iron;
#[macro_use]
extern crate router;

use std::env;

use iron::prelude::*;
use iron::status;

use rustc_serialize::Encodable;
use rustc_serialize::json;

fn current_time_negotation(req: &mut Request) -> IronResult<Response> {
    current_time_text(req)
}

fn current_time_text(_: &mut Request) -> IronResult<Response> {
    let now = time::now();

    let message = if now.tm_min >= 30 {
        format!("half past {}", now.tm_hour)
    } else {
        format!("{} O'clock", now.tm_hour)
    };

    Ok(Response::with(
            (status::Ok, message)
    ))
}

#[derive(RustcEncodable)]
struct TimeData {
    stamp: i64,
    fullstamp: f64,
    string: String,
}

fn current_time_json(_: &mut Request) -> IronResult<Response> {
    let now = time::now();
    let timespec = now.to_timespec();

    let payload = TimeData {
        stamp: timespec.sec,
        fullstamp: (timespec.sec as f64 + (timespec.nsec as f64 / 10.0e9)),
        string: now.rfc3339().to_string(),
    };

    Ok(Response::with(
            (status::Ok, json::encode(&payload).ok().expect("Could not encode JSON"))
    ))
}

fn main() {
    let port = match env::var("PORT") {
        Ok(val) => u16::from_str_radix(&val, 10).
            map_err(|e| format!("Could not determine port number: {}", e)).
            unwrap(),
        Err(_) => 3000
    };

    let router = router!(
        get "/api/current-time" => current_time_negotation,
        get "/api/current-time.txt" => current_time_text,
        get "/api/current-time.json" => current_time_json
    );

    println!("Starting server on port {}", port);
    Iron::new(router).http(("localhost", port)).unwrap();
}
