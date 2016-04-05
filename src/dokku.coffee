server_url = process.env.HUBOT_DOKKU_SERVER_URL

module.exports = (robot) ->
  robot.respond /dokku (?!.*(&|\||>|;)).*/, (res) ->
    unless server_url?
      res.send "Missing HUBOT_DOKKU_SERVER_URL in environment: please set and try again."
      return
    data = JSON.stringify({
        cmd: res.message.text.split(" ")[1..]
    })
    robot.http(server_url)
      .header('Content-Type', 'application/json')
      .post(data) (err, res, body) ->
        if err
          res.send "#{err}"
        data = JSON.parse body
        if data.stderr
          res.send "#{data.stderr}"
        else
          res.send "#{data.stdout}"
