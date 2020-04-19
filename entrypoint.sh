#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ ! -f "$(npm bin)/xo" ]; then
  if [ -f "package-lock.json" ]; then
    npm ci
  else
    npm install
  fi
fi

$(npm bin)/xo --version

if [ "${INPUT_REPORTER}" == 'github-pr-review' ]; then
  # Use jq and github-pr-review reporter to format result to include link to rule page.
  $(npm bin)/xo --reporter json ${INPUT_XO_FLAGS:-'.'} \
    | jq -r '.[] | {filePath: .filePath, messages: .messages[]} | "\(.filePath):\(.messages.line):\(.messages.column):\(.messages.message) [\(.messages.ruleId)](https://eslint.org/docs/rules/\(.messages.ruleId))"' \
    | reviewdog -efm="%f:%l:%c:%m" -name="xo" -reporter=github-pr-review -level="${INPUT_LEVEL}"
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  $(npm bin)/xo --reporter stylish ${INPUT_XO_FLAGS:-'.'} \
    | reviewdog -f="eslint" -name="xo" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}"
fi