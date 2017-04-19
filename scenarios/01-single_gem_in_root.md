## Scenario <%= num %>: Single gem in root

### Setup

```
export GEM_RELEASE_PUSH=false
cd /tmp
rm -rf foo
gem bootstrap foo
tree
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
cd /tmp/foo
gem bump

# this also bumps foo
cd /tmp/foo
gem bump foo
```
