class ig.Country
  (@englishName, @isMonthly) ->
    @name = ig.countryNames[@englishName]
    @population = ig.countryPopulations[@englishName]
    if @isMonthly
      @years = [1 to 7].map -> new Year it
    else
      @years = [1990 to 2014].map -> new Year it
    @sources = []
    @sourcesAssoc = {}
    @sortableName = switch @name
      | "Írán"      => "Irán"
      | "Česko"     => "Cesko"
      | "Čína"      => "Cína"
      | "Řecko"     => "Recko"
      | "Španělsko" => "Spanělsko"
      | "Švédsko"   => "Svédsko"
      | "Švýcarsko" => "Svýcarsko"
      | otherwise   => @name

  addLine: (year, source, amount) ->
    if @isMonthly
      yearIndex = year - 1
    else
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
    for source, index in @sources
      source.index = index


class Year
  (@year) ->
    @sum = 0
    @sources = []

  addLine: (source, amount) ->
    @sum += amount
    @sources.push new Source source, amount

  sort: ->
    @sources.sort (a, b) ->
      | a.isOther => 1
      | b.isOther => -1
      | otherwise            => b.amount - a.amount
    previousAmount = 0
    for source, index in @sources
      source.previousAmount = previousAmount
      previousAmount += source.amount



class Source
  (@countryEnglishName, @amount = 0, @previousAmount = 0) ->
    @isOther = @countryEnglishName == "other"
    @country = ig.countryNames[@countryEnglishName]
