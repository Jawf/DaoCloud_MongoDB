require 'sinatra'
require 'mongo'

module Sinatra
  class Base
    set :server, %w[thin mongrel webrick]
    set :bind, '0.0.0.0'
    set :port, 8080
  end
end

host = ENV['MONGODB_PORT_27017_TCP_ADDR'] || 'localhost'
port = ENV['MONGODB_PORT_27017_TCP_PORT'] || 27017
database = ENV['MONGODB_INSTANCE_NAME'] || 'demo'
username = ENV['MONGODB_USERNAME'] || 'aong'
password = ENV['MONGODB_PASSWORD'] || '1234'

hostport=host+':'+port.to_s


$db = Mongo::Client.new([hostport],
                        :database => database,
                        :user => username,
                        :password => password)

get '/' do
  body "welcome,this is a info about MongoDB:
  host:#{ENV['MONGODB_PORT_27017_TCP_ADDR']}
  username:#{ENV['MONGODB_USERNAME']}
  password:#{ENV['MONGODB_PASSWORD']}
  port:#{ENV['MONGODB_PORT_27017_TCP_PORT']}
  database:#{ENV['MONGODB_INSTANCE_NAME']}"

end

get '/get/:name' do
  res = $db[:artists].insert_one({ name: params['name'] })
  redirect to('/get')
end

get '/get' do
  result = $db[:artists].find()
  s=[]
  result.each do |a|
    s.push a['name']
  end
  body "#{s}"
end
