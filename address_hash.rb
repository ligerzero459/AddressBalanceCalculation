require 'sqlite3'
require 'sequel'
require 'json'

db = Sequel.sqlite('XPYBlockchain.sqlite')

require './models/block'
require './models/transaction'
require './models/input'
require './models/output'

address = ''
transactions = []
balance = 0.0

outputs = Output.where(:address => address)
inputs = Input.where(:address => address)

outputs.each do |output|
  output_hash = {
      transaction_id: output.transaction_id,
      address: output.address,
      value: output.value,
      type: 'output',
      n: output.n,
      balance: 0.0
  }
  transactions.push output_hash
end

inputs.each do |input|
  input_hash = {
      transaction_id: input.transaction_id,
      address: input.address,
      value: -input.value,
      type: 'input',
      n: input.vout,
      balance: 0.0
  }
  transactions.push input_hash
end

transactions.sort_by! { |hsh| [hsh[:transaction_id], hsh[:n]] }

transactions.each do |tx|
  balance += tx[:value]
  tx[:balance] = balance
end

puts transactions
