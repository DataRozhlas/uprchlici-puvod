yScale = d3.scale.linear!
  ..range [0 100]
colorScale = d3.scale.category20!
color = (country) ->
  if country != "other"
    colorScale country
  else
    \#aaa
displays = []
ratioEnabled = 1
class ig.Display
  (@element) ->
    displays.push @
    if displays.0 != @
      displays.0.otherDisplay = @
      @otherDisplay = displays.0
    @bars = @element.append \div
      ..attr \class \bars
    @years = @bars.selectAll \div .data [1990 to 2014] .enter!append \div
      ..attr \class \year
      ..on \mouseover @~onYearHover
      ..on \touchstart @~onYearHover
    @topTen = @element.append \ol
      ..attr \class \top-ten
    @legend = @element.append \div
      ..attr \class \legend
      ..selectAll \div.item .data [1990, 1995, 2000, 2005, 2010, 2014] .enter!append \div
        ..attr \class \item
        ..html -> it
        ..style \left -> "#{(it - 1990 + 0.5) * 100 / 25}%"
    @topTenHeading = @element.append \div
      ..attr \class \top-ten-heading
    @heading = @element.append \h2

  display: (country) ->
    if country is void
      country = @currentCountry
    @currentCountry = country
    @ratio = 1
    if ratioEnabled
      @ratio /= @currentCountry.population
    @rawMax = d3.max country.years.map (.sum)
    @setRatio!
    @max = @rawMax * @ratio
    domainMax = yScale.domain!1
    if @otherDisplay
      maxMax = Math.max @max, @otherDisplay.max
      yScale.domain [0 maxMax]
      if maxMax != domainMax
        @otherDisplay.updateYScale!
    else
      yScale.domain [0 @max]
    @years.datum (d, i) -> country.years[i]
    @yearSources = @years.selectAll \div.item .data (.sources), (.country)
      ..enter!append \div
        ..attr \class \item
        ..style \background-color -> color it.countryEnglishName
      ..exit!remove!
      ..attr \data-tooltip ~> "<b>#{it.country}: </b> <b>#{ig.utils.formatNumber it.amount}</b> uprchlíků,
      <br>tj. <b>#{ig.utils.formatNumber it.amount / @currentCountry.population}</b> na milion obyvatel"
    @updateYScale!
    @drawTopTen country.years[*-1]
    @heading.html country.name

  onYearHover: (year, index) ->
    @drawTopTen year
    if @otherDisplay
      @otherDisplay.drawTopTen do
        @otherDisplay.currentCountry.years[index]

  drawTopTen: (year) ->
    lastYear = year.sources
      .slice 0, 10
      .filter -> it.amount
    for source, index in lastYear
      source.index = index
    lineHeight = 23
    @topTen.selectAll \li.country .data lastYear, (.country)
      ..enter!append \li
        ..attr \class \country
        ..append \span
          ..attr \class \name
          ..html (.country)
        ..append \span
          ..attr \class \amount
        ..append \div
          ..attr \class \square
          ..style \background-color -> color it.countryEnglishName
        ..on \mouseover ~> @highlight it.countryEnglishName
        ..on \touchstart ~> @highlight it.countryEnglishName
        ..on \mouseout ~> @downlight!
        ..on \touchend ~> @downlight!
      ..exit!remove!
      ..select \span.amount .html ~>
        number = it.amount * @ratio
        decimals =
          | number < 10 => 2
          | number < 100 => 1
          | otherwise => 0
        ig.utils.formatNumber number, decimals
      ..style \top -> "#{it.index * lineHeight}px"
      ..classed \odd -> it.index % 2
    @topTenHeading.html "Uprchlíků na milion obyvatel, #{year.year}"

    sumNumber = year.sum * @ratio
    sumDecimals =
      | sumNumber < 10 => 2
      | sumNumber < 100 => 1
      | otherwise => 0

    @topTen.selectAll \li.sum .data [year]
      ..enter!append \li
        ..attr \class \sum
        ..append \span
          ..attr \class \name
          ..html "Celkem"
        ..append \span
          ..attr \class \amount
      ..select \span.amount .html "#{ig.utils.formatNumber sumNumber, sumDecimals}"
      ..classed \odd -> lastYear.length % 2
      ..style \top -> "#{lastYear.length * lineHeight}px"

  setRatio: (enable = null) ->
    if enable == yes or enable == no
      ratioEnabled := enable
      @display!
      @otherDisplay.display!

  updateYScale: ->
    @yearSources
      ..style \bottom ~> "#{yScale @ratio * it.previousAmount}%"
      ..style \height ~> "#{yScale @ratio * it.amount}%"

  highlight: (countryEnglishName) ->
    @bars.classed \highlight yes
    @yearSources.classed \active -> it.countryEnglishName is countryEnglishName

  downlight: ->
    @bars.classed \highlight no
    @yearSources.classed \active no
