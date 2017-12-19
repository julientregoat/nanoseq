gem 'wavefile', '=0.8.1'
require 'wavefile'
require 'pry'
require_relative 'nanosynth'
require_relative 'nanoseq'
require_relative 'interface.rb'

welcome
program_loop
goodbye
