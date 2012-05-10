require 'celluloid/io'

class EchoServer
  include Celluloid::IO
  
  def initialize(host,port)
    puts "*** Starting echo server #{host}:#{port}"
    @server = TCPServer.new(host,port)
    run!
  end
  
  def finalize
    @server.close if @server
  end
  
  def run
    loop{ handle_connection! @server.accept }
  end
  
  def handle_connection(socket)
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"
    loop{ socket.write socket.readpartial(4096) }
  rescue
    puts "*** #{host}:#{port} disconnected"
  end
end