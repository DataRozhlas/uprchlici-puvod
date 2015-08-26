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

countrySelector = container.append \div
  ..attr \class \country-selector
  ..append \span .html "Zobrazit jinou zemi<br>"
  ..append \select
    ..append \option .html "Vyberte…"
    ..selectAll \option .data countries .enter!append \option
      ..html -> it.name
      ..attr \value -> it.englishName
    ..on \change ->
      console.log countriesAssoc[@value]
      display2.display countriesAssoc[@value]
