# drivah-buildkite-plugin
[![GitHub Release](https://img.shields.io/github/release/jmpavlec/drivah-buildkite-plugin.svg)](https://github.com/jmpavlec/drivah-buildkite-plugin/releases)

Buildkite plugin to wrap around [drivah](https://github.com/elastic/drivah) for building, pushing, and tagging docker images

## Using the plugin

```yaml
steps:
  - plugins:
      - jmpavlec/drivah#v0.0.1:
          dockerfile_path: cloud-ui
          docker_login_username: cloud-ci
          vault_secret_path: secret/ci/elastic-cloud/docker-registry
          pre_build_commands:
            - "echo testing"
            - "echo testing2"
    # Specifying the agent isn't strictly necessary, but you will need an agent image with drivah installed
    agents:
      image: docker.elastic.co/ci-agent-images/drivah:0.16.0
      ephemeralStorage: 10G
      memory: 4G
```

Refer to [drivah releases](https://github.com/elastic/drivah/releases) for the agent image version.

### Plugin parameters
Refer to the [plugin.yml](plugin.yml) for all available parameters

Note: The `dockerfile_path` path should point at the directory that has the `Dockerfile` and the `drivah.toml`. Refer to
the [drivah documentation](https://drivah.elastic.dev/image_configuration_file.html) for more information about the
image configuration file(s).

`docker_login_username` and `vault_secret_path` will likely vary based on the repository you are running the Buildkite 
ci pipelines from.


## Developing the plugin

Buildkite guide for writing plugins: https://buildkite.com/docs/plugins/writing

### Validating plugin.yml
Uses a docker-compose file that runs the [buildkite-plugin-linter](https://github.com/buildkite-plugins/buildkite-plugin-linter)

```shell
docker-compose run --rm lint
```

### Testing your code
Uses a docker-compose file that runs the [buildkite-plugin-tester](https://github.com/buildkite-plugins/buildkite-plugin-tester)

```shell
docker-compose run --rm tests
```


### Testing on a branch
You can test changes to this plugin from a branch using the following yaml in your buildkite pipeline.yml.
`BUILDKITE_PLUGINS_ALWAYS_CLONE_FRESH` is important as it will clone fresh from the repo to get any new commits
you may have added.

```yaml
steps:
  - plugins:
    - jmpavlec/drivah#dev-branch:
        dockerfile_path: cloud-ui
          docker_login_username: cloud-ci
          vault_secret_path: secret/ci/elastic-cloud/docker-registry
    env:
      BUILDKITE_PLUGINS_ALWAYS_CLONE_FRESH: "true"
    agents:
      image: docker.elastic.co/ci-agent-images/drivah:0.16.0
      ephemeralStorage: 10G
      memory: 4G
```
## Releasing the plugin
TODO Github Releases with a tag...