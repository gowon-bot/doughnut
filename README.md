<img src="Doughnut Banner.png" alt="Doughnut" width="500"/>

_心には君形の穴が空いてるの_
_Just like a doughnut_

This project is part of Gowon bot ([main repo](https://github.com/jivison/gowon))

## Running yourself

Copy `services.example.yml` to `services.yml` and fill out the services.

Copy `.env.example` to `.env` and fill out the missing variables.

## Structure

Doughnut provides 3 endpoints:

`/token/request` - Request a token, requires a valid Discord auth code

`/token/destroy` - Destroy an existing token

`/services/:service/*` - Make a request to a service. `:service` needs to match one of the services in `services.yml`, the rest of the path will be passed on through the url defined there.

For forwarded requests, Doughnut adds a custom header, `Doughnut-Discord-Id`, which comes from the token. Services can use this to verify that a requester's discord id matches the request's discord id.

## Any questions?

Somethings broken? Just curious how something works?

Feel free to shoot me a Discord dm at `@abbyfour`
or join the support server! https://discord.gg/9Vr7Df7TZf
