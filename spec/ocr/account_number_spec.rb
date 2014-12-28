
require 'spec_helper'

require 'ocr'

describe Ocr::AccountNumber do

  context "invalid number" do
    it "throws an argument error if input string does not have four lines" do
      data = "1\n2\n3"
      expect {Ocr::AccountNumber.new data}.to raise_error
    end

    it "throws an argument error if each line does not have 27 characters" do
      data = "1\n2\n3\n4"
      expect {Ocr::AccountNumber.new data}.to raise_error
    end

    it "throws an argument error if lines 1-3 contain any characters except pipes or underscores" do
      data = fixture('ocr/invalid_account_number_13.txt')
      expect {Ocr::AccountNumber.new data}.to raise_error
    end

    it "throws an argument error if line 4 is not blank" do
      data = fixture('ocr/invalid_account_number_4.txt')
      expect {Ocr::AccountNumber.new data}.to raise_error
    end
  end
end
