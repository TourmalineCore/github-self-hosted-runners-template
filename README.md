# github-self-hosted-runners-template

> These repositories helped us create this repository:
> 1. [Groupe-3D/self-hosted-runner](https://github.com/Groupe-3D/self-hosted-runner)

## Prerequisites

1. Install Docker Desktop (Windows, macOS) or Docker Engine (Linux)

## Configuring runners

### Environment variables 

1. Open `github-self-hosted-runners-template` repo folder

2. Copy .env.example file with env variables as .env

3. Get runner registration token from GitHub -> <ORGANIZATION_NAME> -> Settings -> Actions -> Runners -> New runner

Or use this link: https://github.com/organizations/<ORGANIZATION_NAME>/settings/actions/runners/new
>Change `<ORGANIZATION_NAME>` to your organization name

4. Open .env file

5. Paste the copied token instead of `<TO_BE_MODIFIED!!!>`. It can be found in the `Configure` section

6. Change TourmalineCore to your organization name

Additionally, you can specify the runners group to which the runner will be added using the `RUNNER_GROUP` variable. You can also specify labels that can be used to select the runner in the workflow using the `LABELS` variable.

### Replication and resources
The number of replicas, resources limits, and reservations can be modified in the docker-compose.yml file.
```yaml
    deploy:
      mode: replicated
      replicas: 2
      resources:
       limits:
        cpus: '2'
        memory: 2G
       reservations:
        cpus: '0.1'
        memory: 256M
``` 

## Run runners

To run runners execute the following command:
```bash
docker compose up -d --build
```

## Troubleshooting on Mac

### 1. Runner is unavailable when the Mac screen turns off
This issue occurs because the Mac and its apps go into sleep mode when the screen turns off due to inactivity. To fix this, enable the following setting:
> `System Settings -> Energy -> Prevent automatic sleeping when the display is off`

### 2. Once the power goes out, you need to go to the Mac and turn it on manually
To make your Mac enable when powered on, enable the following setting:
> `System Settings -> Energy -> Start up automatically after power failure`

### 3. Docker and runner won't start until a password is entered
Yes, on a Mac, apps only launch after you enter your password. To avoid entering a password and automatically log in when the Mac starts, enable the following setting:
> `System Settings -> Users & Groups -> Automatically log in as`