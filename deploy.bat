@echo off
:: Abort on errors
setlocal enabledelayedexpansion
set "ERRORLEVEL="
if not errorlevel 0 exit /b %errorlevel%

cd 01-reading-books

:: Build the project
npm run build
if not errorlevel 0 exit /b %errorlevel%

:: Navigate into the build output directory
cd dist

:: Initialize a new git repository and deploy
git init
git add -A
git commit -m "deploy"
if not errorlevel 0 exit /b %errorlevel%

:: Push to the gh-pages branch of the specified repository
git remote add origin https://github.com/Zarritas/Reading-books-deploy.git
git branch -M main
git push -u origin main:gh-pages
if not errorlevel 0 exit /b %errorlevel%

cd ..
