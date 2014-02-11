exec = require('child_process').exec
util = require 'util'

module.exports = (BasePlugin) ->

  class UpdatePlugin extends BasePlugin
    name: 'gitupdate'

    config = docpad.getConfig().plugins.update
    commands = ['git stash', 'git pull --rebase' , 'git stash pop']

    serverExtend: (opts) ->
      {server} = opts
      
      chainCharacter = if(process.platform == 'win32') then ' & ' else ' ; '
      updateCommand = commands.join(chainCharacter)

      server.get config.path, (req, res) ->
        console.log("Update using: '" + updateCommand + "' " );
        exec( updateCommand , (error,stdout,stderr) ->
          if(error || stderr) 
            console.log JSON.stringify(error)
            console.log JSON.stringify(stderr)
            res.write JSON.stringify(error)
            res.write JSON.stringify(stderr)

          console.log "*********************"
          console.log stdout
          res.end stdout
        )
        
      @
