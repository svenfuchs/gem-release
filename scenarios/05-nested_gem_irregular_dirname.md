## Scenario <%= num %>: Nested gem with an irregular sub directory name

### Setup

```
export GEM_RELEASE_PUSH=false
cd /tmp
rm -rf sinja
gem bootstrap sinja
cd sinja
mkdir -p extensions
cd extensions
gem bootstrap sinja-sequel
mv sinja-sequel sequel
cd /tmp/sinja
tree
```

### Directory structure

```
.
├── Gemfile
├── LICENSE.md
├── extensions
│   └── sequel
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
cd /tmp/sinja
gem bump --recurse

# this bumps sinja
cd /tmp/sinja
gem bump

# this also bumps sinja
cd /tmp/sinja
gem bump sinja

# this bumps sinja-sequel only
cd /tmp/sinja
gem bump sinja-sequel

# this also bumps sinja-sequel only
cd /tmp/sinja/extensions/sequel
gem bump

# this also bumps sinja-sequel only
cd /tmp/sinja/extensions/sequel
gem bump sinja-sequel
```
