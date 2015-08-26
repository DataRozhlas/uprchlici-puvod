return if window.location.hash != '#2015'

countriesAssoc = {}
countries = []
countryNamesReverse = {}

for english, czech of ig.countryNames
  countryNamesReverse[czech] = english
data = d3.tsv.parse ig.data.uprchlici_2015, (row) ->
  row.amount = parseInt row.amount, 10
  row.to = countryNamesReverse[row.to]
  row.from = countryNamesReverse[row.from]
  if not countriesAssoc[row.to]
    countriesAssoc[row.to] = new ig.Country row.to, true
    countries.push countriesAssoc[row.to]
  for month in [1 to 7]
    countriesAssoc[row.to].addLine do
      month
      row.from
      parseInt row["0#{month}-2015"], 10
  row

for country in countries
  country.init!

container = d3.select ig.containers.base
displayContainer = container.append \div
  ..attr \class "display monthly"
new Tooltip!watchElements!
display1 = new ig.DisplayMonthly displayContainer
  ..display countriesAssoc['Czech Rep.']

countriesSorted = countries.slice!
countriesSorted.sort (a, b) ->
  | a.sortableName > b.sortableName => 1
  | b.sortableName > a.sortableName => -1
  | otherwise                       => 0
countrySelector = container.append \div
  ..attr \class "country-selector monthly"
  ..append \span .html "Zobrazit jinou zemi<br>"
  ..append \select
    ..append \option .html "Vyberte…"
    ..selectAll \option .data countriesSorted .enter!append \option
      ..html -> it.name
      ..attr \value -> it.englishName
    ..on \change ->
      console.log countriesAssoc[@value]
      display1.display countriesAssoc[@value]
