require 'pry'
require 'rspec/rails/mocks'
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'ace_of_spades'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :host     => "localhost",
  :database => "aces"
)

begin
  ActiveRecord::Schema.drop_table('jokers')
  ActiveRecord::Schema.drop_table('pokers')
rescue
  nil
end

ActiveRecord::Schema.define do
  create_table :jokers do |t|
    t.string   :name
    t.string   :occupation
  end
  create_table :pokers do |t|
    t.string   :suit
    t.string   :rank
  end
end
