thumbsup
--------

[![Build Status](https://travis-ci.org/ags/thumbsup.svg)](https://travis-ci.org/ags/thumbsup)

A GitHub commit status intended to assist with code review of pull requests.

When a pull request is created or updated, a pending commit status will be
created. A successful status can be achieved by leaving a comment containing
:+1: or :shipit: on the pull request.

#### Running

Currently depends on an access token being provided via the
`GITHUB_ACCESS_TOKEN` environment variable. This access token should provide
the `repo` type access.

`foreman start` will start the application.
