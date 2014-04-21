OrgTyping = require './org-typing'

module.exports =
class OrgEditor
  constructor: ->
    @editorViewsWithOrg = []

    atom.workspaceView.eachEditorView (editorView) =>
      @setupEditor editorView
      editorView.getEditor().getBuffer().on "saved", (event) =>
        @setupEditor editorView

  setupEditor: (editorView) =>
    ed = editorView.getEditor()
    uri = ed.getBuffer().getUri()
    if (@editorViewsWithOrg[editorView.id]!=1 and uri and uri.endsWith('.org'))
      @editorViewsWithOrg[editorView.id] = 1
      ed.setSoftTabs true
      ed.setTabLength 2
      @typing = new OrgTyping(ed)

  destroy: =>

  serialize: ->
