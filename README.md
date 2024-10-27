# server 💾

Set up a new instance.


## One-time bootstrap

Create an SSH key pair and it to the SSH authentication agent.

```sh
ssh-keygen -t ed25519 -C "email@example.com"
ssh-add ~/.ssh/path/to/key
```

Run the interactive setup.

```sh
make bootstrap
```

- Create a new user
- Change the SSH port
- Change the root password
- Disable root login

Add this server to the SSH configs `~/.ssh/config`.

```txt
Host <HOST>
  HostName <HOSTNAME>
  User <USER>
  Port <PORT>
  IdentityFile ~/.ssh/path/to/key
```


## Idempotent provisioning steps

```sh
make provision
```

- Install Docker


## Development

To smoke test against a server, bring up a Docker container. TODO: Switch to
Vagrant once Vagrant and VirtualBox are fully supported on Apple Silicon Macs.

```sh
make server
```

Set the `ENVIRONMENT` variable to `test` before running any commands.

```sh
export ENVIRONMENT=test  # default: production
```


## Next steps

See the [service](https://github.com/tifa/service) repo for setting up CI/CD for
other repositories.
