# GitHub Action: Run xo with reviewdog

This action runs [xo](https://github.com/xojs/xo) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].
Default is github-pr-check.
It's same as `-reporter` flag of reviewdog.

github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `xo_flags`

Optional. Flags and args of xo command. Default: '.'

## Example usage

You also need to install [xo](https://github.com/xojs/xo).

```shell
# Example
$ npm install xo -D
```

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: lint
on: [pull_request]
jobs:
  xo:
    name: runner / xo
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: xo
        uses: omsmith/actions-reviewdog-xo@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review # Change reporter.
          xo_flags: 'src/'
```