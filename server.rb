require 'rubygems'
require 'bundler/setup'
require 'socket'
require 'rack'

class Server
  def startup
    puts 'starting the server'
    app = Proc.new do |env|
      ['200', {'Content-Type' => 'text/html'}, ["App has started. The time is #{Time.now.strftime("%I:%M:%S %p")}"]]
    end

    Thread.new{UDPEchoServer.new(3030).run}

    Rack::Handler::WEBrick.run app, {Host: '0.0.0.0', Daemonize: true}

    # TODO create TCP and UDP echo servers and start them
  end
end

class UDPEchoServer
  @socket

  def initialize(port)
    @socket = UDPSocket.new
    @socket.bind(nil, port)
  end

  def run
    while true
      text, sender = @socket.recvfrom(16)
      @socket.send(text, 0, sender[3], sender[1])
    end
  end
end

Server.new.startup
