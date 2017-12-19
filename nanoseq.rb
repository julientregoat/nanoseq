gem 'wavefile', '=0.8.1'
require 'wavefile'
require 'pry'
require_relative 'nanosynth'

class Note
  attr_accessor :id, :wave_type, :frequency, :amplitude, :length

  @@all = []

  def initialize (id, wave_type, frequency, amplitude, length)
    @id = id
    @wave_type = wave_type.downcase
    @frequency = frequency
    @amplitude = amplitude
    @length = length
    @@all << self
  end

  def self.all
    @@all
  end

  def self.all_ids
    self.all.each do |note|
      puts note.id + " " + note.wave_type + " " + note.frequency + " " + note.amplitude + " " + note.length
    end
  end

  def self.find_note_by_id(note_id)
    self.all.find{|note| note.id == note_id}
  end

  def self.delete_note_by_id(note_id)
    self.all.delete_if do |note|
      note.id == note_id
    end
  end

  def edit(param, value)
    if param == "wave_type"
      @wave_type = value
    elsif param == "frequency"
      @frequency == value
    elsif param == "amplitude"
      @amplitude = value
    elsif param == "length"
      @length = value
    elsif param == "id"
      @id = value
    else
      "Not a valid parameter. Please choose from: id, wave type, frequency, amplitude, or value."
      self.edit
    end
  end
end


class Sequence
  attr_accessor :name, :buffer, :output_filename, :sequence

  SEQUENCE_LOG = ["START SEQUENCE LOG:"]
  OUTPUT_FILENAME = "My_Song.wav"

  @@all = []

  def initialize(name)
    @name = name.downcase
    @sequence = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.all_names
    self.all.each do |sequence|
      puts sequence.name
    end
  end

  def self.sequence_switch(name)
    self.all.find do |sequence|
      sequence.name == name
    end
  end

  def all_notes
    @sequence.each_with_index do |note, idx|
      puts "index" + idx.to_s + " " + note.id + " " + note.wave_type + " " + note.frequency + " " + note.amplitude + " " + note.length
    end
  end

  def add_note_by_id(note_id)
    @sequence << Note.find_note_by_id(note_id)
  end

  def delete_note_by_index(index)
    @sequence.delete_if.with_index do |note, idx|
      binding.pry
      idx == index
    end
  end

  def delete_last_note
    @sequence.delete_at(-1)
  end

  def generate_sequence_buffer
    sequence_buffer = []
    @sequence.each do |note|
      note_hash = {}
      note_hash[:wave_type] = note.wave_type
      note_hash[:frequency] = note.frequency
      note_hash[:max_amplitude] = note.amplitude
      note_hash[:length] =  note.length
      if sequence_buffer.class == Array
        sequence_buffer = buffergen(note_hash)
      else
        sequence_buffer.samples << buffergen(note_hash).samples
        sequence_buffer.samples.flatten!
      end
      SEQUENCE_LOG.push(" #{note.id} #{note.wave_type} #{note.frequency} #{note.amplitude} #{note.length}")
    end
    @buffer = sequence_buffer
  end

  def write_audio
    WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_24, SAMPLE_RATE)) do |writer|
      writer.write(@buffer)
    end
  end

  def write_sequence_log
    File.new("My_Song_Sequences.txt", "a+")
    File.open("My_Song_Sequences.txt", "a") do |line|
      line.puts SEQUENCE_LOG.join
    end
  end
  # def read_sequence_file
  #   puts "Please ensure your .txt file is in the same directory as Nanoseq."
  #   puts "Type the full file name of the sequence you want to read from."
  #
  #   File.open(STDIN.gets.chomp) do |line.|
end

# puts "Please enter your sequence. [Wave Type] [Frequency] [Max Amplitude] [Length]"
# sequence_input = STDIN.gets.chomp.split(" ")
#
# if !(sequence_input.size%4 == 0)
#   puts "Please make sure you have the right number of arguments per note and run again."
#   puts "[Wave Type] [Frequency] [Max Amplitude] [Length]"
#   abort
# end
