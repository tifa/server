# server 💾

Set up a new instance.


## Configuration

Copy the `.env` template and configure the application.

```sh
cp .env.template .env
```


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


## Remote repositories

Deploy projects to the remote instance via a bare git repository.

Create a new key pair without a passphrase.

```sh
ssh-keygen -t ed25519 -C github -N ""
```

Run the interactive setup. This creates a bare git repository at
`/srv/git/<REPO>` with a working tree at `/srv/www/<REPO>`.

```sh
make git
```

### Deploy from GitHub

Then add a Github Actions workflow for deployment. See example at
[./examples/deploy.yaml](./examples/deploy.yaml). The following secrets will need to be created in the repo:

| Secret | Description |
| --- | --- |
| `SSH_PRIVATE_KEY` | Contents of the SSH private key |
| `REMOTE_HOST` | DNS name or IP address of the remote host |
| `REMOTE_USER` | SSH user |
| `REMOTE_PORT` | SSH port |


### Deploy from local

Add to git remotes:

```sh
git remote add <REPO_NAME> ssh://<REMOTE_USER>@<REMOTE_HOST>:<REMOTE_PORT>>/srv/git/<REPO_NAME>.git
```
