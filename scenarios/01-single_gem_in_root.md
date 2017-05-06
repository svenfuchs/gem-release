## Scenario <%= num %>: Single gem in root

### Setup

```
cd /tmp
rm -rf foo
gem bootstrap foo
cd foo
tree -a -I .git
```

### Directory structure

```
.
├── Gemfile
├── LICENSE.md
├── foo.gemspec
└── lib
    ├── foo
    │   └── version.rb
    └── foo.rb
```

### Behaviour

```
# this bumps foo
cd /tmp/foo; gem bump

# this also bumps foo
cd /tmp/foo; gem bump foo
```

### Demo

![gem-release-scenario-1](https://cloud.githubusercontent.com/assets/2208/25634572/68d1fd20-2f7b-11e7-83bc-9e11f60438f3.gif)

