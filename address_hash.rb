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
      txid: Transaction.where(:id=>output.transaction_id).get(:txid),
      address: output.address,
      value: output.value.round(6),
      type: 'output',
      n: output.n,
      balance: 0.0
  }
  transactions.push output_hash
end

inputs.each do |input|
  input_hash = {
      transaction_id: input.transaction_id,
      txid: Transaction.where(:id=>input.transaction_id).get(:txid),
      address: input.address,
      value: -input.value.round(6),
      type: 'input',
      n: input.vout,
      balance: 0.0
  }
  transactions.push input_hash
end

transactions.sort_by! { |hsh| [hsh[:transaction_id], hsh[:n]] }

transactions.each do |tx|
  balance += tx[:value].round(6)
  tx[:balance] = balance.round(6)
end

transactions.reverse!

puts transactions
