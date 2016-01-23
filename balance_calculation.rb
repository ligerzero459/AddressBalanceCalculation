require 'mysql2'
require 'sequel'
require 'json'

db = Sequel.connect(
    :adapter=>'mysql2',
    :database=>'XPYBlockchain',
    :host=>'localhost',
    :user=>'paycoindb',
    :password=>'paycoin'
)
db.sql_log_level = :debug


require './models/input'
require './models/output'

addresses = []

outputs = Output.select_group(:address).select_append{sum(:value).as(balance)}
outputs.each do |output|
  if output.address == nil || output.address == ""
    next
  end
  temp = OpenStruct.new
  temp.address = output.address
  out_bal = Output.where(:address=>temp.address).sum(:value)
  in_bal = Input.where(:address=>temp.address).sum(:value)
  if in_bal != nil
    bal = out_bal.round(6) - in_bal.round(6)
  else
    bal = out_bal.round(6)
  end
  temp.balance = bal.round(6)
  addresses.push(temp)
end

puts addresses
