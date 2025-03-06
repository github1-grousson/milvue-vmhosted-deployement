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

### 3.2 Regular Operation

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

### 4.2 Regular Operation

After the initial setup, run the AI engine using the run profile:

```bash
docker compose -f 03_ai-engine/compose.yaml --profile run up -d
```

---

Follow these steps in sequence to ensure a smooth deployment of the Hosted Localor stack. If you encounter any issues, review your configuration settings and environment variables.
