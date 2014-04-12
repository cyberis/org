module.exports =
class OrgInput
  constructor: ->
    @editor = atom.workspace.getActiveEditor()
    @insertText('Org mode on\n')
    @editor.getBuffer().on "changed", @onBufferChanged
    @possibleTodo = ''

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

  destroy: =>
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
