# gem release [![Build Status](https://secure.travis-ci.org/svenfuchs/gem-release.png)](http://travis-ci.org/svenfuchs/gem-release)

This gem plugin adds a `bootstrap`, `bump`, `tag` and a `release` command to the rubygems `gem` command.

The `bump` command

 * bumps the version number defined in `lib/[gem_name]/version.rb` to the next major, minor or patch level or to a given, particular version number

The `tag` command

 * executes `git tag -am "tag [tag_name]" [tag_name]` and
 * executes `git push --tags origin`

... with `tag_name` being the version number as specified in your .gemspec preceded  by `v` (e.g. `v0.0.1`).

The `release` command

 * builds a gem from your gemspec and
 * pushes it to rubygems.org
 * deletes the gem file
 * optionally invokes the `tag` command

The `gemspec` command

 * generates an initial `[gem_name].gemspec` file with sane defaults (will overwrite an existing gemspec)

The `bootstrap` command

 * generates an initial `[gem_name].gemspec` file with sane defaults
 * optionally scaffolds: `lib/[gem_name]/version.rb`, `README.md`, `test/`
 * optionally inits a git repo, creates it on github and pushes it to github (requires git config for `github.user` and `github.token` to be set)

## Installation

Obviously ...

    $ gem install gem-release

## Usage

    $ gem release your.gemspec       # builds the gem and pushes it to rubygems.org
    $ gem release                    # uses the first *.gemspec in the current working directory
    $ gem release --tag              # also executes gem tag

    $ gem tag                        # creates a git tag and pushes tags to the origin repository

    $ gem gemspec                    # generates a [gem_name].gemspec using  Dir["{lib/**/*,[A-Z]*}"]
    $ gem gemspec --strategy gig     # uses s.files = `git ls-files app lib`.split("\n")

    $ gem bootstrap
    $ gem bootstrap --scaffold       # scaffolds lib/[gem_name]/version.rb, README, test/
    $ gem bootstrap --github         # inits a git repo, creates it on github and pushes it to github
                                     # (requires git config for github.user and github.token to be set)

    $ gem bump                       # Bump the gem version to the next patch level (e.g. 0.0.1 to 0.0.2)
    $ gem bump --version 1.1.1       # Bump the gem version to the given version number
    $ gem bump --version major       # Bump the gem version to the next major level (e.g. 0.0.1 to 1.0.0)
    $ gem bump --version minor       # Bump the gem version to the next minor level (e.g. 0.0.1 to 0.1.0)
    $ gem bump --version patch       # Bump the gem version to the next patch level (e.g. 0.0.1 to 0.0.2)
    $ gem bump --push                # Bump and git push to origin
    $ gem bump --tag                 # Bump and tag gem and pushes tags to the origin repository
    $ gem bump --no-commit           # Bump the gem version but don't git commit
                                     #  (will be ignored if combined with push or tag)

If the current directory (and subdirectories) contain multiple `*.gemspec` files then each of these gems will be bumped
to the same version. I.e. gem-release will search for `lib/[gem_name]/version.rb` files and bump the version in each of
them. The version will either be the version specified with the --version option or the next patch level for the first
version.rb file encountered.

## License

[MIT License](https://github.com/svenfuchs/gem-release/blob/master/MIT-LICENSE)
