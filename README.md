# Travel Diary Backend API

Live API URL - [https://travel-diary-backend-gw2v.onrender.com/](https://travel-diary-backend-gw2v.onrender.com/)

Since the API is currently deployed on the **Free Web Service** of [Render](https://render.com), sometimes the server may be in sleep mode. If you encounter any issues, please try after some time. Thank you!

> Your free instance will spin down with inactivity, which can delay requests by 50 seconds or more.

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
        The `"username"` and `"email"` must be unique.

        ```json
        {
            "username": "example",
            "email": "example@example.com",
            "password": "example_password"
        }
        ```
    - Response:
        - Status Code: `201`
        - Response Body:

            ```json
            {
                "user_id": 3
            }
            ```
    - Error Response:
        - Status Code: `400`
        - Response Body:
        If the `"username"`, `"email"` or `"password"` is missing or `null`.

            ```json
            {
                "message": "username, email and password are required"
            }
            ```
        - Status Code: `400`
        - Response Body:
        If the user with the same email already exists.

            ```json
            {
                "message": "User with this email already exists"
            }
            ```
        - Status Code: `400`
        - Response Body:
        If the user with the same username already exists.

            ```json
            {
                "message": "User with this username already exists"
            }
            ```
        - Status Code: `500`
        - Response Body:

            ```json
            {
                "message": "Internal server error"
            }
            ```

2. **User Login**

    - Endpoint: `/login`
    - Method: `POST`
    - Request Body:
    The `"email"` must be registered and the `"password"` must be correct.

        ```json
        {
            "email": "example@example.com",
            "password": "example_password"
        }
        ```
    - Response:
        - Status Code: `200`
        - Response Body:
        Returns a token which is required to access the `Diary` endpoints and is valid for 24 hours.

            ```json
            {
                "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsImlhdCI6MTcxMzA5NzMzOCwiZXhwIjoxNzEzMTgzNzM4fQ.InBy9ClIQWzk8dFZEKzHVQE3it3f8ejv-1evy8gIEL8"
            }
            ```
    - Error Response:
        - Status Code: `400`
        - Response Body:
        If the `"email"` or `"password"` is missing or `null`.

            ```json
            {
                "message": "email and password are required"
            }
            ```
        - Status Code: `404`
        - Response Body:
        If the user with the given email is not found.

            ```json
            {
                "message": "User not found"
            }
            ```
        - Status Code: `401`
        - Response Body:
        If the password is incorrect.

            ```json
            {
                "message": "Invalid credentials"
            }
            ```
        - Status Code: `500`
        - Response Body:

            ```json
            {
                "message": "Internal server error"
            }
            ```

Before proceeding to below endpoints the token received from the `/login` endpoint must be added to the request headers as `Authorization: Bearer TOKEN_RECEIVED_FROM_LOGIN_ENDPOINT`. Falied to provide the token will result in below response from the server.

```json
{
    "message": "Authentication failed"
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
                "diary_entry_id": "1"
            }
            ```
    - Error Response:
        - Status Code: `400`
        - Response Body:
        If the `"title"` is missing on `null`.

            ```json
            {
                "message": "title is required"
            }
            ```
        - Status Code: `400`
        - Response Body:
        If the `"description"` is missing on `null`.

            ```json
            {
                "message": "description is required"
            }
            ```
        - Status Code: `400`
        - Response Body:
        If the `"date"` is missing on `null`.

            ```json
            {
                "message": "date is required"
            }
            ```
        - Status Code: `400`
        - Response Body:
        If the `"location"` is missing on `null`.

            ```json
            {
                "message": "location is required"
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "message": "Internal server error"
            }
            ```

4. **Get All Diary Entries**

    - Endpoint: `/diary`
    - Method: `GET`
    - Response:
        - Status Code: `200`
        - Response Body:
        Returns all diary entries created by the user.

            ```json
            [
                {
                    "id": 1,
                    "title": "Trip to Goa",
                    "description": "Visited Goa with friends. Had a great time.",
                    "date": "2021-06-01",
                    "location": "Goa"
                },
                {
                    "id": 2,
                    "title": "Trekking in Himalayas",
                    "description": "Trekking in Himalayas was an amazing experience.",
                    "date": "2021-07-01",
                    "location": "Himalayas"
                }
            ]
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
        If there are no diary entries created by the user.

            ```json
            {
                "message": "No diary entries found for this User"
            }
            ```
        - Status Code: `500`
        - Response Body:
            ```json
            {
                "message": "Internal server error"
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
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
        If the diary entry with the given ID is not found.

            ```json
            {
                "message": "Diary entry not found."
            }
            ```
        - Status Code: `403`
        - Response Body:
        If the diary entry does not belong to the logged in User.

            ```json
            {
                "message": "You are not authorized to view this diary entry"
            }
            ```
        - Status Code: `500`
        - Response Body:

            ```json
            {
                "message": "Internal server error"
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
        - Status Code: `201`
        - Response Body:

            ```json
            {
                "id": 1,
                "title": "Trip to Goa",
                "description": "Visited Goa with friends. Had a great time.",
                "date": "2021-06-01",
                "location": "Goa"
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
            If the diary entry with the given ID is not found.

            ```json
            {
                "message": "Diary entry not found."
            }
            ```
        - Status Code: `403`
        - Response Body:
            If the diary entry trying to update does not belong to the logged in User.

            ```json
            {
                "message": "You are not authorized to update this diary entry"
            }
            ```
        - Status Code: `500`
        - Response Body:

            ```json
            {
                "message": "Internal server error"
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
                "message": "Diary entry deleted successfully"
            }
            ```
    - Error Response:
        - Status Code: `404`
        - Response Body:
            If the diary entry with the given ID is not found.

            ```json
            {
                "message": "Diary entry not found"
            }
            ```
        - Status Code: `403`
        - Response Body:
            If the diary entry trying to delete does not belong to the logged in User.

            ```json
            {
                "message": "You are not authorized to delete this diary entry"
            }
            ```
        - Status Code: `500`
        - Response Body:

            ```json
            {
                "message": "Internal server error"
            }
            ```