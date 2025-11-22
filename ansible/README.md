# Ansible Configuration for Task Manager Deployment

This directory contains Ansible playbooks and configuration for automated deployment.

## Structure

```
ansible/
├── ansible.cfg           # Ansible configuration
├── inventory/            # Inventory files (created dynamically by CI/CD)
├── playbooks/
│   ├── setup-server.yml  # Full server setup (first-time)
│   └── update-app.yml    # Quick app updates
└── README.md
```

## Playbooks

### setup-server.yml
Full server configuration including:
- Docker installation
- ACR authentication
- Application deployment
- Firewall configuration
- Health checks

**Usage:**
```bash
ansible-playbook playbooks/setup-server.yml -i inventory/hosts -v
```

### update-app.yml
Quick application update (assumes server is already configured):
- Pull latest images from ACR
- Recreate containers
- Verify health

**Usage:**
```bash
ansible-playbook playbooks/update-app.yml -i inventory/hosts
```

## Environment Variables

The playbooks expect these environment variables:

- `ACR_LOGIN_SERVER` - Azure Container Registry URL
- `ARM_CLIENT_ID` - Azure Service Principal client ID
- `ARM_CLIENT_SECRET` - Azure Service Principal secret
- `ARM_TENANT_ID` - Azure tenant ID
- `IMAGE_TAG` - Docker image tag to deploy
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password
- `DB_NAME` - Database name

## Inventory

The inventory file is created dynamically by the CI/CD pipeline:

```ini
[app_servers]
azure-vm ansible_host=YOUR_VM_IP ansible_user=azureuser
```

## Local Testing

To test locally:

1. Create inventory file:
```bash
cat > inventory/hosts <<EOF
[app_servers]
test-server ansible_host=YOUR_IP ansible_user=azureuser
EOF
```

2. Set environment variables:
```bash
export ACR_LOGIN_SERVER=your-acr.azurecr.io
export ARM_CLIENT_ID=your-client-id
export ARM_CLIENT_SECRET=your-secret
export IMAGE_TAG=latest
export DB_USER=devops
export DB_PASSWORD=devops123
export DB_NAME=devops_app
```

3. Run playbook:
```bash
ansible-playbook playbooks/setup-server.yml -i inventory/hosts -v
```

## CI/CD Integration

The CD pipeline automatically:
1. Creates inventory with VM IP
2. Sets required environment variables
3. Runs `setup-server.yml` playbook
4. Verifies deployment

## Troubleshooting

### SSH Issues
```bash
# Add VM to known hosts
ssh-keyscan -H YOUR_VM_IP >> ~/.ssh/known_hosts
```

### Docker Login Issues
```bash
# Test ACR login
az acr login --name YOUR_ACR_NAME
```

### Connectivity Issues
```bash
# Test Ansible connection
ansible app_servers -i inventory/hosts -m ping
```

### View Logs
```bash
# SSH into server
ssh azureuser@YOUR_VM_IP

# Check containers
docker ps

# View logs
docker logs taskmanager-backend
docker logs taskmanager-frontend
docker logs taskmanager-db
```
