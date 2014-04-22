
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
    pos = ed.getCursor().getBufferPosition()
    ed.selectLine()
    ed.insertText line + '\n'
    ed.getCursor().setBufferPosition(pos)

  destroy: =>

  serialize: ->
