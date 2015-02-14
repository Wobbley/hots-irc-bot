# Heroes of the Storm IRC bot

## Code status

[![Build Status](https://travis-ci.org/chadrien/hots-irc-bot.svg?branch=master)](https://travis-ci.org/chadrien/hots-irc-bot)
[![Test Coverage](https://codeclimate.com/github/chadrien/hots-irc-bot/badges/coverage.svg)](https://codeclimate.com/github/chadrien/hots-irc-bot)
[![Dependency Status](https://www.versioneye.com/user/projects/54da6f1cc1bbbd5f8200023d/badge.svg?style=flat)](https://www.versioneye.com/user/projects/54da6f1cc1bbbd5f8200023d)
[![Code Climate](https://codeclimate.com/github/chadrien/hots-irc-bot/badges/gpa.svg)](https://codeclimate.com/github/chadrien/hots-irc-bot)

## Run

* Get sources
* Copy `config.yml.dist` to `config.yml` and edit it with your configuration
* Install dependencies with [bundler](http://bundler.io/) (`bundle install`)
* Run the bot: `bundle exec rake run`

## Available bot commands

* getbt USERNAME - Print the BattleTag for the entered name
* addbt BATTLETAG REGION - Saves your BattleTag
* removebt - Remove your BattleTag from the database
* rating USERNAME - Replies with a list of players with the given BattleTag from HotsLogs
* rotation - Prints the current free hero rotation
* tierlist - Replies with the url for the Zuna tierlist
* streams - List live featured streams
* tips - Links the tips section
* tips USERNAME - Links the tips section and highlights user
* mumble - Prints server info of the Reddit Mumble
* ts - Prints server info of the Reddit Teamspeak
* bug - Submit an issue the bot's bug tracker
* help COMMAND - Displays help information for the COMMAND
* help - Lists available commands

## Streams module

`!streams` displays a list of [twitch.tv](http://www.twitch.tv/) streams that are currently live.

To be able to add or remove streams from the streams list, you need to be a stream admin. Stream admins are managed via
the `config.yml` file.

Stream admins have the following additional commands:

* addstream STREAM — Stream can be a channel name (*khaldor*) or a twitch URL (*http://www.twitch.tv/khaldor*)
* removestream STREAM — Stream can be a channel name (*khaldor*) or a twitch URL (*http://www.twitch.tv/khaldor*)
* liststreams — List all streams currently in the database

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)
