#!/usr/bin/env bash
# PreToolUse(Bash) hook: forward host PHP invocations into the docker `php`
# service, mirroring the `dphp` alias / `dtest` function from ~/.zshrc.
#
# Handles:
#   php ...                        -> dphp php ...
#   VAR=val php ...                -> dphp env VAR=val php ...
#   bin/phpunit ...                -> dphp php bin/phpunit ...
#   XDEBUG_MODE=off bin/phpunit .. -> dphp env XDEBUG_MODE=off php bin/phpunit ..
#   composer ... / bin/composer .. -> dphp composer ...
#
# Env-var prefixes are converted to `env VAR=val ...` because `docker compose
# exec` does not interpret `VAR=val` assignments — it runs the first token as
# the program. This matches how `dtest` invokes phpunit.
#
# Only rewrites when docker-compose.dev.yml exists in the project dir (the
# file `dphp`/`dtest` reference). Otherwise the command is left untouched.
#
# Leaves alone: `dphp ...`, `cat x.php`, `grep php`, etc.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
cwd=$(printf '%s' "$input" | jq -r '.cwd // "."')

# No docker-compose.dev.yml here -> nothing to forward into docker.
[ -f "$cwd/docker-compose.dev.yml" ] || exit 0

# Strip leading whitespace.
rest="${cmd#"${cmd%%[![:space:]]*}"}"

# Peel off leading VAR=val assignments, collecting them for `env`.
envs=""
while [[ "$rest" =~ ^([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]+)[[:space:]]+(.*)$ ]]; do
  envs+="${BASH_REMATCH[1]} "
  rest="${BASH_REMATCH[2]}"
done

# The program is the first remaining token.
prog="${rest%%[[:space:]]*}"

case "$prog" in
  php)
    invocation="$rest" ;;                 # already `php ...`
  bin/phpunit|bin/console)
    invocation="php $rest" ;;             # php script -> run via `php`
  composer)
    invocation="$rest" ;;                 # already `composer ...`
  bin/composer)
    invocation="composer${rest#bin/composer}" ;;  # normalize to `composer ...`
  *)
    exit 0 ;;                             # not a PHP invocation, leave alone
esac

if [ -n "$envs" ]; then
  newcmd="dphp env ${envs}${invocation}"
else
  newcmd="dphp ${invocation}"
fi

# Desktop notification showing the rewrite
command -v notify-send >/dev/null 2>&1 && \
  notify-send -t 3000 -a "" -i "" "php-to-dphp" "$newcmd" >/dev/null 2>&1 &

jq -n --arg c "$newcmd" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "allow",
    updatedInput: { command: $c }
  }
}'
