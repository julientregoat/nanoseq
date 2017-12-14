gem 'wavefile', '=0.8.1'
require 'wavefile'
require 'pry'
require_relative 'nanosynth'

#need to systematically generate a hash for every 4 inputs.
#use .length on the array, divide by 5
#if there's a remainder return argument error, else array of hashes

# it be more efficient to call writer.write here
# building buffers for each 'note'

OUTPUT_FILENAME = "My_Song.wav"
SEQUENCE_LOG = ["START SEQUENCE_LOG:"]

def generate_sequence_buffer
  puts "Please enter your sequence. [Wave Type] [Frequency] [Max Amplitude] [Length]"
  sequence_input = STDIN.gets.chomp.split(" ")

  if !(sequence_input.size%4 == 0)
    puts "Please make sure you have the right number of arguments per note and run again."
    puts "[Wave Type] [Frequency] [Max Amplitude] [Length]"
    abort
  end

  sequence_buffer = []
  sequence_input.each_slice(4) do |a, b, c, d|
    note_hash = {}
    note_hash[:wave_type] = a
    note_hash[:frequency] = b
    note_hash[:max_amplitude] = c
    note_hash[:length] =  d
    if sequence_buffer.class == Array
      sequence_buffer = buffer(note_hash)
    else
      sequence_buffer.samples << buffer(note_hash).samples
      sequence_buffer.samples.flatten!
    end
    SEQUENCE_LOG.push("#{a} #{b} #{c} #{d}")
    binding.pry
  end
  sequence_buffer
end


def write_audio(sequence_buffer)
  WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_24, SAMPLE_RATE)) do |writer|
    writer.write(sequence_buffer)
  end
end

def write_sequence_log
  File.new("My_Song_Sequences.txt", "a+")
  File.open("My_Song_Sequences.txt", "a") do |line|
    line.puts SEQUENCE_LOG.join
  end
end
