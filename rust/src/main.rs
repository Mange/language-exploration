extern crate time;

extern crate iron;
#[macro_use]
extern crate router;

use std::env;

use iron::prelude::*;
use iron::status;

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

fn current_time_json(_: &mut Request) -> IronResult<Response> {
    Ok(Response::with(
            (status::Ok, "TODO: JSON")
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

    Iron::new(router).http(("localhost", port)).unwrap();
}
