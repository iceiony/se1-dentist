exec = require('child_process').exec
util = require 'util'

module.exports = (BasePlugin) ->

  class UpdatePlugin extends BasePlugin
    name: 'gitupdate'

    commands = ['git stash', 'git pull --rebase' , 'git stash pop']

    serverExtend: (opts) ->
      {server} = opts
      config = @docpad.getConfig().plugins.update
      
      chainCharacter = if(process.platform == 'win32') then ' & ' else ' ; '
      updateCommand = commands.join(chainCharacter)

      server.get config.path, (req, res) ->
        console.log("Update using: '" + updateCommand + "' " );
        exec( updateCommand , (error,stdout,stderr) ->
          if(error || stderr) 
            console.log "Failure occured when updating from git"
            console.log JSON.stringify(error)
            console.log JSON.stringify(stderr)
            res.write JSON.stringify(error)
            res.write JSON.stringify(stderr)

          console.log "*********************"
          console.log stdout
          res.write stdout

          @docpad.action "generate", (err,result) ->
            console.log "Regenerating complete"
            
            if(err) 
              console log "Failure occured when regenerating"
              console.log JSON.stringify(err)
              res.write JSON.stringify(err)
            
            if(result)
              console.log JSON.stringify(result)
              res.write JSON.stringify(result)
            
            res.end "Completed successfully"
        )
        
      @
