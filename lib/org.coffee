OrgEditor = require './org-editor'
OrgStructureEdit = require './org-structure-edit'

module.exports =
  activate: (state) ->
    console.log "org-mode activate"
    @orgEditor = new OrgEditor
    @orgStructureEdit = new OrgStructureEdit
  deactivate: ->
    console.log "org-mode deactivate"
    @orgInput.destroy()

  serialize: ->
