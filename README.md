# Suprabha Trust Static Site

This repository contains the multi-page static site refactored from a monolithic HTML file. It uses pure HTML, CSS, and vanilla JS, without any build tools or bundlers.

## Page Map

The site has been split into 7 primary pages:

- **index.html**: Home page containing the Hero section, Sanatana Dharma aspects, and Impact highlights.
- **knowledge.html**: Knowledge Bank categorizing content into disciplines.
- **articles.html**: Dedicated space for articles and article submission (currently a placeholder based on source file).
- **videos.html**: Video submission and guidelines.
- **renewable.html**: Renewable Energy and upcoming programs (currently just upcoming programs based on source file).
- **about.html**: Our Story, Mission & Vision, Connections, Partnership, and Impact Areas.
- **contact.html**: Reach out, contact forms, and Donation sections.

## How to Edit Navigation

Because the site avoids build steps and JS-injected components for SEO and crawlability, the Header and Navigation block is duplicated across all HTML files. 

If you need to add a new link to the menu or modify an existing one, you must update the `<nav>` block found at the top of the `<body>` in **each of the 7 HTML files**. Look for the `<!-- NAV -->` comment. 

The active page is highlighted using `class="active" aria-current="page"`. Ensure you retain this on the appropriate link when editing the nav block in each file.

## SUBMISSION_CONFIG & Archive Buttons

*(Note: The provided source file did not contain `SUBMISSION_CONFIG` or the archive buttons. If you are adding them back from a previous version, here is how they work:)*

To re-enable the Google Drive archive buttons, you need to provide valid URLs in the JavaScript configuration. 

In `assets/js/main.js`, add or update the `SUBMISSION_CONFIG` object:

```javascript
const SUBMISSION_CONFIG = {
  articlesDriveUrl: "https://drive.google.com/...", // Replace with real URL
  videosDriveUrl: "https://drive.google.com/..."    // Replace with real URL
};

// The script will automatically check if the URL contains 'YOUR_GOOGLE'.
// If a real URL is provided, it will un-hide the archive buttons:
// buttonWrapper.style.display = 'flex';
```

## Deployment to Netlify

This site is completely static and ready to be deployed to Netlify out-of-the-box. A `netlify.toml` file is included to configure standard settings (e.g., 404 fallbacks).

**Method 1: Drag-and-Drop (Easiest)**
1. Log in to [Netlify](https://app.netlify.com/).
2. Go to the **Sites** tab.
3. Drag and drop the entire project folder (containing `index.html`) into the designated drop zone at the bottom of the screen.

**Method 2: Git / GitHub**
1. Initialize a Git repository in this folder and push it to GitHub/GitLab.
2. In Netlify, click **Add new site** -> **Import an existing project**.
3. Connect your repository.
4. Leave the "Build command" blank and set the "Publish directory" to `.` (or empty).
5. Click **Deploy Site**.
