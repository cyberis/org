OrgEditor = require './org-editor'
OrgInput = require './org-input'

module.exports =
  activate: (state) ->
    console.log "org-mode activate"
    @orgEditor = new OrgEditor
    @orgInput = new OrgInput
  deactivate: ->
    console.log "org-mode deactivate"
    @orgInput.destroy()

  serialize: ->
