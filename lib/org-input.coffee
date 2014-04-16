{Point} = require 'atom'

module.exports =
class OrgInput
  constructor: ->
    @possibleTodo = ''
    atom.workspaceView.eachEditorView (editorView) =>
      ed = editorView.getEditor()
      uri = ed.getBuffer().getUri()
      if (uri.endsWith('.org'))
        ed.setSoftTabs true
        ed.setTabLength 2

        ed.getBuffer().on "changed", (event) =>
          @onBufferChanged(ed, event)
        editorView.command "org:cmd-enter", (e) =>
          @insertHeadlineBelow(ed)
        editorView.command "org:cmd-shift-enter", (e) =>
          @insertTodo(ed)
        editorView.command "org:demote-headline", (e) =>
          @demoteHeadline(ed)
        editorView.command "org:promote-headline", (e) =>
          @promoteHeadline(ed)

  inOrgFile: (ed, fn) =>
    uri = ed.getBuffer().getUri()
    if (uri.endsWith('.org'))
      fn(ed)
    else
      e.abortKeyBinding()

  insertTextNextTick: (str, editor) =>
    process.nextTick =>
      editor.insertText(str)

  onBufferChanged: (editor, event) =>
    if (event.newText!=' ')
      @possibleTodo = @possibleTodo + editor.newText
    isNewLineWithStar = event.oldRange.start.column==0 and event.newText=='*'
    hasTypedTodoKeyword = @possibleTodo=="TODO" or @possibleTodo=="NEXT"
    if isNewLineWithStar or hasTypedTodoKeyword
      @possibleTodo = ''
      @insertTextNextTick ' ', editor

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
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
