# Global Preferences

## Commit Messages

- Before committing, run `git log` to check the existing commit style in the repository and follow the same pattern.
- Keep every line to 72 characters or fewer

## Git

- Never push to a remote — the user handles all remote operations
- Always stage files with explicit paths (`git add ./path/to/file`) — never use `git add -A`, `git add .`, or `git add <directory>`

## pi-web-access

When calling `get_search_content`:

- With `findText`, omit both `offset` and `limit`.
- For paginated content, use `offset` and `limit` without `findText`.
- Never retry an “Incompatible find options” error with the same arguments.
