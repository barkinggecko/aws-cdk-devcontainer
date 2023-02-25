# aws-cdk-devcontainer

'devcontainers' save huge amounts of time when onboarding new developers to a project or spinning up projects you may not have worked with for a while. A devcontainer should provide a pre-configured environment for building, deploying and in many cases running a project.

This devcontainer configuration provides an Ubuntu-based environment pre-configured with CDK and AWS CLI v2. It even mounts your `~/.aws` directory within the container so you can re-use your existing AWS credentials.

## Dependencies

* You require a functional Docker installation on your host machine. 
* `devcontainer.json` currently references the `source` directories for mounts as if they were on a Linux file system. Edit the value of `source` accordingly if you are on another platform.

## Features

* The devcontainer supports Python and Node/Typescript CDKs.
* The devcontainer will mount your project directory as a volume: `/workspaces` when running in VS Code and `/opt/app` when running standalone. 
* The devcontainer will mount your local `~/.aws` directory as a volume. This very conveniently means that when operating within the container, you will be able to access AWS CLI credentials from your host machine.
* The devcontainer provides auto-completion for AWS CLI.
* The devcontainer runs as user `devcontainer` with UID 1000 and GID 1000. This provides added security over typical container configurations that run as root. Given most users (on Ubuntu at least) run with UID 1000 and GID 1000, then files created within the container in volumes that are accessible outside the container (such as the project directory) should be editable by non-root users outside the container. This is a convenience that, for example, should allow users to perform git operations both inside and outside the container on the project directory.
* The devcontainer provides `git-remote-codecommit` for those using AWS CodeCommit repositories.
* The devcontainer supports AWS single sign-on via `yawsso`.  

## Launch Instructions (i.e. Running the Container)

You can launch this devcontainer within VS Code or standalone.

### VS Code devcontainer

* Copy the `.devcontainer` directory of this repository to the root of your new project. 
* If your Docker host is a *nix, edit `USER_UID` and `USER_GID` in the `Dockerfile` to represent the user ID and group ID of the user you run the container as on your Docker host.
* If VS Code does not prompt you to open your project in the container, you can select 'Reopen in container' from the VS Code Remote menu.

### Standalone devcontainer

* Change directory to the `.devcontainer` directory of this repository
* Open `Dockerfile` and uncomment the `VOLUME` and `WORKDIR` commands at the end of the file that will mount your project inside containers build from this image.
* Build the container ...

```bash
docker build -t aws-cdk-devcontainer .
```

* If you have not already created a directory for your new project, do so ...

```bash 
mkdir <path to project dir>
```

* Change directory to your project directory and then run the container ...

```bash
cd <path to project dir>
docker run -it --rm -v ~/.aws:/home/devcontainer/.aws -v $(pwd):/opt/app aws-cdk-devcontainer
```

## Usage Instructions (i.e. Using the Container to Prepare a CDK app)

### For Python CDK

* Open a shell within the container.
* Run `aws sts get-caller-identity --profile <profile name>` to test your AWS credentials and login or resolve as necessary.
* Change directory to your project directory (`/workspaces/<project name>` when running in VS Code or `/opt/app/<project name>` when running standalone).
* Execute the following ...

```bash
mkdir app
cd app
cdk init app --language python
echo "alias activate=\". ./.venv/bin/activate\"" >> ~/.bashrc
activate
python -m pip install -r requirements.txt
cdk bootstrap --profile <profile name>
cdk deploy --profile <profile name>
```

### For Typescript CDK

* Open a shell within the container.
* Run `aws sts get-caller-identity --profile <profile name>` to test your AWS credentials and login or resolve as necessary.
* Change directory to your project directory (`/workspaces/<project name>` when running in VS Code or `/opt/app/<project name>` when running standalone).
* Execute the following ...

```bash
mkdir app
cd app
cdk init app --language typescript
cdk bootstrap --profile <profile name>
cdk deploy --profile <profile name>
```