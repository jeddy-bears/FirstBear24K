name: Weekly QB Stats Update

on:
  schedule:
    # Runs Tuesdays at 08:00 AM America/Chicago (adjust if you want a different local time)
    # GitHub cron uses UTC. For 8:00 AM CT (UTC-6) use 14:00 UTC -> '0 14 * * Tue'
    - cron: '0 14 * * Tue'
  workflow_dispatch:

jobs:
  update-stats:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: |
          npm init -y
          npm install node-fetch@2

      - name: Run update script
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: |
          node updateStats.js

      - name: Commit and push changes
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add index.html
          git commit -m "chore: auto-update Caleb Williams stats" || echo "No changes to commit"
          git push
