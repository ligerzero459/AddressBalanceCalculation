require 'sqlite3'
require 'sequel'
require 'json'

db = Sequel.sqlite('XPYBlockchain.sqlite')

require './models/block'
require './models/transaction'
require './models/input'
require './models/output'

address = ''

balance = 0.0
balance += Output.where(:address => address).sum(:value)
balance -= Input.where(:address => address).sum(:value)

puts address << ' balance: ' << balance.to_s
