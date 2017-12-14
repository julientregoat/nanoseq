gem 'wavefile', '=0.8.1'
require 'wavefile'
require 'pry'
require_relative 'nanosynth_seqmod'

#'main(params)' is how nanosynth calls itself
#e.g. main({ wave_type: ARGV[0], frequency: ARGV[1],
# max_amplitude: ARGV[2], output_filename: ARGV[3]})


#need to systematically generate a hash for every 4 inputs.
#use .length on the array, divide by 5
#if there's a remainder return argument error, else array of hashes

# it be more efficient to call writer.write here
# building buffers for each 'note'

#SEQUENCE_BUFFER is an array of hashes containing notes
SEQUENCE_BUFFER = []
SEQUENCE = ""
OUTPUT_FILENAME = "My_Song.wav"

if !(ARGV.size%4 == 0)
  puts "Please make sure you have the right number of arguments per note and run again."
  puts "[Wave Type] [Frequency] [Max Amplitude] [Length]"
  abort
end

#returning an array at the moment which writer cannot convert. merge samples

ARGV.each_slice(4) do |a, b, c, d|
  note_hash = {}
  note_hash[:wave_type] = a
  note_hash[:frequency] = b
  note_hash[:max_amplitude] = c
  note_hash[:length] =  d
  if SEQUENCE_BUFFER.class == Array
    SEQUENCE_BUFFER = buffer(note_hash)
  else
    SEQUENCE_BUFFER.samples << buffer(note_hash).samples #do I add to samples via pushing individual numbers or array and flatten?
    SEQUENCE_BUFFER.samples.flatten!
  end
  SEQUENCE = SEQUENCE + a + " " + b + " " + c + " " + d + " "
end

WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_24, SAMPLE_RATE)) do |writer|
  writer.write(SEQUENCE_BUFFER)
end


File.new("My_Song_Sequences.txt", "a+")
File.open("My_Song_Sequences.txt", "a") do |line|
  line.puts SEQUENCE
end
