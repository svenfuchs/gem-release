## Scenario <%= num %>: Multiple gems in sub directories

### Setup

```
export GEM_RELEASE_PUSH=false
cd /tmp
rm -rf root
mkdir root
cd root
gem bootstrap foo
gem bootstrap bar
tree
```

### Directory structure

```
.
├── bar
│   ├── Gemfile
│   ├── LICENSE.md
│   ├── bar.gemspec
│   └── lib
│       ├── bar
│       │   └── version.rb
│       └── bar.rb
└── foo
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
# this bumps both foo and bar
cd /tmp/root
gem bump --recurse

# this also bumps both foo and bar
cd /tmp/root
gem bump foo bar

# this does bumps both foo and bar
cd /tmp/root
gem bump

# this bumps foo
cd /tmp/root
gem bump foo

# this bumps bar
cd /tmp/root
gem bump bar
```
