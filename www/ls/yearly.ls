return if window.location.hash == '#2015'
countriesAssoc = {}
countries = []
data = d3.tsv.parse ig.data.uprchlici, (row) ->
  row.year = parseInt row.year, 10
  row.amount = parseInt row.amount, 10
  if not countriesAssoc[row.target]
    countriesAssoc[row.target] = new ig.Country row.target
    countries.push countriesAssoc[row.target]
  countriesAssoc[row.target].addLine row.year, row.source, row.amount
  row

for country in countries
  country.init!

container = d3.select ig.containers.base
leftDisplayContainer = container.append \div
  ..attr \class \display
rightDisplayContainer = container.append \div
  ..attr \class \display
new Tooltip!watchElements!
display1 = new ig.Display leftDisplayContainer
  ..display countriesAssoc['Czech Rep.']
display2 = new ig.Display rightDisplayContainer
  ..display countriesAssoc['Germany']
countriesSorted = countries.slice!
countriesSorted.sort (a, b) ->
  | a.sortableName > b.sortableName => 1
  | b.sortableName > a.sortableName => -1
  | otherwise                       => 0
countrySelector = container.append \div
  ..attr \class \country-selector
  ..append \span .html "Zobrazit jinou zemi<br>"
  ..append \select
    ..append \option .html "Vyberte…"
    ..selectAll \option .data countriesSorted .enter!append \option
      ..html -> it.name
      ..attr \value -> it.englishName
    ..on \change ->
      display2.display countriesAssoc[@value]
