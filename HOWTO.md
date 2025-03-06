# Stack for hosted localor

1. Initial setup
 execute init script
    ```bash	
    export ADMIN_TOKEN=xxxx; bash ./init.sh
    ```

2. Network tools
This stack contains the reverse proxy and also portainer for stack monitoring and administration.
In folder `./01_network`
    ```bash
    cd 01_network
    ```
    2.1 Edit .env file and add domain name and email address for letsencrypt.
        NETWORK_NAME shall be the same name as used in init section.

    2.2 Edit dashboard_secrets.txt to add a user:password pair. The content should list name:hashed-password pairs.
        ```bash	
        echo $(htpasswd -nb user password) | sed -e s/\\$/\\$\\$/g
        ```
        or online solution : https://www.web2generators.com/apache-tools/htpasswd-generator

    2.3 Start the network stack

        ```bash
        docker-compose up -d
        ```
    
3. database
In this stack we will find the postgres database for integrator

    check env file for admin token, env name and networkname if needed
    for first initial run or upgrade
    ```bash
    docker compose -f 02_databae/compose.yaml --profile init up
    ```

    then it will be possible to simply
    ```bash
    docker compose up -d
    ```

4. ai-engine
In this stack we will find the Milvue stack
    for first initial execution
    ```bash	
    docker compose -f 03_ai-engine/compose.yaml --profile init up
    ```

    then it will be possible to simply run
    ```bash
    docker compose -f 03_ai-engine/compose.yaml --profile run up -d
    ```