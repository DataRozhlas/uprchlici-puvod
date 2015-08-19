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
new Tooltip!watchElements!
display1 = new ig.Display leftDisplayContainer
  ..display countriesAssoc['Czech Rep.']
# <~ setTimeout _, 1000
# display1.display countriesAssoc['Italy']
