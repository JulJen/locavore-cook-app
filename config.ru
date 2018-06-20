require './config/environment'

use Rack::Static, :urls => ['/css'], :root => 'public' # Rack fix allows seeing the css folder.
# if ActiveRecord::Migrator.needs_migration?
  # raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

use Rack::MethodOverride

use UsersController
use RecipesController
use IngredientsController

run ApplicationController
