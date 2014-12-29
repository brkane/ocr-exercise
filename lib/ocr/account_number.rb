
module Ocr
  class AccountNumber

    module DigitLookup
      ROW1 = {
        '   ' => [ 1, 4 ],
        ' _ ' => [ 0, 2, 3, 5, 6, 7, 8, 9 ]
      }
      ROW2 = {
        '  |' => [ 1, 7 ],
        ' _|' => [ 2, 3 ],
        '|_|' => [ 4, 8, 9 ],
        '|_ ' => [ 5, 6 ],
        '| |' => [ 0 ]
      }
      ROW3 = {
        '  |' => [ 1, 4, 7 ],
        '|_ ' => [ 2 ],
        ' _|' => [ 3, 5, 9 ],
        '|_|' => [ 0, 6, 8 ]
      }
    end

    def initialize(number_string)

      lines = validate_string number_string
      @invalid_characters = false

      row1_matches = []
      row2_matches = []
      row3_matches = []
      lines[0].scan(/.{3}/).each do |slice|
        row1_matches << lookup_digit(slice, DigitLookup::ROW1)
      end
      lines[1].scan(/.{3}/).each do |slice|
        row2_matches << lookup_digit(slice, DigitLookup::ROW2)
      end
      lines[2].scan(/.{3}/).each do |slice|
        row3_matches << lookup_digit(slice, DigitLookup::ROW3)
      end
      possible_matches = row1_matches.zip(row2_matches, row3_matches)
      possible_matches.each {|e| e.flatten! }

      @number = possible_matches.map do |matches|
        match = -1
        (0..9).each do |digit|
          if matches.grep(digit).count == 3
            match = digit
            break
          end
        end
        if match == -1
          match = '?'
          @invalid_characters = true
        end
        match.to_s
      end.join
    end

    def to_s
      if @invalid_characters
        @number.to_s + " ILL"
      elsif valid_checksum?
        @number.to_s
      else
        @number.to_s + " ERR"
      end
    end

    def valid?
      valid_checksum? && !@invalid_characters
    end

    def valid_checksum?
      checksum = 0
      @number.chars.reverse.each_with_index do |char, i|
        checksum += char.to_i * (i + 1)
      end
      checksum % 11 == 0
    end

    private

    def lookup_digit(string, table)
      table.fetch(string, [])
    end

    def validate_string(string)
      raise ArgumentError, 'Input is not a string' unless string.respond_to?(:to_s)
      lines = string.split(/\n/)
      raise ArgumentError, 'Input does not have four lines' unless lines.count == 4
      lines.each do |line|
        raise ArgumentError, 'Line does not have 27 characters' unless line.length == 27
      end
      lines[0..2].each do |line|
        raise ArgumentError, 'Line contains invalid character' if line =~ /[^\s|_]/
      end
      raise ArgumentError, 'Line four is not blank' if lines[3] =~ /\S/
      lines
    end
  end
end
