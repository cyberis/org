
describe "CoffeeScript", ->
  it "should concat strings", ->
    s1 = "s1"
    s1 += "s2"
    expect(s1).toBe("s1s2");
  it "should compare strings", ->
    s = "TODO"
    expect(s == 'TODO').toBe(true)

  if "should find substrings"
    s = "some string"
    expect(s.indexOf "ome").toBe(1)
    expect(s.indexOf "ing").toBe(8)
    expect(s.indexOf "xyz").toBe(-1)
