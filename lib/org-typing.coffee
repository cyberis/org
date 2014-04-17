module.exports =
class OrgTyping
  constructor: (editor)->
    @editor = editor
    @possibleTodo = ''
    editor.getBuffer().on "changed", (event) =>
      @onBufferChanged(editor, event)


  onBufferChanged: (editor, event) =>
    if (event.newText!=' ')
      @possibleTodo = @possibleTodo + event.newText
    isNewLineWithStar = event.oldRange.start.column==0 and event.newText=='*'
    hasTypedTodoKeyword = @possibleTodo=="TODO" or @possibleTodo=="NEXT"
    if isNewLineWithStar or hasTypedTodoKeyword
      @possibleTodo = ''
      @insertTextNextTick ' ', editor

  insertTextNextTick: (str, editor) =>
    process.nextTick =>
      editor.insertText(str)

  destroy: =>
    @editor.getBuffer().off "changed", @onChanged

  serialize: ->
