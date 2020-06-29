this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'hello_world_services_pb'

def main
  stub = HelloWorld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  user = ARGV.size > 0 ?  ARGV[0] : 'world'
  message = stub.say_hello(HelloWorld::HelloRequest.new(name: user)).message
  p "Greeting: #{message}"
  messages = stub.say_hello_stream(HelloWorld::HelloStreamRequest.new(name: user, num_greetings: "3"))
  messages.each do |message|
    p "Many Greetings: #{message.message}"
  end

  hello_request_array = []
  hello_request_array << HelloWorld::HelloRequest.new(name: "Liya")
  hello_request_array << HelloWorld::HelloRequest.new(name: "Thankam")
  message = stub.say_hello_together(hello_request_array)
  p message.message
end

main