require 'rack'
require 'json'

app = Proc.new do |env|
  ['200', {'Content-Type' => 'application/json'}, [{ status: "ok" }.to_json]]
end

run app
