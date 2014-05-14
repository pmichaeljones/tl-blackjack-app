require 'rubygems'
require 'sinatra'

set :sessions, true

### START METHODS ###
def calculate_total(cards)
  # [['H', '3'], ['S', 'Q'], ... ]
  arr = cards.map{|e| e[1] }

  total = 0
  arr.each do |value|
    if value == "ACE"
      total += 11
    elsif value.to_i == 0 # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for Aces
  arr.select{|e| e == "ACE"}.count.times do
    total -= 10 if total > 21
  end

  total
end

### END METHODS ###

### HELPERS START ###
helpers do
  def dealer_hit(cards, deck, score)
    while score < 17
      cards << deck.pop
      score = calculate_total(cards)
    end
    cards
  end

  def bust?(score)
    if score > 21
      true
    else
      false
    end

  end

require 'pry'

  def card_image(array)
    file_path = ""
    file_path = "<img src=" + '"/images/cards/' + array[0].to_s.downcase + "_" + array[1].to_s.downcase + '.jpg"' + "/>"
    file_path
  end


end


### HELPERS END ###

