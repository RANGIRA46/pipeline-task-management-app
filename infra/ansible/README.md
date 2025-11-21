# Ansible Configuration Management

This directory contains Ansible playbooks and roles for configuring and deploying the Task Management application to Azure VMs.

## 📁 Structure

```
ansible/
├── inventory/
│   ├── azure.yml           # Dynamic Azure inventory
│   └── hosts               # Static inventory (for testing)
├── playbooks/
│   ├── setup-vm.yml        # Initial VM setup
│   ├── deploy-app.yml      # Application deployment
│   ├── security.yml        # Security hardening
│   └── update.yml          # System updates
├── roles/
│   ├── common/             # Common system configuration
│   ├── docker/             # Docker installation
│   ├── app/                # Application deployment
│   └── monitoring/         # Monitoring setup
└── ansible.cfg             # Ansible configuration
```

## 🚀 Quick Start

### Prerequisites
```bash
# Install Ansible
pip install ansible

# Install Azure collection
ansible-galaxy collection install azure.azcollection
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
```

### Run Playbooks

#### 1. Initial VM Setup
```bash
ansible-playbook -i inventory/azure.yml playbooks/setup-vm.yml
```

#### 2. Deploy Application
```bash
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml
```

#### 3. Security Hardening
```bash
ansible-playbook -i inventory/azure.yml playbooks/security.yml
```

## 📝 Inventory Configuration

### Azure Dynamic Inventory
Edit `inventory/azure.yml` with your Azure details:

```yaml
plugin: azure.azcollection.azure_rm
auth_source: cli  # or 'msi', 'env'
include_vm_resource_groups:
  - devopspipeline-dev-rg
keyed_groups:
  - key: tags.environment
    prefix: env
```

### Verify Inventory
```bash
ansible-inventory -i inventory/azure.yml --list
```

## 🔐 Authentication

### Option 1: Azure CLI (Recommended for local)
```bash
az login
```

### Option 2: Environment Variables
```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_CLIENT_ID="your-client-id"
export AZURE_SECRET="your-client-secret"
export AZURE_TENANT="your-tenant-id"
```

### Option 3: Service Principal File
Create `~/.azure/credentials`:
```ini
[default]
subscription_id=your-subscription-id
client_id=your-client-id
secret=your-client-secret
tenant=your-tenant-id
```

## 📚 Playbook Details

### setup-vm.yml
- Updates system packages
- Installs Docker & Docker Compose
- Configures firewall (UFW)
- Sets up swap space
- Creates application user
- Configures SSH hardening

### deploy-app.yml
- Pulls Docker images from ACR
- Deploys docker-compose stack
- Configures environment variables
- Sets up systemd services
- Runs database migrations

### security.yml
- Configures fail2ban
- Enables automatic security updates
- Hardens SSH configuration
- Sets up firewall rules
- Configures audit logging

## 🧪 Testing Locally

Use the static inventory for local testing:

```bash
ansible-playbook -i inventory/hosts playbooks/setup-vm.yml --check
```

## 🔧 Variables

### Group Variables (`group_vars/all.yml`)
```yaml
app_user: taskmanager
app_dir: /opt/taskmanager
docker_compose_version: "2.23.0"
acr_name: "your-acr-name"
acr_login_server: "{{ acr_name }}.azurecr.io"
```

### Environment-Specific (`group_vars/production.yml`)
```yaml
environment: production
app_domain: taskmanager.yourdomain.com
enable_ssl: true
```

## 📊 Monitoring Deployment

```bash
# Check playbook syntax
ansible-playbook playbooks/deploy-app.yml --syntax-check

# Dry run (check mode)
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml --check

# Run with verbose output
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml -vv

# Run specific tags
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml --tags docker
```

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection timeout | Verify SSH key and NSG rules allow port 22 |
| Permission denied | Ensure SSH key has correct permissions (600) |
| Docker not found | Run setup-vm.yml first |
| ACR authentication failed | Login to ACR: `az acr login --name <acr_name>` |

## 📖 Best Practices

1. **Use Vault for Secrets**: Encrypt sensitive data with `ansible-vault`
   ```bash
   ansible-vault encrypt group_vars/production.yml
   ```

2. **Use Tags**: Tag tasks for selective execution
   ```yaml
   - name: Install Docker
     tags: [docker, setup]
   ```

3. **Idempotency**: Ensure playbooks can run multiple times safely

4. **Testing**: Always run with `--check` first

## 🏷️ Example Commands

```bash
# Deploy to production
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml -e "environment=production"

# Update specific servers
ansible-playbook -i inventory/azure.yml playbooks/update.yml --limit webservers

# Run with extra variables
ansible-playbook -i inventory/azure.yml playbooks/deploy-app.yml -e "app_version=1.2.0"
```
