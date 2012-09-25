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

(writing in cron is recommended)

### Configuration

#### Minimal

Clone `https://github.com/foo/bar.git` to `/path/to/be/cloned/repository`, then detect pendings using rspec detector (default).

Finally send notification to committers via email (from `no-reply@example.com`).

    workspace:
      path: /path/to/be/cloned/repository        # where to clone?
      repository: https://github.com/foo/bar.git # where clone from?
    report:
      use: haml
      to: "report.html"
    notifications:
      - use: mail
        from: no-reply@example.com
        reporter:
          use: haml


#### Full

    detection:
      use: rspec           # use rspec detector for pending detection. (default)
    # pattern: '*_spec.rb' # this will be passed after `git grep ... --`. Default is "*_spec.rb".
    # allowed_for: 604800  # (second) = 1 week. Pendings will be marked "not allowed" if it elapsed more than this value

    workspace:
      path: /path/to/be/cloned/repository            # where to clone?
      repository: "https://github.com/user/repo.git" # where clone from?

    report: # report configuration to save
      use: haml              # what reporter to use (haml and text is bundled in the gem)
      to: "report.html"      # where to save?
      include_allowed: true  # include "allowed" pendings in report. (default: true)
      # VVV haml reporter specific configuration VVV
      commit_url: "https://github.com/user/repo/commit/%commit%"        # Used for link to commit. %commit% will be replaced to sha1. If not specified, will not be a link.
      file_url: "https://github.com/user/repo/blob/HEAD/%file%#L%line%" # Used for link to file. %file% and %line% will be replaced to filepath and line no. If not specified, will not be a link.

    notifications: # notifications. multiple values are accepted.
      - use: terminal # use terminal notificator.
      - use: mail # use mail notificator.
        reporter: # reporter setting for this (mail) notification
          use: haml
          commit_url: "https://github.com/user/repo/commit/%commit%"
          file_url: "https://github.com/user/repo/blob/HEAD/%file%#L%line%"

        # VVV mail notificator specific configuration VVV
        from: no-reply@example.com
        to: foo@example.com # (optional) mail will be sent once to this mail address.
                            # without this, mail will be sent separated for each committer.
                            # (mails will include pendings added by its recipient only.)

        delivery_method: sendmail # specify delivery_method. https://github.com/mikel/mail for more detail.
        delivery_options:         # (optional) used as option for delivery_method.
          :location: /usr/sbin/sendmail

        whitelist:          # (optional) if whitelist set, mail won't be sent if not matched.
          - foo@bar         #   complete match.
          - /example\.com$/ #   used as regexp.
        blacklist:          # (optional) mail won't be sent if matched. preferred than whitelist.
          - black@example.com
          - /^black/

        alias:              # (optional) Aliasing emails. if mail will be sent to <value> if git commit author is <key>.
          "foo@gmail.com": "foo@company.com"


* Reporter: generates text or html by given pendings
* Notificator: get text or html by reporter, and notify it (via mail, to terminal, etc...)

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


