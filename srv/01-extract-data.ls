require! {fs}
lines = fs.readFileSync "#__dirname/../data/unhcr-filtered.tsv" .toString!split "\n"
  ..shift!
  ..pop!
# lines.length = 2
# console.log lines.0

assoc = {}
outLines = []

for line in lines
  [year, residence, origin, type, value] = line.split "\t"
  value = parseInt value, 10
  id = [year, residence, origin].join "|"
  otherId = [year, residence, "other"].join "|"
  if assoc[id]
    possibleLine = assoc[id]
    possibleLine.value += value
  else
    possibleLine = assoc[id] = {year, residence, origin, value}
  if not possibleLine.out
    if assoc[otherId]
      otherLine = that
      otherLine.value += value
    else
      otherLine = assoc[otherId] = {year, residence, origin: "other", value}
      outLines.push otherLine
  if possibleLine.origin not in ["Various/Unknown" "Stateless"]
    if possibleLine.value > 40 and not possibleLine.out
      outLines.push  possibleLine
      possibleLine.out = yes
      otherLine.value -= possibleLine.value

# console.log outLines.length
outCsv = outLines
  .map (-> [it.year, it.residence, it.origin, it.value].join "\t")
  .join "\n"
fs.writeFileSync do
  "#__dirname/../data/output.tsv"
  outCsv
console.log outCsv.length / 1024
# console.log outLines
# sum = 0
# cnd = outLines
#   .filter(-> it.year == "2014" and it.residence == "Canada")
#   .forEach -> sum += it.value
# console.log sum
