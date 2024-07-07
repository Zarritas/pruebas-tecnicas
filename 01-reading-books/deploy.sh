#!/bin/bash
set -e

# Build the project
npm run build

# Navigate into the build output directory
cd dist

# Initialize a new git repository and deploy
git init
git add -A
git commit -m "deploy"

# Force push to the gh-pages branch of the specified repository
git push -f git@github.com:Zarritas/Reading-books.git main:gh-pages

# Navigate back to the original directory
cd ..

