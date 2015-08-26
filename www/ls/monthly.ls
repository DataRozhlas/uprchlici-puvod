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
    countriesAssoc[row.to] = new ig.Country row.to
    countries.push countriesAssoc[row.to]
  for month in [1 to 7]
    countriesAssoc[row.to].addLine do
      month + 1990
      row.from
      parseInt row["0{month}"], 10
  row

for country in countries
  country.init!

container = d3.select ig.containers.base
displayContainer = container.append \div
  ..attr \class \display
new Tooltip!watchElements!
console.log do
  countries
    .filter -> !it.population
    .map (.englishName)
    .join "\n"
display1 = new ig.Display displayContainer
  ..display countriesAssoc['Czech Rep.']
