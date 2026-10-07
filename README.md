[![CI](https://github.com/the-jodingo/infra-platform-project/actions/workflows/ci.yml/badge.svg)](https://github.com/the-jodingo/infra-platform-project/actions/workflows/ci.yml)
[![Terraform](https://img.shields.io/badge/Terraform-AWS-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Jenkins](https://img.shields.io/badge/CI-Jenkins-D24939?logo=jenkins&logoColor=white)](ci/Jenkinsfile)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

# Infra Platform Project

A reference DevOps platform: a small containerised service with infrastructure
as code, a CI pipeline, monitoring, and a security policy. Built to demonstrate
the full path from commit to a running, observable, deployed service.

## Table of contents

- [What's here](#whats-here)
- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Usage](#usage)
- [Configuration](#configuration)
- [Infrastructure](#infrastructure)
- [Deployment](#deployment)
- [Observability](#observability)
- [Testing and CI](#testing-and-ci)
- [Project structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## What's here

| Area | Implementation |
|---|---|
| Application | Python 3.12, standard-library `http.server` — no framework, no runtime deps |
| Infrastructure | Terraform: VPC, three private subnets across AZs, EKS cluster |
| CI | Jenkins pipeline (`ci/Jenkinsfile`) |
| Deployment | Blue-green (`scripts/deploy.sh`) |
| Monitoring | Prometheus scrape config, alert rules, Grafana dashboard |
| Security | NIST CSF-aligned policy in `security/policies/` |

## Requirements

| Tool | Version | Needed for |
|---|---|---|
| Python | 3.11+ | Running the service and tests |
| Terraform | 1.5+ | Provisioning infrastructure |
| kubectl | 1.28+ | Deploying |
| Docker | any recent | Container builds |

## Quick start

```bash
git clone https://github.com/the-jodingo/infra-platform-project.git
cd infra-platform-project
make setup     # create venv and install dependencies
make run       # start the service on :8080
```

Then, in another terminal:

```bash
curl localhost:8080/health
# {"status": "healthy", "service": "infra-platform"}
```

## Usage

| Command | Description |
|---|---|
| `make help` | List all targets |
| `make setup` | Create the virtualenv and install dependencies |
| `make run` | Run the service locally |
| `make test` | Run the test suite |
| `make lint` | Run flake8 |
| `make deploy` | Apply the blue-green manifests (needs kubectl) |
| `make clean` | Remove build artefacts |

### Endpoints

| Method | Path | Response |
|---|---|---|
| `GET` | `/health` | `{"status": "healthy", "service": "infra-platform"}` |
| `GET` | `/` | `infra-platform running in <env>` |
| any | anything else | `404` |

## Configuration

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8080` | HTTP listen port |
| `ENVIRONMENT` | `development` | Environment name included in responses |

## Infrastructure

`infrastructure/vpc.tf` provisions:

- a VPC (`10.0.0.0/16`) with DNS hostnames and support enabled
- three private subnets, one per availability zone
- an EKS cluster (v1.28) attached to those subnets

```bash
cd infrastructure
terraform init
terraform fmt -recursive
terraform validate
terraform plan  -var="environment=dev"
terraform apply -var="environment=dev"
```

> `terraform destroy` tears down everything including the EKS cluster.
> Confirm the workspace before running it.

## Deployment

```bash
./scripts/deploy.sh dev
```

The script validates that `deployments/blue-green.yaml` exists and that
`kubectl` is on `PATH` before applying anything.

> **Not committed yet:** `deployments/blue-green.yaml`. Add your blue/green
> Kubernetes manifests there before running a real deploy.

## Observability

| File | Purpose |
|---|---|
| `monitoring/metrics/prometheus.yml` | Scrape configuration |
| `monitoring/alerts/rules.yml` | Alert rules |
| `monitoring/dashboards/overview.json` | Grafana dashboard — import directly |

## Testing and CI

```bash
make test      # pytest
make lint      # flake8, max line length 120
```

GitHub Actions runs on every push and pull request:

- **Lint & test** — flake8 then pytest on Python 3.12
- **Terraform validate** — `terraform fmt -check`, `init -backend=false`, `validate`

## Project structure

```
infra-platform-project/
├── app/sample-app/         # main.py, requirements.txt
├── ci/                     # Jenkinsfile
├── infrastructure/         # vpc.tf, modules/networking/main.tf
├── monitoring/             # prometheus.yml, alerts/, dashboards/
├── scripts/                # setup.sh, deploy.sh
├── security/policies/      # security-policy.md
├── tests/                  # test_app.py
└── Makefile
```

## Contributing

1. Branch from `master`.
2. Make your change, add or update tests.
3. Run `make lint && make test`.
4. Open a pull request describing the change and how you verified it.

## License

[MIT](LICENSE) © Joash Odingo
