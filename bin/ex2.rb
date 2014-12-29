
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ocr'

sample_data =
''' _                         
  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |
                           
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|
                           
    _  _  _  _  _  _     _ 
|_||_|| ||_||_   |  |  ||_ 
  | _||_||_||_|  |  |  | _|
                           
 _  _  _  _  _  _  _  _  _ 
|_||_||_||_||_||_||_||_||_|
|_||_||_||_||_||_||_||_||_|
                           
    _  _  _  _  _  _     _ 
|_||_|| || ||_   |  |  ||_ 
  | _||_||_||_|  |  |  | _|
                           
 _     _  _     _  _  _  _ 
| |  | _| _||_||_ |_   ||_|
|_|  ||_  _|  | _||_|  ||_|
                           
'''

data = ''

if ARGV.count > 0
  data = File.read(ARGV.first)
else
  data = sample_data
end

accounts = []
data.split(/\n/).each_slice(4) do |lines|
  accounts << Ocr::AccountNumber.new(lines.join("\n"))
end

accounts.each do |account|
  puts account
  puts account.valid?
end
