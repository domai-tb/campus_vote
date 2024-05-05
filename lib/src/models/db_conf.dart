class CampusVoteDBConf {
  final String username;
  final String host;
  final int port;
  final String database;
  final String rootCert;
  final String clientCert;
  final String clientKey;

  const CampusVoteDBConf({
    this.username = 'root',
    this.host = '127.0.0.1',
    this.port = 26257,
    this.database = 'campus_vote',
    required this.rootCert,
    required this.clientCert,
    required this.clientKey,
  });
}
