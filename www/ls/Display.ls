yScale = d3.scale.linear!
  ..range [0 100]
colorScale = d3.scale.category20!
color = (country) ->
  if country != "other"
    colorScale country
  else
    \#aaa
displays = []
ratioEnabled = 0
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
    @topTen = @element.append \ol
      ..attr \class \top-ten
    @legend = @element.append \div
      ..attr \class \legend
      ..selectAll \div.item .data [1990, 1995, 2000, 2005, 2010, 2014] .enter!append \div
        ..attr \class \item
        ..html -> it
        ..style \left -> "#{(it - 1990 + 0.5) * 100 / 25}%"
    @heading = @element.append \h2
    @ratio = 1

  display: (country) ->
    if not country
      country = @currentCountry
      banOtherUpdate = yes
    @currentCountry = country
    @rawMax = d3.max country.years.map (.sum)
    @setRatio!
    @max = @rawMax * @ratio
    console.log @max
    domainMax = yScale.domain!1
    if @otherDisplay
      maxMax = Math.max @max, @otherDisplay.max
      yScale.domain [0 maxMax]
      if maxMax != domainMax and not banOtherUpdate
        @otherDisplay.updateYScale!
    else
      yScale.domain [0 @max]
    @years.datum (d, i) -> country.years[i]
    @yearSources = @years.selectAll \div.item .data (.sources), (.country)
      ..enter!append \div
        ..attr \class \item
        ..style \background-color -> color it.countryEnglishName
      ..exit!remove!
      ..attr \data-tooltip -> "#{it.country}: #{ig.utils.formatNumber it.amount}"
    @updateYScale!
    topTenSources = country.sources.slice 0, 10
    lineHeight = 23
    @topTen.selectAll \li .data topTenSources, (.country)
      ..enter!append \li
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
      ..select \span.amount .html -> ig.utils.formatNumber it.amount
      ..style \top -> "#{it.index * lineHeight}px"
      ..classed \odd -> it.index % 2
    @heading.html country.name

  setRatio: (enable = null) ->
    if enable == yes or enable == no
      ratioEnabled := enable
    @ratio = 1
    if ratioEnabled
      @ratio /= @currentCountry.population
    if enable == yes or enable == no
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
