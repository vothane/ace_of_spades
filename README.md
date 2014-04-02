[![Code Climate](https://codeclimate.com/github/vothane/ace_of_spades.png)](https://codeclimate.com/github/vothane/ace_of_spades)

## ace_of_spades

client library for aceshigh search engine. Will have an interface and functionality very similar to sunspot.
Works on any implementation of ruby.

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
 
## Tests

to run tests, you should have a aceshigh search server


```
git clone https://github.com/vothane/aceshigh.git
```

go into aceshigh dir and in a terminal with JRuby active, run:


```
jruby aceshigh_server.rb druby://localhost:12345 
```

should get output of

```
druby://localhost:12345
```

search server is now running at port 12345

in another terminal with either Ruby MRI or JRuby active go to ace_of_spades dir

```
rspec spec 
```

## Usage

### Setting Up ActiveRecord attributes to be searchable

Add a `searchable` block to the objects you wish to index.

```ruby
class Poker < ActiveRecord::Base
  ace_of_spades({:server_address => 'druby://localhost:12345'})

  searchable do
    searchable_fields :suit, :rank, :value, :description
  end
end
```

Poker model attributes `:suit, :rank, :value, :description` will now be indexed and stored in aceshigh with their respective type.

### Searching Objects

```ruby
card1 = Poker.create(suit: "Hearts",   rank: "King",  value: 13, description: CARD_MAP[:hearts_king])
card2 = Poker.create(suit: "Spades",   rank: "Ace",   value: 14, description: CARD_MAP[:spades_ace])
card3 = Poker.create(suit: "Diamonds", rank: "Jack",  value: 11, description: CARD_MAP[:diamonds_jack])
card4 = Poker.create(suit: "Spades",   rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
card5 = Poker.create(suit: "Clubs",    rank: "Queen", value: 12, description: CARD_MAP[:clubs_queen])

result1 = Poker.search(rank: "Ace") # => {:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]}
result2 = Poker.search(value: 14)   # => {:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
