module.exports =
class OrgInput
  constructor: ->
    @editor = atom.workspace.getActiveEditor()
    @insertText('Org mode on\n')
    @editor.getBuffer().on "changed", @onBufferChanged
    @possibleTodo = ''
    atom.workspaceView.eachEditorView (editorView) =>
      editorView.command "org:cmd-enter", (e) =>
        @insertEmptyHeading()
      editorView.command "org:cmd-shift-enter", (e) =>
        @insertTodo()


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

  destroy: =>
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
