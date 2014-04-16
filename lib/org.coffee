OrgInput = require './org-input'
module.exports =
  activate: (state) ->
    console.log "org-mode activate"
    @orgInput = new OrgInput
  deactivate: ->
    console.log "org-mode deactivate"
    @orgInput.destroy()

  serialize: ->
