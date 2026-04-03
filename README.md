<<<<<<< HEAD
# infra-platform-project
=======
# infra-platform


## DevOps Stack Overview

| Component           | Selection                    |
|---------------------|------------------------------|
| Pipeline Framework  | docker-multi-stage           |
| CI/CD Platform      | jenkins                 |
| Infrastructure      | aws-vpc-eks              |
| Deployment Strategy | blue-green             |
| Environments        | dev, stage, prod           |
| Observability       | prometheus-grafana      |
| Security Framework  | nist-csf           |

## Getting Started

```bash
# Setup the project
make setup

# Run locally
make run

# Deploy
make deploy
```

## Project Structure

```
infra-platform/
├── app/              # Application source code
├── ci/               # CI/CD pipeline configurations
├── infra/            # Infrastructure as Code
├── deploy/           # Deployment configurations
├── k8s/              # Kubernetes manifests
├── monitoring/       # Observability configs
├── security/         # Security policies & scanning
├── scripts/          # Utility scripts
├── docs/             # Documentation
└── tests/            # Test suites
```

## Environments

- **dev**
- **stage**
- **prod**

## License

MIT
>>>>>>> 9a70acd (initial commit)
