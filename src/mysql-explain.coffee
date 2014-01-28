# Description:
#   Explain a MySQL Query
#
# Notes:
#   This script requires a MySQL user with SELECT priviliges. 
#   You can create a user like so: GRANT SELECT ON some_db.* TO 'hubot_mysql'@'hubot_host' IDENTIFIED BY 'some_pass';
#   !! It is very strongly recommended that you use a read only user on a MySQL slave !!
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
#   hubot mysql explain <sql> - Run MySQL EXPLAIN on <sql>

mysql = require 'mysql'
table = require 'cli-table'
validator = require 'validator'

module.exports = (robot) ->
  robot.respond /mysql explain (.*)/i, (msg) ->
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

    @client.query "EXPLAIN #{query}", (err, results) =>
      if err
        msg.reply err
        return

      table_max = 0
      poss_max = 0
      key_max = 0
      ref_max = 0
      extra_max = 0

      rows = []

      for row in results
        row.Extra ?= ''
        explain = ["#{row.select_type}", "#{row.table}", "#{row.type}", "#{row.possible_keys}", "#{row.key}", "#{row.key_len}", "#{row.ref}", "#{row.rows}", "#{row.Extra}"]
        padding = 4
        if explain[1].length + padding > table_max 
          table_max = explain[1].length + padding
        if explain[3].length + padding > poss_max 
          poss_max = explain[3].length + padding
        if explain[4].length + padding > key_max 
          key_max = explain[4].length + padding
        if explain[6].length + padding > ref_max 
          ref_max = explain[6].length + padding
        if explain[8].length + padding > extra_max 
          extra_max = explain[8].length + padding
        rows.push explain

      @grid = new table
        head: ['Select Type', 'Table', 'Type', 'Possible Keys', 'Key', 'Key Len', 'Ref', 'Rows', 'Extra']
        style: { head: false }
        colWidths: [15, table_max, 10, poss_max, key_max, 10, ref_max, 10, extra_max]

      for row in rows
        @grid.push row

      msg.reply "\n#{@grid.toString()}"
      @client.destroy()
