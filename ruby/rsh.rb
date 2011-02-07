#!/usr/bin/env ruby
require 'readline'

# echo (Dir['*'] - Dir['*.rb'])

# Store the state of the terminal
stty_save = `stty -g`.chomp

class Cmd < Object
  def method_missing msg, *args, &block
    ::Kernel.send(:`, "#{msg} #{args.join(' ')}")
  end
end

def translate line
  nested = /(\([^\(\)]*\))/
  if line =~ nested
    translate(line.sub(nested, eval($1).to_s))
  else
    line
  end
end

def read
  line = Readline.readline('> ', true)
  return nil if line.nil?
  if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
    Readline::HISTORY.pop
  end
  line
end

Readline.completion_append_character = " "
Readline.completion_proc = Readline::FILENAME_COMPLETION_PROC
Readline.basic_word_break_characters = ''
# Readline.completion_proc = Proc.new {|l| p l }
# p Readline.methods - Object.methods

begin
  while line = read
    if line =~ /^(?<p>[^\(\)]*(\(\g<p>*\))*)*$/
      system translate(line).gsub("\n", ' ')
    else
      puts 'Unbalanced parentheses.'
    end
  end
rescue Interrupt => e
  system('stty', stty_save) # Restore
  exit
end
