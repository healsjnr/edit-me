@base_dir = "#{File.expand_path(File.dirname(__FILE__))}/.."

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3) 
working_directory @base_dir
timeout 30

pid File.join(@base_dir, 'pids/unicorn.pid')

stderr_path File.join(@base_dir, 'logs/unicorn.log')
stdout_path File.join(@base_dir, 'logs/unicorn.log')

runon = "#{@base_dir}/tmp/sockets/unicorn.sock"
runon = 8080 if ENV['RACK_ENV'] == 'development'

puts "Running #{ENV['RACK_ENV']} on #{runon}"

listen runon, :backlog => 64
