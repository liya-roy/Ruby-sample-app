this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'hello_world_services_pb'

class GreeterServer < HelloWorld::Greeter::Service
  def say_hello(hello_req, _unused_call)
    HelloWorld::HelloReply.new(message: "Hello #{hello_req.name}")
  end

  def say_hello_stream(hello_req, _unused_call)
    request_count = hello_req.num_greetings.to_i
    greeter_array = []
    request_count.times {
      greeter_array << HelloWorld::HelloReply.new(message: "Hello #{hello_req.name}")
    }
    greeter_array
  end

  def say_hello_together(hello_request)
    names_array = []
    hello_request.each do |req|
      names_array << req.name
    end
    message = "Hello " + names_array.join(',')
    HelloWorld::HelloReply.new(message: message)
  end
end

# main starts an RpcServer that receives requests to GreeterServer at the sample
# server port.
def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(GreeterServer)
  # Runs the server with SIGHUP, SIGINT and SIGQUIT signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
end

main
