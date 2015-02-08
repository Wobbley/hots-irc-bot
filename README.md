# Heroes of the Storm IRC bot

## Code status

* Stable branch:
[![Build Status](https://travis-ci.org/chadrien/hots-irc-bot.svg?branch=master)](https://travis-ci.org/chadrien/hots-irc-bot)
[![Coverage Status](https://coveralls.io/repos/chadrien/hots-irc-bot/badge.svg?branch=master)](https://coveralls.io/r/chadrien/hots-irc-bot?branch=master)
[![Dependency Status](https://www.versioneye.com/user/projects/54d57e913ca0849531000688/badge.svg?style=flat)](https://www.versioneye.com/user/projects/54d57e913ca0849531000688)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/chadrien/hots-irc-bot/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/chadrien/hots-irc-bot/?branch=master)
* Development branch:
[![Build Status](https://travis-ci.org/chadrien/hots-irc-bot.svg?branch=develop)](https://travis-ci.org/chadrien/hots-irc-bot)
[![Coverage Status](https://coveralls.io/repos/chadrien/hots-irc-bot/badge.svg?branch=develop)](https://coveralls.io/r/chadrien/hots-irc-bot?branch=develop)
[![Dependency Status](https://www.versioneye.com/user/projects/54d57e913ca0849531000688/badge.svg?style=flat)](https://www.versioneye.com/user/projects/54d57e913ca0849531000688)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/chadrien/hots-irc-bot/badges/quality-score.png?b=develop)](https://scrutinizer-ci.com/g/chadrien/hots-irc-bot/?branch=develop)

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
* tips - Links the tips section
* tips USERNAME - Links the tips section and highlights user
* mumble - Prints server info of the Reddit Mumble
* ts - Prints server info of the Reddit Teamspeak
* bug - Submit an issue the bot's bug tracker
* help COMMAND - Displays help information for the COMMAND
* help - Lists available commands

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)
