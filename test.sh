#!/usr/bin/env bats

# source the helper script
APP_NAME=apache
VOLUMES=/bitnami/$APP_NAME
SLEEP_TIME=20
load tests/docker_helper

# Cleans up all running/stopped containers and host mounted volumes
cleanup_environment() {
  container_remove default
}

# Teardown called at the end of each test
teardown() {
  cleanup_environment
}

# cleanup the environment before starting the tests
cleanup_environment

@test "We can connect to the port 80 and 443" {
  container_create default -d

  # http connection
  run curl_client default -i http://$APP_NAME:80
  [[ "$output" =~  "200 OK" ]]

  # https connection
  run curl_client default -i -k https://$APP_NAME:443
  [[ "$output" =~  "200 OK" ]]
}

@test "Returns default page" {
  container_create default -d

  # http connection
  run curl_client default -i http://$APP_NAME:80
  [[ "$output" =~  "It works!" ]]

  # https connections
  run curl_client default -i -k https://$APP_NAME:443
  [[ "$output" =~  "It works!" ]]
}

@test "Logs to stdout" {
  container_create default -d

  # make sample request
  curl_client default -i http://$APP_NAME:80

  # check if our request is logged in the container logs
  run container_logs default
  [[ "$output" =~  "GET / HTTP/1.1" ]]
}

@test "Vhosts directory is imported" {
  # create container and exposing TCP port 81
  container_create default -d --expose 81

  # create a vhost config for accepting connections on TCP port 81
  container_exec default sh -c "cat > $VOL_PREFIX/conf/vhosts/test.conf <<EOF
Listen 81
<VirtualHost *:81>
  ServerName default
  Redirect 405 /
</VirtualHost>"

  # restart the container for the vhost config to take effect
  container_restart default

  # check http connections on port 81
  run curl_client default -i http://$APP_NAME:81
  [[ "$output" =~  "405 Method Not Allowed" ]]
}
