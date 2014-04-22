{Point} = require 'atom'

module.exports =
class OrgEditorHelpers
  inOrgFile: (ed, e, fn) =>
    uri = ed.getBuffer().getUri()
    if (uri.endsWith('.org'))
      fn(ed)
    else
      e.abortKeyBinding()

  getCurrentLine: (ed) =>
    row = @getCurrentRow ed
    return ed.getBuffer().lineForRow(row)

  getCurrentRow: (ed) =>
    return ed.getCursor().getBufferRow()

  replaceCurrentLine: (ed, line) =>
    pos = @getCursorPosition ed
    ed.selectLine()
    ed.insertText line + '\n'
    @setCursorPosition ed, pos.row, pos.column

  moveCursorUp: (ed) =>
    row = @getCurrentRow ed
    setCurrentRow(ed, row - 1)

  moveCursorDown: (ed) =>
    row = @getCurrentRow ed
    setCurrentRow(ed, row + 1)

  setCurrentRow: (ed, row) =>
    pos = @getCursorPosition ed
    @setCursorPosition ed, row, pos.column

  setCursorPosition: (ed, row, column) =>
    ed.getCursor().setBufferPosition(new Point(row, column))

  getCursorPosition: (ed) =>
    return ed.getCursor().getBufferPosition()

  destroy: =>

  serialize: ->
