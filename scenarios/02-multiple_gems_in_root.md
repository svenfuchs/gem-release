## Scenario <%= num %>: Multiple gems in root

### Setup

```
export GEM_RELEASE_PUSH=false
cd /tmp
rm -rf foo
gem bootstrap foo
cd foo
gem bootstrap bar --dir .
tree
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
cd /tmp/foo
gem bump --recurse

# this also bumps both foo and bar
cd /tmp/foo
gem bump foo bar

# this bumps foo (because it's the first gemspec found)
cd /tmp/foo
gem bump

# this bumps foo
cd /tmp/foo
gem bump foo

# this bumps bar
cd /tmp/foo
gem bump bar
```
