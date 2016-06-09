# hubot-dokku

Hubot script for Dokku v0.4.x.

Using [dokku-daemon](https://github.com/dokku/dokku-daemon "dokku/dokku-daemon: A daemon wrapper around dokku").

Require mount /var/run/dokku-daemon/dokku-daemon.sock.

```
$ sudo dokku docker-options:add yourapp deploy "-v /var/run/dokku-daemon/dokku-daemon.sock:/var/run/dokku-daemon/dokku-daemon.sock"
($ sudo dokku ps:restart yourapp)
```

## dokku v0.5.x

Require [hubot-dokku-server](https://github.com/yymm/hubot-dokku-server "yymm/hubot-dokku-server").

Require environment value: HUBOT_DOKKU_SERVER_URL. ex: http://192.168.0.100:5050

---

More dokku information => [Dokku - The smallest PaaS implementation you've ever seen](http://dokku.viewdocs.io/dokku/installation/ "Dokku - The smallest PaaS implementation you've ever seen")
