
module Ocr
  class AccountNumber

    def initialize(number_string)
      raise ArgumentError, 'Input is not a string' unless number_string.respond_to?(:to_s)
      lines = number_string.split(/\n/)
      raise ArgumentError, 'Input does not have four lines' unless lines.count == 4
      lines.each do |line|
        raise ArgumentError, 'Line does not have 27 characters' unless line.length == 27
      end
      lines[0..2].each do |line|
        raise ArgumentError, 'Line contains invalid character' if line =~ /[^\s|_]/
      end
      raise ArgumentError, 'Line four is not blank' if lines[3] =~ /\S/
    end
  end
end
