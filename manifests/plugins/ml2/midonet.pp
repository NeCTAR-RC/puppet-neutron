# == Class: neutron::plugins::ml2::midonet
#
# Configure the Mech Driver for midonet neutron plugin
#
# === Parameters:
#
# [*midonet_uri*]
#   (required) MidoNet API server URI.
#   Defaults to 'http://localhost:8080/midonet-api'
#
# [*username*]
#   (required) MidoNet admin username.
#   Defaults to 'admin'
#
# [*password*]
#   (required) MidoNet admin password.
#   Defaults to 'passw0rd'
#
# [*project_id*]
#   (required) Name of the project that MidoNet admin user belongs to.
#   Defaults to 'admin'
#
class neutron::plugins::ml2::midonet (
  $midonet_uri = 'http://localhost:8080/midonet-api',
  $username    = 'admin',
  $password    = 'passw0rd',
  $project_id  = 'admin',
) {

  neutron_plugin_ml2 {
    'MIDONET/midonet_uri' : value => $midonet_uri;
    'MIDONET/username'    : value => $username;
    'MIDONET/password'    : value => $password;
    'MIDONET/project_id'  : value => $project_id;
  }

}
