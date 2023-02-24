#[macro_use]
extern crate rocket;
use rocket::fs::FileServer;
use rocket::response::content::RawJson;
use rocket::State;

use std::sync::atomic::{AtomicUsize, Ordering};

struct UserCount(AtomicUsize);

#[get("/count")]
fn count(user_count: &State<UserCount>) -> RawJson<String> {
    RawJson(format!(
        "{{\"user_count\": {}}}",
        user_count.0.load(Ordering::Relaxed)
    ))
}

#[post("/count")]
fn inc_count(user_count: &State<UserCount>) {
	user_count.0.fetch_add(1, Ordering::SeqCst);
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .manage(UserCount(AtomicUsize::new(0)))
        .mount("/", FileServer::from("public/"))
        .mount("/api", routes![count, inc_count])
}
