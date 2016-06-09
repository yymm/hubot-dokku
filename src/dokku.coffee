# Description
#   A Hubot script for dokku
#
# Configuration:
#   HUBOT_DOKKU_SERVER_URL
#
# Commands:
#   hubot dokku <cmd>
#
# Author:
#   yymm <yuya.yano.6260@gmail.com>

net = require "net"

server_url = process.env.HUBOT_DOKKU_SERVER_URL

module.exports = (robot) ->
  #robot.respond /dokku (?!.*(&|\||>|;)).*/, (res) ->
  robot.respond /dokku (.*)/i, (res) ->

    if server_url?
      # Dokku v0.5.x
      invalid_cmds = ['apps:destroy', 'enter']
      cmd = res.message.text.split(" ")[1..]
      for invalid_cmd in invalid_cmds
        if cmd[1] == invalid_cmd
          res.send "Interactive commands is prohibited: [ #{invalid_cmds} ]"
          return
      data = JSON.stringify({
          cmd: cmd
      })
      robot.http(server_url)
        .header('Content-Type', 'application/json')
        .post(data) (err, resp, body) ->
          if err
            res.send "#{err}"
          data = JSON.parse body
          if data.stderr
            res.send "#{data.stderr}"
          else
            res.send "#{data.stdout}"

    # Dokku v0.4.x
    msg = res.match[1]
    sock_path = "/var/run/dokku-daemon/dokku-daemon.sock"
    client = net.connect({path: sock_path}, () ->
      console.log "connect to #{sock_path}"
      client.write("#{msg}\n")
    )
    client.on("error", (err) ->
      console.log "Error: #{err}"
    )
    client.on("data", (json) ->
      data = JSON.parse json
      if data.ok
        res.send "```\n#{data.output}\n```"
      else
        res.send "```\n#{data.output}\n```"
      client.end()
    )
    client.on("end", () ->
      console.log "disconnect to #{sock_path}"
    )
