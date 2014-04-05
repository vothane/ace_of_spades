[![Code Climate](https://codeclimate.com/github/vothane/ace_of_spades.png)](https://codeclimate.com/github/vothane/ace_of_spades)

## Aces High, The Ace of Spades

>If you like to gamble, I tell you I'm your man  
>You win some, lose some, it's - all - the same to me  
>The pleasure is to play, it makes no difference what you say  
>I don't share your greed, the only card I need is  
>The Ace of Spades  

>Playing for the high one, dancing with the devil,  
>Going with the flow, it's all a game to me,  
>Seven or Eleven, snake eyes watching you,  
>Double up or quit, double stakes or split,  
>Aces High  
>The Ace of Spades  

>You know I'm born to lose, and gambling's for fools,  
>But that's the way I like it baby,  
>I don't wanna live forever,  
>And don't forget the joker!  

>Pushing up the ante, I know you've got to see me,  
>Read 'em and weep, the dead man's hand again,  
>I see it in your eyes, take one look and die,  
>The only thing you see, you know it's gonna be,  
>Aces High  
>The Ace of Spades  

## ace_of_spades

client library for aceshigh search engine. Will have an interface and functionality very similar to sunspot.
Works on any implementation of ruby.
 
## Tests

to run tests, you should have a aceshigh search server


```
git clone https://github.com/vothane/aceshigh.git
```

go into `aceshigh` dir and in a terminal with **jruby** the active ruby, run:


```
jruby aceshigh_server.rb druby://localhost:12345 
```

should get output of

```
druby://localhost:12345
```

search server is now running at `port 12345`

in **another** **terminal** with either **ruby** MRI or **jruby** active go to the `ace_of_spades` dir

```
rspec spec 
```

**Caveat** after running tests, you must restart search server to clear the index to rerun tests

## Usage

### Setting Up ActiveRecord attributes to be searchable

Add a `searchable` block listing attrs you wish to index. List the AR attributes you wish to make 
searchable and indexed follwing **searchable_fields** method, ex. `searchable_fields :a, :b, :c, :d`.
Poker AR instances attrs `:a, :b, :c, :d` will now be indexed and searchable when created.

### marking ActiveRecord attributes as indexable and searchable

```ruby
class Poker < ActiveRecord::Base
  ace_of_spades({:server_address => 'druby://localhost:12345'})

  searchable do
    searchable_fields :suit, :rank, :value, :description
  end
end
```

Poker model attributes `:suit, :rank, :value, :description` will now be marked searchable.

### indexing AciveRecord instance attributes to Lucene

```ruby
CARD_MAP = {
  hearts_king: "The King of Hearts is the only King with no mustache, and is also typically shown with a sword behind his head, making him appear to be stabbing himself.",
  spades_ace: "The Ace of Spades, unique in its large, ornate spade, is sometimes said to be the death card, and in some games is used as a trump card.",
  diamonds_jack: "The Jack of Diamonds is sometimes known as laughing boy.",
  spades_queen: "The Queen of Spades usually holds a scepter and is sometimes known as 'the bedpost Queen', though more often she is called 'Black Lady'.",
  clubs_queen: "In many decks, the Queen of Clubs holds a flower. She is thus known as the 'flower Queen'."
}

Poker.create(suit: "Hearts",   rank: "King",  value: 13, description: CARD_MAP[:hearts_king])
Poker.create(suit: "Spades",   rank: "Ace",   value: 14, description: CARD_MAP[:spades_ace])
Poker.create(suit: "Diamonds", rank: "Jack",  value: 11, description: CARD_MAP[:diamonds_jack])
Poker.create(suit: "Spades",   rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
Poker.create(suit: "Clubs",    rank: "Queen", value: 12, description: CARD_MAP[:clubs_queen])
```

### searching

```ruby
Poker.search("Ace") # => {:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]}
Poker.search("value:14") # => {:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
