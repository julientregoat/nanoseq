 def welcome
  puts "Welcome to nanoseq. To enter sequencer mode, type sequence. To enter note mode, type note. To exit, type exit."
end

def goodbye
  puts "Goodbye!"
end

def continue_running?
  puts "To enter sequencer mode, type sequence. To enter note mode, type note. To exit, type exit."
end

def sequence_mode?
  puts "Sequencer mode."
  puts "Type 'new' to create a new sequence."
  puts "Type 'all' to view all sequences."
  puts "Type 'delete' to delete a note by index."
  puts "Type 'add note' to add a note by its ID to the current sequence."
  puts "Type 'current' to view current sequence."
  puts "Type 'change' to change the sequence you're working on."
  puts "Type 'save' to save the current sequence to a text file and export audio."
  puts "Type 'load' to load a new sequence from a text file."
end

def add_note_which_id?
  puts "Please enter the note ID you wish to add to your current sequence."
end

def save_warning
  puts "Please note, if you have a file with the same name, it will be overwritten."
end

def note_mode?
  puts "Note mode."
  puts "Type 'new' to create a new note."
  puts "Type 'all' to view all created notes."
  puts "Type 'edit' to edit a note."
  puts "Type 'delete' to delete a note by ID."
end

def new_note
  puts "New note. Please enter the following on one line:"
  puts "ID - Enter any unique alphanumeric string to identify your note."
  puts "Wave Type - Choose from sine, saw, triangle, or square."
  puts "Frequency - A number, in hz."
  puts "Amplitude - How loud this note should be. From 0 - 1."
  puts "Length - How long this note should be. Accepts floats."
end

def program_loop
  response = gets.chomp.downcase
  while response != "exit"
    if response == "sequence"
      sequence_mode?
      response = gets.chomp.downcase
      if response == "new"
        puts "Please type the name of your sequence."
        new_sequence_name = gets.chomp.downcase
        puts current_sequence = Sequence.new(new_sequence_name) #working
      elsif response == "all"
        if Sequence.all.length == 0
          puts "No sequences."
        else
          puts Sequence.all_names
        end
      elsif response == "current"
        if current_sequence.class == NilClass
          puts "No current sequence. Try again."
        else
          puts "Current sequence: " + current_sequence.name
          current_sequence.all_notes
        end
      elsif response == "add note"
        if current_sequence.class == NilClass
          puts "No current sequence. Try again."
        else
          add_note_which_id?
          response = gets.chomp.downcase
          current_sequence.add_note_by_id(response)
        end
      elsif response == "delete"
        puts "Enter the index of the note you'd like to delete."
        current_sequence.all_notes
        response = gets.chomp.to_i
        current_sequence.delete_note_by_index(response)
      elsif response == "change"
        puts "Type the name of the sequence you'd like to change to."
        response = gets.chomp.downcase
        change_sequence = nil
        while change_sequence == nil
          change_sequence = Sequence.sequence_switch(response)
          if change_sequence == nil
            puts "Sequence not found. Try again, or type 'exit'."
            response = gets.chomp.downcase
          end
          break if response == "exit"
        end
        current_sequence = change_sequence
        puts current_sequence
      elsif response == "save"
        save_warning
        current_sequence.generate_sequence_buffer
        current_sequence.write_audio
        current_sequence.write_note_log
      elsif response == "load"
        puts "Type a name for your new sequence."
        response = gets.chomp
        Sequence.new(response).read_sequence_file
      else
        puts "Invalid entry or no current sequence. Please create a new sequence."
      end
    elsif response == "note"
      note_mode?
      response = gets.chomp.downcase
      response
      if response == "new"
        new_note
        response = gets.chomp.downcase
        response = response.split
        if response.size != 5
          puts "Incorrect amount of arguments. Try again."
        else
          Note.new(response[0], response[1], response[2], response[3], response[4])
        end
      elsif response == "all"
        if Note.all.length == 0
          puts "No notes."
        else
          puts Note.all_ids
        end
      elsif response == "delete"
        puts "Enter the ID of the note you'd like to delete."
        response = gets.chomp
        Note.delete_note_by_id(response)
        Note.all_ids
      elsif response == "edit"
        puts "Please enter the ID, paramter, and value you'd like to update."
        puts "Parameter can be 'wave_type', 'frequency', 'amplitude', 'length', or 'id'."
        response = gets.chomp.split
        Note.find_note_by_id(response[0]).edit(response[1], response[2])
      end
    else
      puts "Not a valid entry. Please try again."
    end
    continue_running?
    response = gets.chomp.downcase
  end
end
