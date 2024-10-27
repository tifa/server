# server 💾

Set up a new instance.


## One-time bootstrap

Create an SSH key pair and it to the SSH authentication agent.

```sh
ssh-keygen -t ed25519 -C laptop
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


## Automated deployment

Automate deployment of projects to the remote instance via a bare git
repository.

Create a new key pair without a passphrase.

```sh
ssh-keygen -t ed25519 -C github
```

Run the interactive setup. This creates a bare git repository at
`/srv/git/<REPO>` with a working tree at `/srv/www/<REPO>`.

```sh
make git
```

Then add a Github Actions workflow for deployment. See example at
[./examples/deploy.yaml](./examples/deploy.yaml).
