require 'csv'
require 'json'
require 'matrix'
require 'set'
require 'thread'

require 'sinatra'

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].sort!.each { |f| require_relative f }
