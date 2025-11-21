@echo off
REM Wrapper script to run Terraform via Docker
REM Usage: terraform-docker.bat [command]

REM Get the absolute path to the terraform directory (relative to this script)
set "SCRIPT_DIR=%~dp0"
set "TF_DIR=%SCRIPT_DIR%terraform"

REM Run Terraform inside Docker, mounting the terraform directory
REM We map the .terraformrc file and tell Terraform where to find it
docker run --rm -it ^
  -v "%TF_DIR%:/workspace" ^
  -w /workspace ^
  -e TF_CLI_CONFIG_FILE=/workspace/.terraformrc ^
  hashicorp/terraform:latest %*
