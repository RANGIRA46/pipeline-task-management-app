# Ansible Configuration Management

Automated server configuration and application deployment

## Prerequisites

- Ansible (>= 2.14)
- Python 3.10+
- Azure CLI
- SSH access to target servers

## Setup

```bash
# Install Ansible
pip install ansible

# Install required collections
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install community.docker

# Install Azure dependencies
pip install -r https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
```

## Directory Structure

```
ansible/
├── playbooks/          # Playbook files
│   └── setup-server.yml
├── roles/              # Ansible roles
│   ├── docker/        # Docker installation
│   ├── security/      # Security hardening
│   ├── monitoring/    # Monitoring setup
│   └── app-deploy/    # Application deployment
├── inventory/          # Inventory files
│   ├── azure_rm.yml   # Dynamic Azure inventory
│   └── hosts.example  # Static inventory example
└── ansible.cfg         # Ansible configuration
```

## Roles

### docker
Installs and configures Docker and Docker Compose

### security
- Configures UFW firewall
- Sets up Fail2ban
- Enables automatic security updates
- Hardens system settings

### monitoring
- Installs monitoring tools
- Configures system status scripts

### app-deploy
- Logs into ACR
- Pulls Docker images
- Deploys application
- Verifies deployment

## Usage

### Test Connection
```bash
ansible all -m ping -i inventory/azure_rm.yml
```

### Run Playbook (Check Mode)
```bash
ansible-playbook playbooks/setup-server.yml \
  -i inventory/azure_rm.yml \
  --check
```

### Run Playbook
```bash
ansible-playbook playbooks/setup-server.yml \
  -i inventory/azure_rm.yml
```

### Run Specific Role
```bash
ansible-playbook playbooks/setup-server.yml \
  -i inventory/azure_rm.yml \
  --tags docker
```

## Environment Variables

Required environment variables:
```bash
export ACR_NAME="your-acr-name"
export ACR_LOGIN_SERVER="your-acr.azurecr.io"
export ARM_CLIENT_ID="azure-client-id"
export ARM_CLIENT_SECRET="azure-client-secret"
export ARM_TENANT_ID="azure-tenant-id"
export IMAGE_TAG="latest"
export DB_USER="dbuser"
export DB_PASSWORD="dbpassword"
export DB_NAME="taskmanager"
```

## Inventory

### Dynamic Azure Inventory
Uses `azure_rm.yml` to automatically discover Azure VMs

### Static Inventory
Create `inventory/hosts`:
```ini
[app_servers]
azure-vm ansible_host=<VM_IP> ansible_user=azureuser
```
