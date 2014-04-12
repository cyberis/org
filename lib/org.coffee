OrgInput = require './org-input'
module.exports =
  activate: (state) ->
    @orgInput = new OrgInput
  deactivate: ->
    @orgInput.destroy()

  serialize: ->
