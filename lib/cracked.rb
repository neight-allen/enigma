require_relative 'date_offset_calculator'

class Cracked
  attr_reader :message, :characters

  def initialize(message)
    @message = message
    @characters = (' '..'z').to_a
  end

  def simplify
    length = message.length
    e = d = nil
    case length % 4
    when 0
      e = message[-4..-1].chars
      d = "nd..".chars
    when 1
      e = message[-5..-2].chars
      d = "end.".chars
    when 2
      e = message[-6..-3].chars
      d = ".end".chars
    when 3
      e = message[-7..-4].chars
      d = "..en".chars
    end
    [e, d]
  end

  def message_indexes(char_array)
    char_array.map do |char|
      characters.index(char)
    end
  end

  def calculate_indexes_difference(index, subtracted_index)
    index.zip(subtracted_index).map { |d_e| d_e.inject(:-) }
  end

  def decrypt_message
    e, d = simplify
    encrypted_index = message_indexes(e)
    decrypted_index = message_indexes(d)
    rotations_array = calculate_indexes_difference(decrypted_index, encrypted_index)

    entire_message_index = message_indexes(message.chars)

    rotated_message = entire_message_index.zip(rotations_array.cycle).map do |index_rotation|
      index_rotation.inject(:+)
    end
    simplified_rotation = rotated_message.map do |index|
      index% characters.length
    end
    a = simplified_rotation.map do |index|
      characters[index]
    end
    a.join("")
  end

end
