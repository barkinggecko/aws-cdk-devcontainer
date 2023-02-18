# aws-cdk-devcontainer

'devcontainers' save huge amounts of time when onboarding new developers to a project or spinning up projects you may not have worked with for a while. A devcontainer should provide a pre-configured environment for building, deploying and in many cases running a project.

This devcontainer configuration provides an Ubuntu-based environment pre-configured with CDK and AWS CLI v2. It even mounts your `~/.aws` directory within the container so you can re-use your existing AWS credentials.

## Dependencies

* You require a functional Docker installation on your host machine. 
* `devcontainer.json` currently references the `source` directories for mounts as if they were on a Linux file system. Edit the value of `source` accordingly if you are on another platform.

## Features

* The container runs as user `devcontainer` with UID 1000 and GID 1000. This provides added security over typical container configurations that run as root. Given most users (on Ubuntu at least) run with UID 1000 and GID 1000, then files created within the container in volumes that are accessible outside the container (such as the project directory) should be editable by non-root users outside the container. This is a convenience that, for example, should allow users to perform git operations both inside and outside the container on the project directory.
* The devcontainer will mount your project directory as a volume: `/workspaces` when running in VS Code and `/opt/app` when running standalone. 
* The devcontainer will mount your local `~/.aws` directory as a volume. This very conveniently means that when operating within the container, you will be able to access AWS CLI credentials from your host machine.

## Instructions 

You can launch this devcontainer within VS Code or standalone.

### VS Code devcontainer

* Copy the `.devcontainer` directory to the root of your new project. 
* If your Docker host is a *nix, edit `USER_UID` and `USER_GID` in the `Dockerfile` to represent the user ID and group ID of the user you run the container as.
* If VS Code does not prompt you to open your project in the container, you can select 'Reopen in container' from the VS Code Remote menu.

### Standalone devcontainer

First, uncomment the lines at the end of the Dockerfile that enable the volume for the project directory.

Then build the container ...

```bash
docker build -t aws-cdk-devcontainer .
```

You can then run the container ...

```
docker run -it --rm -v ~/.aws:/home/devcontainer/.aws -v $(pwd):/opt/app aws-cdk-devcontainer
```