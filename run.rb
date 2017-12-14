gem 'wavefile', '=0.8.1'
require 'wavefile'
require 'pry'
require_relative 'nanosynth'
require_relative 'nanoseq'


write_audio(generate_sequence_buffer)
write_sequence_log
