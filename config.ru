require 'rack'
 
app = Proc.new do |env|
    ['200', {'Content-Type' => 'text/html'}, ['Hello World!']]
end
 
run app