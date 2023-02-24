#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "omg does this fully work?!"
}

#[launch]
fn rocket() -> _ {
    rocket::build()
    .mount("/", routes![index])
}
