# AWS Security Hardening and Optimization with Open-Source Tools

**Phase 1: Infrastructure Setup & Initial Tool Integration**
_Status: Work in Progress_

---

## Project Overview

This project focuses on hardening and monitoring AWS environments using a fully open-source, modular security stack. It leverages containerized and script-based tools for runtime security, vulnerability scanning, compliance auditing, and policy enforcement, all integrated into a centralized Wazuh dashboard. This setup will eventually be deployed with a Terraform configuration and a CICD pipeline.

---

## Phase 1 Objectives

- Provision a secure and controlled runtime environment inside a **private subnet**.
- Deploy foundational **Wazuh stack** components for centralized logging, alerting, and visualization.
- Integrate long-running open-source security services (e.g., Zeek, Falco, OPA).
- Set up a flexible ingestion pipeline via **Filebeat** to aggregate logs from both real-time services and periodic CLI tools.
- Prepare the VM environment for running additional auditing tools like **Trivy**, **Prowler**, and **Cloud Custodian** as scheduled jobs.

---

## Infrastructure Setup

### Virtual Machine

- A hardened **Linux VM** is provisioned in a **private subnet** of a secure VPC.
- **Port 443** is opened for HTTPS access via an NGINX reverse proxy (if needed).
- **VPC Endpoints** (3) are created to enable private communication with AWS services.
- An **IAM Role** with Systems Manager (**SSM**) and cross-account access permissions is attached to the VM, enabling:

  - Remote access via SSM Session Manager (no public SSH).
  - Read-only access to other AWS accounts for scanning/auditing purposes.

---

## Tooling Strategy

All tools reside under the `/opt/` directory and are categorized into **persistent services** and **CLI tools**, each integrated into the Wazuh pipeline differently:

### Service-Oriented Tools (Docker Compose)

Deployed as long-running containers with persistent volumes and network integration:

| Tool         | Purpose                                        |
| ------------ | ---------------------------------------------- |
| **Wazuh**    | Centralized SIEM (Manager, Indexer, Dashboard) |
| **Zeek**     | Network traffic analysis                       |
| **Falco**    | Runtime container security                     |
| **OPA**      | Policy evaluation engine                       |
| **Filebeat** | Log shipper (replaces Wazuh Agent)             |
| **NGINX**    | HTTPS reverse proxy (port 443)                 |

All logs are routed to Wazuh via Filebeat for processing, storage, and dashboard visualization.

---

### CLI-Based Tools (Scripted Jobs)

Installed natively under `/opt/` and invoked as part of scheduled scans or manual execution:

| Tool                | Usage                      | Notes                             |
| ------------------- | -------------------------- | --------------------------------- |
| **Trivy**           | Container/image scans      | CVE analysis, SBOMs               |
| **Prowler**         | AWS security auditing      | CIS, GDPR, HIPAA profiles         |
| **Cloud Custodian** | Policy-as-code enforcement | Scheduled cleanups, tagging, etc. |

Each CLI tool outputs JSON or log files to designated `/opt/<tool>/output` directories, which are mounted as log sources in Filebeat for ingestion into Wazuh.

---

## Directory Layout

```
/opt/
├── wazuh/                         # Docker Compose + Wazuh services
│   ├── docker-compose.yml
│   ├── config/
│   ├── volumes/
│   ├── scripts/                   # e.g., backup_wazuh.sh, health checks
│   └── logs/
│
├── trivy/                         # Trivy CLI scanner setup
│   ├── run_trivy.sh               # Script to run scans
│   ├── targets/                   # Image or repo scan targets
│   ├── output/                    # Scan result JSON or reports
│   └── config/                    # Optional config.yaml if needed
│
├── prowler/                       # AWS security audit
│   ├── run_prowler.sh
│   ├── reports/
│   ├── config/
│   └── logs/
│
├── custodian/                     # Cloud Custodian policies
│   ├── run_custodian.sh
│   ├── policies/                  # YAML policies
│   ├── output/
│   └── logs/
│
└── scripts/                       # Optional: shared cronjobs or orchestrators
    └── run_all_audits.sh         # Runs all CLI tools on schedule

---

## Ingestion & Monitoring Strategy

- **Filebeat** acts as the central log collector and forwarder.
- All service and CLI tool logs are standardized into JSON or plain text format.
- Logs are shipped to **Wazuh Indexer** for indexing and visualized in the **Wazuh Dashboard**.
- This architecture removes the need for individual agents per tool.

---

## Status

> 💠 _Phase 1 is a work in progress._

- Wazuh stack is deployed and functional.
- Zeek, OPA, and Falco services integrated via Docker Compose.
- Filebeat shipping logs to Wazuh Indexer.
- CLI tool scaffolding and basic scripts are in place.

---

## Next Steps (Phase 2 Preview)

- Configure recurring scan schedules for CLI tools.
- Tune Wazuh decoders/rules to align with Zeek and Falco log structures.
- Harden container security using OPA policies.
- Add alert routing (Slack, email, etc.).
- Export key dashboards and reports.
```
