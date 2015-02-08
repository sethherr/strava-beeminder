# Strava-Beeminder integration

[Beeminder](https://beeminder.com) and [Strava](https://www.strava.com) integration.

You can view the live app at [https://strava-beeminder.herokuapp.com](https://strava-beeminder.herokuapp.com). It's deployed to Heroku for free, so it's pretty slow. It runs `rake update_goal_integrations` every hour, which pings beeminder with any new strava information.


Uses gems for [Beeminder](https://github.com/beeminder/beeminder-gem) and [Strava](https://github.com/jaredholdcroft/strava-api-v3).

It uses Strava's OAuth but requires manually entering a Beeminder token. Srys.

===

This uses timestamps for everything, because I think timestamps are the only way to deal with time in APIs.

===

Testing locally requires adding a `.env` file with these values:

```
STRAVA_CLIENT_ID
STRAVA_CLIENT_SECRET
STRAVA_ACCESS_TOKEN
BEEMINDER_ACCESS_TOKEN
SAMPLE_BEEMINDER_GOAL_TITLE
```

You'll have to actually get the things from Strava and Beeminder.
