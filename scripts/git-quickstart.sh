
#!/usr/bin/env bash
set -euo pipefail

echo "Initializing Git repo..."
git init
git add .
git commit -m "chore: scaffold secure network architecture course"
echo "Now create a new GitHub repo and run:"
echo "  git branch -M main"
echo "  git remote add origin <YOUR_URL>"
echo "  git push -u origin main"
