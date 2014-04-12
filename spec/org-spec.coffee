Org = require '../lib/org'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Org", ->
  activationPromise = null

  it "should concat strings", ->
    s1 = "s1"
    s1 += "s2"
    expect(s1).toBe("s1s2");
  it "should compare strings", ->
    s = "TOD"
    s += "O"
    expect(s == 'TODO').toBe(true)
