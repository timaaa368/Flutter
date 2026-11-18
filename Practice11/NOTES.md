
# Practice 11 — A Real Server

## Level 1: Postman Results

### User fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Yes |
| company | object | Company record | No |

### Address fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| lat | string | double | No |
| lng | string | double | No |

### Company fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | String | No |

## HTTP Status Results

| Request | Expected status |
|---|---|
| GET /users | 200 |
| GET /users/1 | 200 |
| GET /users/999 | 404 |
| POST /users | 201 |
| GET /users?id=3 | 200 |

## Network Tests

Airplane mode time: Not tested yet.

Dead Wi-Fi timeout: Not tested yet.
