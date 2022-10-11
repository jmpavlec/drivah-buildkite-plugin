#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following line to debug stub failures
 export CD_STUB_DEBUG=/dev/tty
 export DRIVAH_STUB_DEBUG=/dev/tty
 export BUILDKITE_COMMIT=aaabbbccceee

@test "should fail when required properties are not included" {
  export BUILDKITE_PLUGIN_DRIVAH_DOCKERFILE_PATH=""
  export BUILDKITE_PLUGIN_DRIVAH_VAULT_SECRET_PATH=""
  export BUILDKITE_PLUGIN_DRIVAH_DOCKER_LOGIN_USERNAME=""

  run "$PWD/hooks/command"

  assert_failure
  assert_output --partial "'dockerfile_path' property is required"
  assert_output --partial "'docker_login_username' property is required"
  assert_output --partial "'vault_secret_path' property is required"
}

#WIP test, stubs not working
@test "should attempt to build image with required properties and defaults" {
  export BUILDKITE_PLUGIN_DRIVAH_DOCKERFILE_PATH="tests/fakedir"
  export BUILDKITE_PLUGIN_DRIVAH_DOCKER_LOGIN_USERNAME="testuser"
  export BUILDKITE_PLUGIN_DRIVAH_VAULT_SECRET_PATH="vault-path"
  #export BUILDKITE_PLUGIN_DRIVAH_BUILD_ONLY="true"
  #export BUILDKITE_PLUGIN_DRIVAH_INCLUDE_SUB_DIRECTORIES="true"
  export VAULT_TOKEN=abc123

  stub vault \
    "read -field password vault-path : echo TESTING"
  stub cd "tests/fakedir"

  stub buildah \
    "login -u cloudci --password-stdin docker.elastic.co"

  stub drivah \
    "--version" \
    "build -t myAppName:aaabbbc . --build-arg my-arg=custom-arg"

  run bash -c "$PWD/hooks/command"

  assert_success
  assert_output --partial "Reading plugin parameters"
  assert_output --partial "logging in in via credentials found in vault-path"
  assert_output --partial "Building image in directory tests/fakedir"
  assert_output --partial "Building image with params --changed-since=HEAD^ --push --no-subdir"

  #unstub cd
  #unstub buildah
  #unstub drivah
}

@test "should attempt to build image with required properties and overwriting defaults" {
  export BUILDKITE_PLUGIN_DRIVAH_DOCKERFILE_PATH="tests/fakedir"
  export BUILDKITE_PLUGIN_DRIVAH_DOCKER_LOGIN_USERNAME="testuser"
  export BUILDKITE_PLUGIN_DRIVAH_VAULT_SECRET_PATH="vault-path"
  export BUILDKITE_PLUGIN_DRIVAH_BUILD_ONLY="true"
  export BUILDKITE_PLUGIN_DRIVAH_INCLUDE_SUB_DIRECTORIES="true"
  export VAULT_TOKEN=abc123

  stub vault \
    "read -field password vault-path : echo TESTING"
  stub cd "tests/fakedir"

  stub buildah \
    "login -u cloudci --password-stdin docker.elastic.co"

  stub drivah \
    "--version" \
    "build -t myAppName:aaabbbc . --build-arg my-arg=custom-arg"

  run bash -c "$PWD/hooks/command"

  assert_success
  assert_output --partial "Reading plugin parameters"
  assert_output --partial "logging in in via credentials found in vault-path"
  assert_output --partial "Building image in directory tests/fakedir"
  assert_output --partial "Building image with params --changed-since=HEAD^"

  #unstub cd
  #unstub buildah
  #unstub drivah
}
