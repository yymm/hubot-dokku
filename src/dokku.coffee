# Description
#   A Hubot script for dokku
#
# Configuration:
#   HUBOT_DOKKU_SERVER_URL
#
# Commands:
#   hubot dokku help- responds dokku help
#
# Author:
#   yymm <yuya.yano.6260@gmail.com>

server_url = process.env.HUBOT_DOKKU_SERVER_URL

invalid_cmds = ['apps:destroy', 'enter']

module.exports = (robot) ->
  robot.respond /dokku (?!.*(&|\||>|;)).*/, (res) ->
    unless server_url?
      res.send "Missing HUBOT_DOKKU_SERVER_URL in environment: please set and try again."
      return
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
