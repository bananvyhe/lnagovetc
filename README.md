# lnagovetc local template (Rails + Vue + Docker)

## Commands
- `make bootstrap` - initialize backend/frontend and database
- `make up` - run core profile (`web + postgres + redis`)
- `make up-full` - run full profile (`core + vite + sidekiq`)
- `make down` - stop everything
- `make logs` - stream logs
- `make hello` - smoke check for `http://localhost:3000`

## Native (no Docker)
- `make bootstrap-native` - initialize local Ruby/Node and project files
- `make up-native` - run Rails only
- `make up-native-full` - run Rails + Vite + Sidekiq
- `make down-native` - stop local processes started by the scripts
- `make test-native` - run backend/frontend tests locally

## URLs
- Rails: http://localhost:3000
- Vite: http://localhost:5173 (only with `make up-full`)

## Notes
- Edit files on host in `backend/` and `frontend/`.
- Containers read files through bind mounts.
- Use host git normally: `git status`, `git add`, `git commit`, `git push`.

## Pinned Versions
See `docs/STACK.md` for the locked dependency list and install notes.

## GitHub SSH (first-time setup)
1) Add your public key in GitHub: Settings → SSH and GPG keys.
2) Set origin and push:
   - `git remote add origin git@github.com:USERNAME/codex_local_env_setup.git`
   - `git push -u origin main`
