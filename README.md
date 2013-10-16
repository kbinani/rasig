# rasig

is an AsakusaSatellite IRC gateway

# Requirement

* Ruby

# Usage

```
git clone https://github.com/kbinani/rasig.git rasig
cd rasig
bundle install
bundle exec ruby rasig --host=localhost --port=16668 --pollinginterval=10 &
```

# How to connect to the gateway

* Setup your IRC client config
 * Nickname: use your favorite nick
 * Login name: use AsakusaSatellite login name
 * Real name: ```host=#{your asakusasatellite URL},api_key=#{your asakusasatellite API key}```
 * Server host: localhost (this should be same with the option argument ```--host```)
 * Server port: 16668 (this should be same with the option argument ```--port```)

* Join room
 * ```/join #{room ID}``` or ```/join #{room nickname}```

# Copyright

* Copyright (C) 2013, kbinani
* The MIT License