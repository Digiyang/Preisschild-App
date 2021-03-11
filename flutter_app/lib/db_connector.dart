import 'dart:convert';
import 'dart:io';
import 'package:dartssh/client.dart';
import 'package:dartssh/ssh.dart';
import 'package:dartssh/transport.dart';

SSHClient client;

void main() async {

  var ssh_credentials = {
    "host": "93.27.220.48",
    "port": "22",
    "login": "pi",
    "password": "Digi4031-"
  };

  var db_credentials = {
    "host": "localhost",
    "login": "mahbubur",
    "password": "Preisschild2021*",
    "db_name": "Preisschild"
  };

  var query = "SELECT ord.order_id, " +
      "ord.date as order_date, " +
      "ord.price as total_price, " +
      "ord.order_status, " +
      "prd.title as item_name, " +
      "ord_itm.quantity as item_quantity, " +
      "CONCAT(ord_itm.quantity, ' x ', prd.unit_price, ' = ', ord_itm.item_price) as item_price " +
      "FROM Preisschild.tbl_order_item as ord_itm, " +
      "Preisschild.tbl_order as ord, " +
      "Preisschild.tbl_product as prd " +
      "WHERE ord_itm.order_id = ord.id " +
      "AND	ord_itm.product_id = prd.id;";

  var exitcode = await execute_through_ssh(ssh_credentials, db_credentials, (_, String v) {
    List<String> lines = v.split("\n");
    for (String l in lines) {
      if (l.contains("|")) {
        print(l);
      }
    }
  }, () => exit(0), query);
}

// insert
// select
// update

Future<int> execute_through_ssh(Map<String, String> ssh_credentials,
                                Map<String, String> db_credentials,
                                ResponseCallback response,
                                VoidCallback done,
                                String query) async {

  client = null;

  if (!ssh_credentials.containsKey("host") || ssh_credentials["host"].isEmpty) {
    print('no ssh host specified');
    return 1;
  }

  if (!ssh_credentials.containsKey("port") || ssh_credentials["port"].isEmpty) {
    print('no ssh port specified');
    return 2;
  }

  if (!ssh_credentials.containsKey("login") || ssh_credentials["login"].isEmpty) {
    print('no ssh login specified');
    return 3;
  }

  if (!db_credentials.containsKey("host") || db_credentials["host"].isEmpty) {
    print('no db host specified');
    return 4;
  }

  if (!db_credentials.containsKey("login") || db_credentials["login"].isEmpty) {
    print('no db login specified');
    return 5;
  }

  if (!db_credentials.containsKey("password") || db_credentials["password"].isEmpty) {
    print('no db password specified');
    return 6;
  }

  if (query.isEmpty) {
    print('no query specified');
    return 7;
  }

  try {
    client = SSHClient(
        hostport: parseUri(ssh_credentials['host'] + ":" + ssh_credentials['port']),
        login: ssh_credentials['login'],
        getPassword: ((ssh_credentials['password'] != null)
            ? () => utf8.encode(ssh_credentials['password'])
            : null),
        response: response,
        disconnected: done
    );

    var startUpCommand = StringBuffer("mysql -h ");
    startUpCommand.write(db_credentials["host"]);

    if (db_credentials.containsKey("port") && db_credentials["port"].isNotEmpty) {
      startUpCommand.write(" -P ");
      startUpCommand.write(db_credentials["port"]);
    }

    startUpCommand.write(" -u ");
    startUpCommand.write(db_credentials["login"]);

    startUpCommand.write(" -p");
    startUpCommand.write(db_credentials["password"]);

    if (db_credentials.containsKey("db_name") && db_credentials["db_name"].isNotEmpty) {
      startUpCommand.write(" ");
      startUpCommand.write(db_credentials["db_name"]);
    }

    startUpCommand.writeln("");
    startUpCommand.writeln(query);

    startUpCommand.writeln("quit");
    startUpCommand.writeln("logout");

    client.startupCommand = startUpCommand.toString();

  } catch (error, stacktrace) {
    print('ssh: exception: $error: $stacktrace');
    return -1;
  }

  return 0;
}