import 'dart:convert';
import 'dart:io';
import 'package:dartssh/client.dart';
import 'package:dartssh/ssh.dart';
import 'package:dartssh/transport.dart';

class DBConnector {

  SSHClient client;

  // ignore: non_constant_identifier_names
  static final Map<String, String> ssh_credentials = {
    "host": "93.27.220.48",
    "port": "22",
    "login": "pi",
    "password": "Digi4031-"
  };

  // ignore: non_constant_identifier_names
  static final Map<String, String> db_credentials = {
    "host": "localhost",
    "login": "mahbubur",
    "password": "Preisschild2021*",
    "db_name": "Preisschild"
  };

  static final done = () => exit(0);

  // insert
  // select
  // update
  // ignore: non_constant_identifier_names
  Future<int> execute_through_ssh(String query, ResponseCallback response) async {

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

      startUpCommand.write(" -e \"");
      startUpCommand.write(query);

      startUpCommand.writeln("\"");
      startUpCommand.writeln("logout");

      client.startupCommand = startUpCommand.toString();

    } catch (error, stacktrace) {
      print('ssh: exception: $error: $stacktrace');
      return -1;
    }

    return 0;
  }
}

