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
        @insertEmptyHeading()
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
    row = @editor.getCursors()[0].getBufferRow()
    newIndent = @editor.indentationForBufferRow(row) + value
    if newIndent>=0
      @editor.setIndentationForBufferRow row, newIndent


  destroy: =>
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
