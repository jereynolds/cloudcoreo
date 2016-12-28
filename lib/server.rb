class Server < Sinatra::Base
  get '/' do
    erb :home
  end
end
