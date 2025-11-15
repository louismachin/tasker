require 'sinatra'

require_relative './models/environment'

APP_ROOT = File.expand_path(__dir__)

configure do
    set :bind, '0.0.0.0'
    set :port, $env.port
    set :public_folder, File.expand_path('public', __dir__)
    set :environment, :production
    disable :protection
end

require_relative './models/project'
require_relative './models/task'
require_relative './models/time_span'

require_relative './helpers/simple_web'
require_relative './helpers/time'
require_relative './helpers/projects'

require_relative './routes/session'
require_relative './routes/tasks'
require_relative './routes/index'