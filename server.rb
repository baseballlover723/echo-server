require 'rubygems'
require 'bundler/setup'
require 'rack'

class Server
  def startup
    puts 'starting the server'
    app = Proc.new do |env|
      ['200', {'Content-Type' => 'text/html'}, ["App has started. The time is #{Time.now.strftime("%I:%M:%S %p")}"]]
    end

    Rack::Handler::WEBrick.run app, {Host: '0.0.0.0', Daemonize: true}

    # TODO create TCP and UDP echo servers and start them
  end
end

Server.new.startup
