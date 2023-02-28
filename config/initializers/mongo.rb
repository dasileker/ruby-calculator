require 'mongo'

client = Mongo::Client.new('mongodb://localhost:27017/my_database')
$collection = client[:calculations]
