{View} = require 'atom'

module.exports =
class OrgView extends View
  @content: ->

  initialize: (serializeState) ->
    atom.workspaceView.command "org:toggle", => @toggle()


  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "OrgView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
