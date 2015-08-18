class ig.Country
  (@name) ->
    @years = [1990 to 2014].map -> new Year it

  addLine: (year, source, amount) ->
    yearIndex = year - 1990
    @years[yearIndex].addLine source, amount

  sortYears: ->
    for year in @years
      year.sort!

class Year
  (@year) ->
    @sum = 0
    @sources = []

  addLine: (source, amount) ->
    @sum += amount
    @sources.push new Source source, amount

  sort: ->
    @sources.sort (a, b) ->
      | a.country == "other" => 1
      | b.country == "other" => -1
      | otherwise            => b.amount - a.amount
    previousAmount = 0
    for source in @sources
      source.previousAmount = previousAmount
      previousAmount += source.amount



class Source
  (@country, @amount, @previousAmount = 0) ->
