# Flutter Web Build and GitHub Pages Setup

## Automated Deployment (Recommended)

GitHub Actions automatically builds and deploys the Flutter Web app to GitHub Pages whenever you push to the `main` branch.

### Setup

1. Go to your repository settings: https://github.com/shigehiko-sugeda/langua-quest/settings/pages
2. Under "Build and deployment"
   - Select **Source**: `GitHub Actions`
3. The deployment will start automatically on the next push to `main`

### Access Your App

Once deployed, your app will be available at:

```
https://shigehiko-sugeda.github.io/langua-quest/
```

## Local Build (Optional)

If you want to test the web build locally:

```bash
# Enable web platform (if not already enabled)
flutter config --enable-web

# Build
flutter clean
flutter pub get
flutter build web --release --base-href /langua-quest/

# Test locally (requires a local server)
# Option 1: Using Python
cd build/web
python3 -m http.server 8080

# Option 2: Using Node.js
npx http-server build/web
```

Then open `http://localhost:8080` in your browser.

## Important Notes

- **Base URL**: The Flutter Web app is configured with `--base-href /langua-quest/` to work correctly at the GitHub Pages URL
- **Build Time**: The first build may take several minutes
- **Web Limitations**: Some features like `flutter_tts` may have limited functionality on web
- **Offline Mode**: The web version is not fully offline by default. Consider adding a service worker for PWA capabilities

## Troubleshooting

### Pages not updating

1. Check the workflow status in **Actions** tab
2. Verify the deployment source in repository settings is set to `GitHub Actions`
3. Clear your browser cache

### App not loading at GitHub Pages URL

- Verify the `--base-href` matches your repository URL
- Check browser console for any errors

### Build fails

- Run `flutter doctor` to check your Flutter environment
- Check the workflow logs in the **Actions** tab for specific error messages
