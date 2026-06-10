# github-self-hosted-runners-template

> These repositories helped us create this repository:
> 1. [Groupe-3D/self-hosted-runner](https://github.com/Groupe-3D/self-hosted-runner)

## Prerequisites

1. Install Docker Desktop (Windows, macOS) or Docker Engine (Linux)
>Note: It seems like there is Docker Engine for Linux (https://docs.docker.com/desktop/setup/install/linux/ubuntu/).

> The commands below are for Ubuntu and macOS
## Configuring runners

1. Open repo folder
```
cd github-self-hosted-runners-template
```
2. Copy file with env variables and open it
```
cp .env.example .env
nano .env
```
3. Get runner registration token from GitHub -> TourmalineCore -> Settings -> Actions -> Runners -> [New runner](https://github.com/organizations/TourmalineCore/settings/actions/runners/new)
4. Paste the copied token instead of `<TO_BE_MODIFIED!!!>`

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