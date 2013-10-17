# rasig

is an AsakusaSatellite IRC gateway

# Requirement

* Ruby

# Install and Usage

## Windows

```
git clone https://github.com/kbinani/rasig.git rasig
cd rasig
bundle install
```

Then start directly:

```
bundle exec ruby rasig --port=16668 --pollinginterval=10 &
```

or start with daemon mode:

```
start util\launch_rasig.vbs
```

## Other

```
git clone https://github.com/kbinani/rasig.git ~/.rasig
cd ~/.rasig
bundle install --path .bundle
bundle exec ruby rasig --port=16668 --pollinginterval=10 &
```

# How to connect to the gateway

* Setup your IRC client config
 * Nickname: use your favorite nick
 * Login name: use AsakusaSatellite login name
 * Real name: ```host=#{your asakusasatellite URL} api_key=#{your asakusasatellite API key}```
 * Server host: 127.0.0.1
 * Server port: 16668 (this should be same with the option argument ```--port```)

* Join room
 * ```/join #{room ID}``` or ```/join #{room nickname}```

# Copyright

* Copyright (C) 2013, kbinani
* The MIT License