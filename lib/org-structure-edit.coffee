OrgEditorHelpers = require './org-editor-helpers'

module.exports =
class OrgStructureEdit extends OrgEditorHelpers
  constructor: ->
    atom.workspaceView.eachEditorView (editorView) =>
      @setupCommands editorView

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

    editorView.command "org:demote-tree", (e) =>
      @inOrgFile ed, e, @demoteTree
    editorView.command "org:promote-tree", (e) =>
      @inOrgFile ed, e, @promoteTree

  insertEmptyHeadline: (ed) =>
    @insertHeadlineWith '* ', ed, true

  insertTodo: (ed) =>
    @insertHeadlineWith '* TODO ', ed, true

  promoteHeadline: (ed) =>
    @indentCurrentLine ed, -1

  demoteHeadline: (ed) =>
    @indentCurrentLine ed, 1

  cycleTodoForward: (ed) =>
    @cycleTodo ed, 1

  cycleTodoBackward: (ed) =>
    @cycleTodo ed, -1

  demoteTree: (ed) =>
    @indentCurrentTree ed, 1

  promoteTree: (ed) =>
    @indentCurrentTree ed, -1

  insertHeadlineWith: (prefix, ed, respectContent) =>
    if (respectContent==true)
      ed.moveCursorToEndOfLine()
    row = @getCurrentRow(ed)
    indent = ed.indentationForBufferRow(row)
    ed.insertNewline()
    ed.insertText(prefix)
    ed.setIndentationForBufferRow(row+1, indent)

  indentCurrentLine: (ed, value) =>
    row = @getCurrentRow(ed)
    @indentLine ed, row, value

  indentCurrentTree: (ed, value) =>
    row = @getCurrentRow(ed)
    buffer = ed.getBuffer()
    indent = ed.indentationForBufferRow(row)
    for i in [row+1 .. buffer.getLastRow()] by 1
      if (indent > 0 || value > 0) and ed.indentationForBufferRow(i) > indent
        @indentLine(ed, i, value)
      else
        break
    @indentCurrentLine(ed, value)

  indentLine: (ed, row, value) =>
    newIndent = ed.indentationForBufferRow(row) + value
    if newIndent>=0
      ed.setIndentationForBufferRow row, newIndent

  cycleTodo: (ed, direction) =>
    keywords = ['TODO', 'NEXT', 'DONE']
    line = @getCurrentLine ed
    for i in [0..keywords.length] by 1
      kw = keywords[i]
      if (line.indexOf(kw) != -1)
        nextIndex = (i+direction)%keywords.length
        if (nextIndex<0)
          nextIndex = keywords.length-1
        nextKW = keywords[nextIndex]
        @replaceCurrentLine ed, line.replace "* " + kw, '* ' + nextKW

  destroy: =>

  serialize: ->
