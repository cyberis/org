{Point} = require 'atom'
OrgTyping = require './org-typing'

module.exports =
class OrgInput
  constructor: ->
    @editorViewsWithOrg = []
    atom.workspaceView.eachEditorView (editorView) =>
      @setupOrgMode editorView
      editorView.getEditor().getBuffer().on "saved", (event) =>
        @setupOrgMode editorView

  setupOrgMode: (editorView) =>
    ed = editorView.getEditor()
    uri = ed.getBuffer().getUri()
    if (@editorViewsWithOrg[editorView.id]!=1 and uri and uri.endsWith('.org'))
      @editorViewsWithOrg[editorView.id] = 1
      ed.setSoftTabs true
      ed.setTabLength 2

      @typing = new OrgTyping(ed)

      editorView.command "org:cmd-enter", (e) =>
        @insertHeadlineBelow(ed)
      editorView.command "org:cmd-shift-enter", (e) =>
        @insertTodo(ed)
      editorView.command "org:demote-headline", (e) =>
        @demoteHeadline(ed)
      editorView.command "org:promote-headline", (e) =>
        @promoteHeadline(ed)


  insertEmptyHeading: (ed) =>
    ed.insertNewline()
    ed.insertText('*')

  insertTodo: (ed) =>
    ed.moveCursorToEndOfLine()
    ed.insertNewline()
    ed.insertText('* TODO ')

  promoteHeadline: (ed) =>
    @moveIndentationOfCurrentLineBy -1, ed
  demoteHeadline: (ed) =>
    @moveIndentationOfCurrentLineBy 1, ed

  moveIndentationOfCurrentLineBy: (value, ed) =>
    row = @getCurrentRow(ed)
    newIndent = ed.indentationForBufferRow(row) + value
    if newIndent>=0
      ed.setIndentationForBufferRow row, newIndent

  insertHeadlineBelow: (ed) =>
    row = @getCurrentRow(ed)
    indent = ed.indentationForBufferRow(row)
    ed.insertNewline()
    ed.insertText('* ')
    ed.setIndentationForBufferRow(row+1, indent)


  getCurrentRow: (ed) =>
    return ed.getCursors()[0].getBufferRow()


  destroy: =>

  serialize: ->
