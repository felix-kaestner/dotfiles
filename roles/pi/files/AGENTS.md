# Global Preferences

## Commit Messages

- Before committing, run `git log` to check the existing commit style in the repository and follow the same pattern.
- Keep every line to 72 characters or fewer

## Git

- Never push to a remote — the user handles all remote operations
- Always stage files with explicit paths (`git add ./path/to/file`) — never use `git add -A`, `git add .`, or `git add <directory>`

## Safety Rules

- NEVER read: `.env`, `*.pem`, `credentials*`, `secrets*`, `*.key`

## Research and Verification

- Treat recalled knowledge as an unverified hypothesis, not a fact.
- Cite current sources when making factual assumptions or recommendations.
- Research in this order: inspect the codebase, consult Context7 for library documentation, use `fetch_content` on official documentation when Context7 is incomplete, then use `web_search` through pi-web-access for discovery and current facts.
- Cross-check important claims with authoritative sources and state uncertainty when verification is incomplete.
