## Scenario <%= num %>: Multiple gems in root

### Setup

```
cd /tmp
rm -rf foo bar
gem bootstrap foo
cd foo
gem bootstrap bar --dir .
tree -a -I .git
```

### Directory structure

```
.
├── Gemfile
├── LICENSE.md
├── bar.gemspec
├── foo.gemspec
└── lib
    ├── bar
    │   └── version.rb
    ├── bar.rb
    ├── foo
    │   └── version.rb
    └── foo.rb
```

### Behaviour

```
# this bumps both foo and bar
cd /tmp/foo; gem bump --recurse

# this also bumps both foo and bar
cd /tmp/foo; gem bump foo bar

# this bumps foo (because it's the first gemspec found)
cd /tmp/foo; gem bump

# this bumps foo
cd /tmp/foo; gem bump foo

# this bumps bar
cd /tmp/foo; gem bump bar
```

### Demo

![gem-release-scenario-2](https://cloud.githubusercontent.com/assets/2208/25634575/68dcb670-2f7b-11e7-991e-901283164d21.gif)
