## Demo

### Setup

```
cd /tmp
rm -rf gem-release-demo
gem bootstrap gem-release-demo --github --push --rspec --travis
cd gem-release-demo
tree -a -I .git
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
# bumps to the next pre-release version 0.0.2.pre.1, also pushes the commit,
# tags it, and pushes the tag
gem bump -v pre

# bumps to the patch version 0.0.2
gem bump -v patch

# bumps to the minor version 0.1.0
gem bump -v minor

# bumps to the patch version 1.0.0
gem bump -v major

# bumps to the given version 1.2.3
gem bump -v 1.2.3

# tags the current commit
gem tag

# pushes the gem to rubygems or a compatible host
gem release

# bumps the version, tags, releases, and pushes all in one go
gem bump -v major --push --tag --release
```
