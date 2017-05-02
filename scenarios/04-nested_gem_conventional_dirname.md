## Scenario <%= num %>: Nested gem with a conventional sub directory name

### Setup

```
cd /tmp
rm -rf sinja
gem bootstrap sinja
cd sinja
mkdir extensions
cd extensions
gem bootstrap sinja-sequel
cd /tmp/sinja
tree -a -I .git
```

### Directory structure

```
.
├── Gemfile
├── LICENSE.md
├── extensions
│   └── sinja-sequel
│       ├── Gemfile
│       ├── LICENSE.md
│       ├── lib
│       │   └── sinja
│       │       ├── sequel
│       │       │   └── version.rb
│       │       └── sequel.rb
│       └── sinja-sequel.gemspec
├── lib
│   ├── sinja
│   │   └── version.rb
│   └── sinja.rb
└── sinja.gemspec
```

### Behaviour

```
# this bumps both sinja and sinja-sequel
cd /tmp/sinja; gem bump --recurse

# this bumps sinja
cd /tmp/sinja; gem bump

# this also bumps sinja
cd /tmp/sinja; gem bump sinja

# this bumps sinja-sequel
cd /tmp/sinja; gem bump sinja-sequel

# this also bumps sinja-sequel
cd /tmp/sinja/extensions/sinja-sequel; gem bump

# this also bumps sinja-sequel
cd /tmp/sinja/extensions/sinja-sequel; gem bump sinja-sequel
```

### Demo

![gem-release-scenario-4](https://cloud.githubusercontent.com/assets/2208/25634576/68dce4a6-2f7b-11e7-9d6b-571d672e4998.gif)
