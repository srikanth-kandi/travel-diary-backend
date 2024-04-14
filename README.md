# Travel Diary Backend

### Database Schema

Create a PostgreSQL Database with name of your choice and run the following SQL commands to create the required tables.

```sql
CREATE TABLE IF NOT EXISTS "User" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
CREATE TABLE IF NOT EXISTS "DiaryEntry" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    date DATE DEFAULT CURRENT_DATE, -- Store only date without timestamp
    location VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "userId" INT REFERENCES "User"(id) ON DELETE CASCADE -- Foreign key constraint
);
```

### Instructions to run the application

1. Clone the repository
2. Run `npm install` to install the dependencies
3. Create a `.env` file in the root directory and add the following environment variables
    ```
    DATABASE=YOUR_DATABASE_NAME
    DB_USER=YOUR_DATABASE_USERNAME
    DB_PASSWORD=YOUR_DATABASE_PASSWORD
    DB_HOST=localhost
    DB_PORT=5432
    SECRET_KEY=YOUR_SECRET_KEY
    CA=YOUR_CERTIFICATE_AUTHORITY
    ```
4. Run `npm start` to start the server
5. The server will start running on `http://localhost:3000`

### Existing Users in the User Table

```json
{
    "username": "testuser",
    "email": "testuser@example.com",
    "password": "testuser_password"
}
```

```json
{
    "username": "srikanth",
    "email": "srikanth@example.com",
    "password": "sri_pass"
}
```

### Existing Diary Entries in the DiaryEntry Table

Diary Entries created by `testuser`

```json
{
    "title": "Trip to Goa",
    "description": "Visited Goa with friends. Had a great time.",
    "date": "2021-06-01",
    "location": "Goa"
}
```

```json
{
    "title": "Trekking in Himalayas",
    "description": "Trekking in Himalayas was an amazing experience.",
    "date": "2021-07-01",
    "location": "Himalayas"
}
```

Diary entries created by `srikanth`

```json
{
    "title": "Family Trip to Ooty",
    "description": "Family trip to Ooty was a memorable experience.",
    "date": "2021-08-01",
    "location": "Ooty"
}
```

```json
{
    "title": "Road Trip to Pondicherry",
    "description": "Road trip to Pondicherry was a fun experience.",
    "date": "2021-09-01",
    "location": "Pondicherry"
}
```

### API Endpoints

1. **User Registration**

    - Endpoint: `/register`
    - Method: `POST`
    - Request Body:
        ```json
        {
            "username": "example", // must be unique
            "email": "example@example.com", // must be unique
            "password": "example_password"
        }
        ```
    - Response:
        - Status Code: `201`
        - Response Body:
            ```json
            {
                "message": "User registered successfully."
            }
            ```
    - Error Response:
        - Status Code: `400`
        - Response Body:
            ```json
            {
                "error": "Username is already taken."
            }
            ```
        - Status Code: `400`
        - Response Body:
            ```json
            {
                "error": "Email is already taken."
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

2. **User Login**

    - Endpoint: `/login`
    - Method: `POST`
    - Request Body:
        ```json
        {
            "email": "example@example.com", // must be registered
            "password": "example_password" // must be correct
        }
        ```
    - Response:
        - Status Code: `200`
        - Response Body:
            ```json
            {
                "message": "User logged in successfully."
            }
            ```
    - Error Response:
        - Status Code: `400`
        - Response Body:
            ```json
            {
                "error": "Invalid email or password."
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

3. **Create Diary Entry**

    - Endpoint: `/diary`
    - Method: `POST`
    - Request Body:
        ```json
        {
            "title": "Trip to Goa",
            "description": "Visited Goa with friends. Had a great time.",
            "date": "2021-06-01",
            "location": "Goa"
        }
        ```
    - Response:
        - Status Code: `201`
        - Response Body:
            ```json
            {
                "message": "Diary entry created successfully."
            }
            ```
    - Error Response:
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

4. **Get All Diary Entries**

    - Endpoint: `/diary`
    - Method: `GET`
    - Response:
        - Status Code: `200`
        - Response Body:
            ```json
            [
                {
                    "id": 1,
                    "title": "Trip to Goa",
                    "description": "Visited Goa with friends. Had a great time.",
                    "date": "2021-06-01",
                    "location": "Goa",
                    "createdAt": "2021-09-01T10:00:00.000Z",
                    "updatedAt": "2021-09-01T10:00:00.000Z"
                },
                {
                    "id": 2,
                    "title": "Trekking in Himalayas",
                    "description": "Trekking in Himalayas was an amazing experience.",
                    "date": "2021-07-01",
                    "location": "Himalayas",
                    "createdAt": "2021-09-01T10:00:00.000Z",
                    "updatedAt": "2021-09-01T10:00:00.000Z"
                }
            ]
            ```
    - Error Response:
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

5. **Get Diary Entry by ID**

    - Endpoint: `/diary/:id`
    - Method: `GET`
    - Response:
        - Status Code: `200`
        - Response Body:
            ```json
            {
                "id": 1,
                "title": "Trip to Goa",
                "description": "Visited Goa with friends. Had a great time.",
                "date": "2021-06-01",
                "location": "Goa",
                "createdAt": "2021-09-01T10:00:00.000Z",
                "updatedAt": "2021-09-01T10:00:00.000Z"
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
            ```json
            {
                "error": "Diary entry not found."
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

6. **Update Diary Entry**

    - Endpoint: `/diary/:id`
    - Method: `PUT`
    - Request Body:
        ```json
        {
            "title": "Trip to Goa",
            "description": "Visited Goa with friends. Had a great time.",
            "date": "2021-06-01",
            "location": "Goa"
        }
        ```
    - Response:
        - Status Code: `200`
        - Response Body:
            ```json
            {
                "message": "Diary entry updated successfully."
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
            ```json
            {
                "error": "Diary entry not found."
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```

7. **Delete Diary Entry**

    - Endpoint: `/diary/:id`
    - Method: `DELETE`
    - Response:
        - Status Code: `200`
        - Response Body:
            ```json
            {
                "message": "Diary entry deleted successfully."
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
            ```json
            {
                "error": "Diary entry not found."
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "error": "Internal Server Error."
            }
            ```