define couchdb::create_db (
  $host='127.0.0.1:5984',
  $admins="{\"names\": [], \"roles\": [] }",
  $readers="{\"names\": [], \"roles\": [] }" )
{

  Couchdb::Query["create_db_${name}"] -> Couchdb::Document["${name}_security"]

  couchdb::query { "create_db_${name}":
    cmd    => 'PUT',
    host   => $host,
    url    => $name,
    unless => "/usr/bin/curl -s --netrc-file /etc/couchdb/couchdb.netrc ${host}/${name} | grep -q -v '{\"error\":\"not_found\"'"
  }

  couchdb::document { "${name}_security":
    db   => $name,
    id   => '_security',
    host => $host,
    data => "{ \"admins\": ${admins}, \"readers\": ${readers} }"
  }
}
