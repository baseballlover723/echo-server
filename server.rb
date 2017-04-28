require 'rubygems'
require 'bundler/setup'
require 'socket'
require 'rack'

class Server
  def startup
    puts 'starting the server'
    app = Proc.new do |env|
      ['200', {'Content-Type' => 'text/html'}, ["App has started. The time is #{Time.now.strftime('%I:%M:%S %p')}"]]
    end

    # TODO create a UDP echo server and start it
    TCPEcho.new(3030).start

    Rack::Handler::WEBrick.run app, {Host: '0.0.0.0', Daemonize: true}
  end
end


class TCPEcho
  def initialize(port)
    @server = TCPServer.new('0.0.0.0', port)
  end

  def start
    while (connection = @server.accept)
      Thread.new(connection) do |conn|
        begin
          loop do
            conn.write(conn.recv(1048))
          end
        rescue
          conn.close
        end
      end
    end
  end
end

Server.new.startup
