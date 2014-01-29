# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake/dsl_definition'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'

# require 'metric_fu'
# MetricFu::Configuration.run do |config|
#     #define which metrics you want to use
#     #config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :rcov]
#     #config.graphs   = [:flog, :flay, :stats]
#
#     config.rcov[:test_files] = ['spec/**/*_spec.rb']
#     config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
# end

Roommate::Application.load_tasks
