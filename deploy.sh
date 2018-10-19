export MIX_ENV=prod
export PORT=4794

cd /home/tasks/task_tracker

_build/prod/rel/task_tracker/bin/task_tracker stop 

mix deps.get
cd assets
npm install
cd ..
mix ecto.create
mix ecto.migrate

cd assets
node_modules/.bin/webpack --mode production
cd ..
mix phx.digest
mix compile
mix release --env=prod

_build/prod/rel/task_tracker/bin/task_tracker start
