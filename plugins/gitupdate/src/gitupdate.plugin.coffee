exec = require('child_process').exec
util = require 'util'

module.exports = (BasePlugin) ->

  class UpdatePlugin extends BasePlugin
    name: 'gitupdate'

    config = docpad.getConfig().plugins.update

    serverExtend: (opts) ->
      {server} = opts

      server.post config.path, (req, res) ->
        

      @
