# Strava-Beeminder integration

[Beeminder](https://beeminder.com) and [Strava](https://www.strava.com) integration.

You can view the live app at [https://strava-beeminder.herokuapp.com](https://strava-beeminder.herokuapp.com). It's deployed to Heroku for free, so it's pretty slow. It runs `rake update_goal_integrations` every 10 minutes, which gets activities from Strava and updates your Beeminder goal with any new information.


This uses the [Beeminder gem](https://github.com/beeminder/beeminder-gem).

It uses Strava's OAuth but requires manually entering a Beeminder token. Srys.

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


===

Many thanks to this article on [running sidekiq for free on Heroku](https://coderwall.com/p/fprnhg/free-background-jobs-on-heroku) and this [other article on sidekiq configuration on Heroku](http://manuel.manuelles.nl/blog/2012/11/13/sidekiq-on-heroku-with-redistogo-nano/). This is a small, low intensity app and it's nice to be able to run it for free.