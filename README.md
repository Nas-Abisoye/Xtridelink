# Xtridelink Mobile

Monorepo for the Xtridelink on-demand delivery mobile apps (Flutter). Both
apps talk to the Django backend (`xtridelink_backend`) over REST + WebSockets.

| Folder | App | Package |
|--------|-----|---------|
| [`customer/`](customer/) | Customer app — create/track deliveries | `xtridelink` |
| [`rider/`](rider/) | Rider/driver app — bid, deliver, earn | `xtridelink_driver` |

## Getting started

Each app is a standalone Flutter project. From either folder:

```bash
cp .env.example .env   # if present; otherwise create .env (see below)
flutter pub get
flutter run
```

Both apps read the API base URL and keys from a git-ignored `.env` file
(loaded via `flutter_dotenv`). At minimum provide `DEV_API_BASE_URL`.

## Recent changes (token refresh + hardening)

Both apps were updated to support the backend's shortened JWT access-token
lifetime and to fix security/transport issues:

- **Token refresh**: the `refresh_token` is now persisted at login and used to
  transparently refresh an expired access token (401 → refresh → retry once),
  falling back to a forced re-login. Sockets re-read the token on reconnect.
  Requires the backend `POST /users/token/refresh/` endpoint.
- **Rider fixes**: order WebSocket now uses the order URL (was the
  notifications URL); file upload uses HTTPS (was cleartext).
- **Logging**: verbose request/response logging (tokens, passwords, OTPs) is
  gated behind `kDebugMode`.

### Known follow-ups
- Rotate & restrict the Google Maps API key (currently committed in source and
  native configs).
- Move the customer app's access token from `SharedPreferences` to secure
  storage.
- Verify the rider order WebSocket route against the backend (trackingId).
