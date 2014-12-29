
require 'spec_helper'

require 'ocr'

describe Ocr::AccountNumber do

  context "invalid input" do
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

  context "invalid checksum" do
    let(:data) { fixture('ocr/invalid_account_number_chksum.txt') }
    subject(:account) { Ocr::AccountNumber.new data }

    it "does not pass a checksum verification" do
      expect(account.valid?).to be false
    end

    it "outputs invalid checksum flag" do
      expect(account.to_s).to eq('888888888 ERR')
    end
  end

  context "illegal characters" do

    it "outputs illegal character flag" do
      data = fixture('ocr/invalid_account_number_illegal.txt')
      account = Ocr::AccountNumber.new data
      expect(account.to_s).to eq('1234?678? ILL')
    end
  end

  context "valid number" do
    it "outputs the number in string form" do
      data = fixture('ocr/valid_account_number.txt')
      account = Ocr::AccountNumber.new data
      expect(account.to_s).to eq('000000000')
    end
  end
end
