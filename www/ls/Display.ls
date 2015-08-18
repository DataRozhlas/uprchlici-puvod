colorScale = d3.scale.category20!
color = (country) ->
  if country != "other"
    colorScale country
  else
    \#aaa

class ig.Display
  (@element) ->
    @bars = @element.append \div
      ..attr \class \bars
    @years = @bars.selectAll \div .data [1990 to 2014] .enter!append \div
      ..attr \class \year

  display: (country) ->
    max = d3.max country.years.map (.sum)
    yScale = d3.scale.linear!
      ..domain [0 max]
      ..range [0 100]

    @years.datum (d, i) -> country.years[i]
    @years.selectAll \div.item .data (.sources), (.country)
      ..enter!append \div
        ..attr \class \item
        ..style \background-color -> color it.country
      ..exit!remove!
      ..style \bottom -> "#{yScale it.previousAmount}%"
      ..style \height -> "#{yScale it.amount}%"
