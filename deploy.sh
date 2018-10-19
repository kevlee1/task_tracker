#!/bin/bash

export MIX_ENV=prod
export PORT=4794
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mkdir -p ~/.config

mix deps.get # get the out of date dependencies
mix compile # compile source
(cd assets && npm install) # install the npm dependencies
(cd assets && webpack --mode production) # set webpack mode to production
mix phx.digest # compress static files

echo "Generating release..."
mix release --env=prod # generate the release

echo "Starting app..."

_build/prod/rel/task_tracker/bin/task_tracker foreground # start app in the foreground
