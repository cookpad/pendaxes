# Pendaxes

Throw axes to pending makers!

Leaving a pending long time is really bad, shouldn't be happened. They'll make a trouble.
So, this gem sends notification to committer that added pending after a while from the commit.

Avoid the trouble due to pending examples :D

## Installation

(1.9 required)

    $ gem install pendaxes

## Usage

    $ pendaxes config_file.yml

### Configuration

    detection:
      name: rspec
    workspace:
      path: /path/to/be/cloned/repository
      repository: "https://github.com/user/repo.git"
    report:
      name: haml
      include_allowed: true
      to: "report.html"
      commit_url: "https://github.com/user/repo/commit/%commit%"
      file_url: "https://github.com/user/repo/blob/HEAD/%file%#L%line%"
    notifications:
      - name: terminal
      - name: mail
        reporter:
          name: haml
          include_allowed: true
          commit_url: "https://github.com/user/repo/commit/%commit%"
          file_url: "https://github.com/user/repo/blob/HEAD/%file%#L%line%"

## Axes?

斧... Axe in Japanese. Recently, Japanese engineer says a review comment as axe (斧).

Throwing axe means "comment my opnion."

This script throws axe to committer, about his/her uncontrolled pending tests.

## Requirements

* Ruby 1.9+ (1.9.3 supported)
* git

we're using `git grep` and `git blame` to detect pendings, and supported test suite is currently `rspec` only.
this gem supports git managed repository, and using rspec.

Patches for other environment are welcomed. :-)

## License

MIT License:

    (c) 2012 Shota Fukumori (sora_h)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


