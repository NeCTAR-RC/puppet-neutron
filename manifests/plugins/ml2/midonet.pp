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
#
# [*password*]
#   (required) MidoNet admin password.
#
# [*project_id*]
#   (required) Name of the project that MidoNet admin user belongs to.
#
class neutron::plugins::ml2::midonet (
  $midonet_uri = 'http://localhost:8080/midonet-api',
  $username,
  $password,
  $project_id,
) {

  neutron_plugin_ml2 {
    'MIDONET/midonet_uri' : value => $midonet_uri;
    'MIDONET/username'    : value => $username;
    'MIDONET/password'    : value => $password;
    'MIDONET/project_id'  : value => $project_id;
  }

}
