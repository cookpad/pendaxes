# Pendaxes

![sample notification using mail](https://img.skitch.com/20120925-essq4fdifg79axb2ssi2cyb2ne.png)

Throw axes to pending makers!

Leaving a pending long time is really bad, shouldn't be happened. They'll make a trouble.
So, this gem sends notification to committer that added pending after a while from the commit.

Avoid the trouble due to pending examples :D

## Installation

(1.9 required)

    $ gem install pendaxes

## Usage

    $ pendaxes <config_file>

See `pendaxes --help` for more.

### Configuration

    $ pendaxes --init # will write to .pendaxes.yml
    $ pendaxes --init config.yml # will write to config.yml

see https://github.com/cookpad/pendaxes/wiki/Configuration for detail.

#### Example

Clone `https://github.com/foo/bar.git` to `/path/to/be/cloned/repository`, then detect pendings using rspec detector (default).

Finally send notification to committers via email (from `no-reply@example.com`).

    workspace:
      path: /path/to/be/cloned/repository        # where to clone?
      repository: https://github.com/foo/bar.git # where clone from?
    notifications:
      - use: file
        to: "report.html"
        reporter:
          use: haml
      - use: mail
        from: no-reply@example.com
        delivery_method: sendmail
        reporter:
          use: haml

## Axes?

斧... Axe in Japanese. Recently, Japanese engineer says a review comment as axe (斧).

Throwing axe means "comment my opnion."

This script throws axe to committer, about his/her uncontrolled pending tests.

### See Also

椅子を投げる (Throwing chairs) is similarly:

<http://speakerdeck.com/u/riywo/p/ops-tool-made-by-perl-beginner?slide=11>

## Requirements

* Ruby 1.9+ (1.9.3 supported)
* git

we're using `git grep` and `git blame` to detect pendings, and supported test suite is currently `rspec` only.
this gem supports git managed repository, and using rspec.

Patches for other environment are welcomed. :-)

## Writing notificator and reporter

TBD

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


