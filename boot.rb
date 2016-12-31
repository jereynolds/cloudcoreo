Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort!.each {|f| require_relative f}

require 'sinatra'
