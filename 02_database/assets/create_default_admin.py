import os
import psycopg2
from pprint import pprint

def main():
    # Get environment variables with defaults
    admin_token = os.environ.get('ADMIN_TOKEN', '4ba43ac3-80c6-4990-84e4-b02a7f054e9a')
    admin_name = os.environ.get('ADMIN_NAME', 'localor')
    host = os.environ.get('POSTGRES_HOST', 'postgres')
    user = os.environ.get('POSTGRES_USER', 'postgres')
    password = os.environ.get('POSTGRES_PASSWORD', 'postgres')
    port = os.environ.get('POSTGRES_PORT', '5432')

    # print(f"Connecting to PostgreSQL at {host}:{port} with database integrator as user {user}")

    connection = None

    try:
        # Connect to PostgreSQL
        connection = psycopg2.connect(
            host=host,
            dbname='integrator',
            user=user,
            password=password,
            port=port
        )
        connection.autocommit = True  # Enable auto-commit mode

        with connection.cursor() as cursor:
            # Check if an entry with the given token exists in the admins table
            cursor.execute("SELECT COUNT(*) FROM admins WHERE token = %s;", (admin_token,))
            count = cursor.fetchone()[0]

            if count == 0:
                # If no entry exists, insert a new record with id, token, and name 'default'
                cursor.execute(
                    "INSERT INTO admins (token, name) VALUES (%s, %s);",
                    (admin_token, "default")
                )
                print(f"Inserted admin with token: {admin_token}")
            else:
                print(f"Admin with token {admin_token} already exists.")

    except Exception as e:
        pprint(f"An error occurred: {e}")
    finally:
        if connection:
            connection.close()

if __name__ == '__main__':
    main()
