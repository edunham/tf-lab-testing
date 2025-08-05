# Terraform 101 Racing Lab - Custom Development Container
# This Dockerfile ensures Terraform is properly installed and available

FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        wget \
        unzip \
        gnupg \
        software-properties-common \
        ca-certificates \
        lsb-release \
        jq \
        tree \
        htop

# Install Terraform using HashiCorp's official method
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh

# Verify installations
RUN terraform --version && gh --version

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Create terraform plugin cache directory with proper permissions
RUN mkdir -p /home/vscode/.terraform.d/plugin-cache && \
    chown -R vscode:vscode /home/vscode/.terraform.d && \
    chmod -R 755 /home/vscode/.terraform.d

# Set up terraform autocomplete for the vscode user
USER vscode
RUN terraform -install-autocomplete 2>/dev/null || true

# Add helpful aliases to bashrc
RUN echo "\n# Terraform Lab Aliases" >> ~/.bashrc \
    && echo "alias tf='terraform'" >> ~/.bashrc \
    && echo "alias tfi='terraform init'" >> ~/.bashrc \
    && echo "alias tfp='terraform plan'" >> ~/.bashrc \
    && echo "alias tfa='terraform apply'" >> ~/.bashrc \
    && echo "alias tfd='terraform destroy'" >> ~/.bashrc \
    && echo "alias tfv='terraform validate'" >> ~/.bashrc \
    && echo "alias tfs='terraform show'" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    && echo "# F1 Themed Aliases" >> ~/.bashrc \
    && echo "alias race='terraform apply'" >> ~/.bashrc \
    && echo "alias pitstop='terraform plan'" >> ~/.bashrc \
    && echo "alias checkered='terraform show'" >> ~/.bashrc \
    && echo "alias warmup='terraform validate'" >> ~/.bashrc

# Set environment variables
ENV TF_PLUGIN_CACHE_DIR=/home/vscode/.terraform.d/plugin-cache
ENV TF_CLI_ARGS="-no-color"
ENV TF_IN_AUTOMATION="true"

USER root