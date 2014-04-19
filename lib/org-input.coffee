{Point} = require 'atom'
OrgTyping = require './org-typing'

module.exports =
class OrgInput
  constructor: ->
    @editorViewsWithOrg = []

    atom.workspaceView.eachEditorView (editorView) =>
      @setupCommands editorView
      @setupEditor editorView
      editorView.getEditor().getBuffer().on "saved", (event) =>
        @setupEditor editorView

  setupCommands: (editorView) =>
    ed = editorView.getEditor()
    editorView.command "org:insert-headline-empty-respect-content", (e) =>
      @inOrgFile ed, e, @insertEmptyHeadline
    editorView.command "org:insert-headline-todo-respect-content", (e) =>
      @inOrgFile ed, e, @insertTodo
    editorView.command "org:demote-headline", (e) =>
      @inOrgFile ed, e, @demoteHeadline
    editorView.command "org:promote-headline", (e) =>
      @inOrgFile ed, e, @promoteHeadline
    editorView.command "org:cycle-todo-forward", (e) =>
      @inOrgFile ed, e, @cycleTodoForward
    editorView.command "org:cycle-todo-backward", (e) =>
      @inOrgFile ed, e, @cycleTodoBackward

  setupEditor: (editorView) =>
    ed = editorView.getEditor()
    uri = ed.getBuffer().getUri()
    if (@editorViewsWithOrg[editorView.id]!=1 and uri and uri.endsWith('.org'))
      @editorViewsWithOrg[editorView.id] = 1
      ed.setSoftTabs true
      ed.setTabLength 2
      @typing = new OrgTyping(ed)

  inOrgFile: (ed, e, fn) =>
    uri = ed.getBuffer().getUri()
    if (uri.endsWith('.org'))
      fn(ed)
    else
      e.abortKeyBinding()

  insertEmptyHeadline: (ed) =>
    @insertHeadlineWith '* ', ed, true

  insertTodo: (ed) =>
    @insertHeadlineWith '* TODO ', ed, true

  promoteHeadline: (ed) =>
    @moveIndentationOfCurrentLineBy -1, ed

  demoteHeadline: (ed) =>
    @moveIndentationOfCurrentLineBy 1, ed

  cycleTodoForward: (ed) =>
    line = @getCurrentLine ed
    @replaceCurrentLine ed, line.replace /TODO/, "DONE"

  cycleTodoBackward: (ed) =>
    line = @getCurrentLine ed
    @replaceCurrentLine ed, line.replace /DONE/, "TODO"

  insertHeadlineWith: (prefix, ed, respectContent) =>
    if (respectContent==true)
      ed.moveCursorToEndOfLine()
    row = @getCurrentRow(ed)
    indent = ed.indentationForBufferRow(row)
    ed.insertNewline()
    ed.insertText(prefix)
    ed.setIndentationForBufferRow(row+1, indent)

  moveIndentationOfCurrentLineBy: (value, ed) =>
    row = @getCurrentRow(ed)
    newIndent = ed.indentationForBufferRow(row) + value
    if newIndent>=0
      ed.setIndentationForBufferRow row, newIndent

  getCurrentLine: (ed) =>
    row = @getCurrentRow ed
    return ed.getBuffer().getLines()[row]

  getCurrentRow: (ed) =>
    return ed.getCursor().getBufferRow()

  replaceCurrentLine: (ed, line) =>
    pos = ed.getCursor().getBufferPosition()
    ed.selectLine()
    ed.insertText line
    ed.getCursor().setBufferPosition(pos)

  destroy: =>

  serialize: ->
