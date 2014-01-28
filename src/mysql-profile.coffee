# Description:
#   Profile a MySQL Query
#
# Notes:
#   This script requires a MySQL user with SELECT priviliges. 
#   You can create a user like so: GRANT SELECT ON some_db.* TO 'hubot_mysql'@'hubot_host' IDENTIFIED BY 'some_pass';
#   !! Warning. In order to collect a profile the query is executed. It is very strongly recommended that you use a read only user on a MySQL slave !!
#
# Dependencies:
#   "cli-table" : "https://github.com/LearnBoost/cli-table"
#   "mysql"     : "https://github.com/felixge/node-mysql"
#   "validator" : "https://github.com/chriso/validator.js"
#
# Configuration:
#   HUBOT_MYSQL_CHATOPS_HOST
#   HUBOT_MYSQL_CHATOPS_DATABASE
#   HUBOT_MYSQL_CHATOPS_USER
#   HUBOT_MYSQL_CHATOPS_PASS
#
# Commands:
#   hubot mysql profile <sql> - Run MySQL profile on <sql>

mysql = require 'mysql'
table = require 'cli-table'
validator = require 'validator'

module.exports = (robot) ->

  robot.respond /mysql profile (.*)/i, (msg) ->
    msg.reply "This will run and profile a query against MySQL. To run this fo realz use mysql profile!. Be careful ;)"
    return

  robot.respond /mysql profile! (.*)/i, (msg) ->
    query = validator.blacklist(msg.match[1], [';'])

    unless process.env.HUBOT_MYSQL_CHATOPS_HOST?
      msg.reply "Would love to, but kind of missing HUBOT_MYSQL_CHATOPS_HOST"
      return

    unless process.env.HUBOT_MYSQL_CHATOPS_DATABASE?
      msg.reply "Would love to, but kind of missing HUBOT_MYSQL_CHATOPS_DATABASE"
      return

    unless process.env.HUBOT_MYSQL_CHATOPS_USER?
      msg.reply "Would love to, but kind of missing HUBOT_MYSQL_CHATOPS_USER"
      return

    unless process.env.HUBOT_MYSQL_CHATOPS_PASS?
      msg.reply "Would love to, but kind of missing HUBOT_MYSQL_CHATOPS_PASS"
      return

    @client = mysql.createClient
      host:  "#{process.env.HUBOT_MYSQL_CHATOPS_HOST}"
      database: "#{process.env.HUBOT_MYSQL_CHATOPS_DATABASE}"
      user: "#{process.env.HUBOT_MYSQL_CHATOPS_USER}"
      password: "#{process.env.HUBOT_MYSQL_CHATOPS_PASS}"
    @client.on 'error', (err) ->
      robot.emit 'error', err, msg

    @client.query "SET PROFILING = 1", (err, results) =>
      if err
        msg.reply err
        return
      @client.query "#{query}", (err, results) =>  
        if err
          msg.reply err
          return
        @client.query "SHOW PROFILE FOR QUERY 1", (err, results) =>
          if err
            msg.reply err
            return

          status_max = 0
          duration_max = 0

          rows = []

          for row in results
            profile = ["#{row.Status}", "#{row.Duration}"]
            padding = 8
            if profile[0].length + padding > status_max 
              status_max = profile[0].length + padding
            if profile[1].length + padding > duration_max
              duration_max = profile[1].length + padding
            rows.push profile

          @grid = new table
            head: ['Status', 'Duration (secs)']
            style: { head: false }
            colWidths: [status_max, duration_max]

          for row in rows
            @grid.push row

          msg.reply "\n#{@grid.toString()}"
          @client.destroy()
