# Hosted Localor Stack Setup

This guide details the steps required to set up the Hosted Localor stack, which includes the network tools, PostgreSQL database for the integrator, and the Milvue AI engine.

---

## 1. Initial Setup

Run the initialization script by executing the following command. Replace `xxxx` with your actual admin token.

```bash
export AUTHENTICATION_KEY=xxxx; export ENV_NAME=xxxx; export DOMAIN_NAME=xxxx; bash ./init.sh
```

---

## 2. Network Tools

This part of the stack provides the reverse proxy and Portainer for monitoring and administration. All configurations are located in the `./01_network` folder.

### 2.1 Navigate to the Network Directory

```bash
cd 01_network
```

### 2.2 Configure Environment Variables

- **Edit the `.env` file:**  
  Add your domain name and email address for Let's Encrypt. Ensure that `NETWORK_NAME` matches the name used during the initial setup.

- **Set Dashboard Credentials:**  
  Edit the `dashboard_secrets.txt` file to include a `username:hashed-password` pair. To generate the hashed password, run:

  ```bash
  echo $(htpasswd -nb user password) | sed -e s/\\$/\\$\\$/g
  ```

  Alternatively, use an online tool such as [HTPasswd Generator](https://www.web2generators.com/apache-tools/htpasswd-generator).

### 2.3 Start the Network Stack

Launch the network services using Docker Compose:

```bash
docker-compose up -d
```

---

## 3. Database

This stack provides the PostgreSQL database used by the integrator.

### 3.1 Initial Setup or Upgrade

Before the regular launch, verify the environment file for the admin token, environment name, and network name if needed, then run:

```bash
docker compose -f 02_database/compose.yaml --profile init up
```

### 3.2 Cleanup

Once the database is running, you can remove the initialization containers:

```bash	
docker compose -f 02_database/compose.yaml --profile init down
```

Or

```bash
docker rm -f $(docker ps -a --filter "name=alembic" -q)
docker rm -f $(docker ps -a --filter "name=admintoken" -q)
```

### 3.3 Regular Operation

Once the initial setup is complete, start the database stack with:

```bash
docker compose up -d
```

---

## 4. AI Engine

This component deploys the Milvue AI engine.

### 4.1 Initial Execution

For the first run, check the .env file and execute the initialization profile:

```bash
docker compose -f 03_ai-engine/compose.yaml --profile init up
```

### 4.2 Cleanup

Once the AI engine is running, you can remove the initialization container:

```bash
docker compose -f 03_ai_engine/compose.yaml --profile init down
```

Or

```bash
docker rm -f $(docker ps -a --filter "name=minio-client" -q)
docker rm -f $(docker ps -a --filter "name=models" -q)
```

### 4.3 Regular Operation

After the initial setup, run the AI engine using the run profile:

```bash
docker compose -f 03_ai-engine/compose.yaml --profile run up -d
```

### 4.4 Create a user

Once AI Engine is running, you can create a user using standard cURL or POSTMAN requests by using Admin API


---

Follow these steps in sequence to ensure a smooth deployment of the Hosted Localor stack. If you encounter any issues, review your configuration settings and environment variables.
