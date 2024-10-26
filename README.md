# azure_devops_agent

## Linux Azure DevOps Agent Docker Image

This dockerfile and start.sh is based on the [official documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux). With elements from <https://github.com/Azure/terraform-azurerm-aci-devops-agent> and <https://github.com/jaredfholgate/azure-devops-agent>.

## Build it

Within this image directory. Get [Docker Desktop](https://docs.docker.com/get-started/get-docker/) if currently missing.

```bash
docker build --tag "azp-agent:linux" --file "./dockerfile" --platform linux/amd64,linux/arm64 .
```

> Added `--platform` switch to build successfully on macOS.

## Test it

```bash
docker run --name "azp-agent-linux" \
  -e AZP_URL="azure_devops_instance" \
  -e AZP_TOKEN="token" \
  -e AZP_POOL="agent_pool_name" \
  -e AZP_AGENT_NAME="agent_name" \
  azp-agent:linux
```

For example:

```bash
docker run --name "azp-agent-linux" -e AZP_URL="https://dev.azure.com/RichardCheney" -e AZP_TOKEN="token_value" -e AZP_POOL="terraform" -e AZP_AGENT_NAME="Docker Agent - Linux" azp-agent:linux
```

|env var|description|
|---|---|
|AZP_URL|The URL of the Azure DevOps or Azure DevOps Server instance.|
|AZP_TOKEN|Personal Access Token with Agent Pools (read, manage) scope.|
|AZP_AGENT_NAME|Agent name (default value: the container hostname).|
|AZP_POOL|Agent pool name (default value: Default).|
|AZP_WORK|Work directory (default value: _work).|

## Push it

```bash
docker push YOUR_IMAGE_NAME:YOUR_IMAGE_TAG
```

## Push it to an Azure Container Registry

```bash
az acr build --registry my_acr --image "azp-agent:linux" --file "./dockerfile" .
```

This uses a collection of build agents in the cloud.
