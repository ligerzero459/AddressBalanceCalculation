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

require './models/transaction'
require './models/raw_transaction'
require './models/output'

outputs = Output.where(:address => '', :type => 'scripthash')

outputs.each do |o|
  transaction = Transaction.where(:id => o.transaction_id).all
  transaction.each do |tx|
    raw_transaction = RawTransaction.where(:txid => tx.txid)
    raw_transaction.each do |rtx|

    end
  end
end
