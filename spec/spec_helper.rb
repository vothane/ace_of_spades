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
    t.string   :suit
    t.string   :rank
    t.integer  :value
    t.text     :description
  end

  create_table :pokers do |t|
    t.string   :suit
    t.string   :rank
    t.integer  :value
    t.text     :description
  end

end

CARD_MAP = {
  hearts_king: "The King of Hearts is the only King with no mustache, and is also typically shown with a sword behind his head, making him appear to be stabbing himself.",
  spades_ace: "The Ace of Spades, unique in its large, ornate spade, is sometimes said to be the death card, and in some games is used as a trump card.",
  diamonds_jack: "The Jack of Diamonds is sometimes known as 'laughing boy'.",
  spades_queen: "The Queen of Spades usually holds a scepter and is sometimes known as 'the bedpost Queen', though more often she is called 'Black Lady'.",
  clubs_queen: "In many decks, the Queen of Clubs holds a flower. She is thus known as the 'flower Queen'."
}
