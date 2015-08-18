class ig.Country
  (@englishName) ->
    @name = ig.countryNames[@englishName]
    @years = [1990 to 2014].map -> new Year it
    @sources = []
    @sourcesAssoc = {}

  addLine: (year, source, amount) ->
    yearIndex = year - 1990
    @years[yearIndex].addLine source, amount
    return if source == "other"
    if not @sourcesAssoc[source]
      @sourcesAssoc[source] = new Source source
      @sources.push @sourcesAssoc[source]
    @sourcesAssoc[source].amount += amount

  init: ->
    for year in @years
      year.sort!
    @sources.sort (a, b) -> b.amount - a.amount


class Year
  (@year) ->
    @sum = 0
    @sources = []

  addLine: (source, amount) ->
    @sum += amount
    @sources.push new Source source, amount

  sort: ->
    @sources.sort (a, b) ->
      | a.isOther == "other" => 1
      | b.isOther == "other" => -1
      | otherwise            => b.amount - a.amount
    previousAmount = 0
    for source in @sources
      source.previousAmount = previousAmount
      previousAmount += source.amount



class Source
  (@countryEnglishName, @amount = 0, @previousAmount = 0) ->
    @isOther = @countryEnglishName == "other"
    @country = ig.countryNames[@countryEnglishName]
