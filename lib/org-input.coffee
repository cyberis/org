{Point} = require 'atom'

module.exports =
class OrgInput
  constructor: ->
    @editor = atom.workspace.getActiveEditor()
    @editor.setSoftTabs true
    @editor.setTabLength 2
    @insertText('Org mode on\n')
    @editor.getBuffer().on "changed", @onBufferChanged
    @possibleTodo = ''
    atom.workspaceView.eachEditorView (editorView) =>
      editorView.command "org:cmd-enter", (e) =>
        @insertHeadlineBelow()
      editorView.command "org:cmd-shift-enter", (e) =>
        @insertTodo()
      editorView.command "org:demote-headline", (e) =>
        @demoteHeadline()
      editorView.command "org:promote-headline", (e) =>
        @promoteHeadline()

  insertText: (str) =>
    process.nextTick =>
      @editor.insertText(str)

  onBufferChanged: (e) =>
    if (e.newText!=' ')
      @possibleTodo = @possibleTodo + e.newText
    isNewLineWithStar = e.oldRange.start.column==0 and e.newText=='*'
    hasTypedTodoKeyword = @possibleTodo=="TODO" or @possibleTodo=="NEXT"
    if isNewLineWithStar or hasTypedTodoKeyword
      @possibleTodo = ''
      @insertText ' '

  insertEmptyHeading: =>
    @editor.insertNewline()
    @editor.insertText('*')

  insertTodo: =>
    @editor.moveCursorToEndOfLine()
    @editor.insertNewline()
    @editor.insertText('* TODO ')

  promoteHeadline: =>
    @moveIndentationOfCurrentLineBy -1
  demoteHeadline: =>
    @moveIndentationOfCurrentLineBy 1

  moveIndentationOfCurrentLineBy: (value) =>
    row = @getCurrentRow()
    newIndent = @editor.indentationForBufferRow(row) + value
    if newIndent>=0
      @editor.setIndentationForBufferRow row, newIndent

  insertHeadlineBelow: =>
    row = @getCurrentRow()
    indent = @editor.indentationForBufferRow(row)
    @editor.insertNewline()
    @editor.insertText('* ')
    @editor.setIndentationForBufferRow(row+1, indent)


  getCurrentRow: =>
    return @editor.getCursors()[0].getBufferRow()


  destroy: =>
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
