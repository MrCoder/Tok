# DictaFlow.ai Website

This is the official website for DictaFlow.ai, an AI-powered voice-to-text transcription app for macOS.

## 🌐 Live Website
- **Production**: https://dictaflow.ai
- **Hosted on**: Cloudflare Pages

## 🚀 Deployment

### Cloudflare Pages Setup

1. **Connect Repository**:
   - Go to Cloudflare Pages dashboard
   - Connect your GitHub repository
   - Select the `website` folder as the build directory

2. **Build Settings**:
   - **Build command**: `# No build needed - static files`
   - **Build output directory**: `website`
   - **Root directory**: `website`

3. **Environment Variables**:
   - No environment variables needed for static site

4. **Custom Domain**:
   - Add `dictaflow.ai` as custom domain
   - Configure DNS to point to Cloudflare Pages

### Deploy Commands

```bash
# No build process needed - pure static HTML/CSS/JS
# Files are deployed directly from the website folder
```

## 📁 Project Structure

```
website/
├── index.html          # Main landing page
├── privacy.html        # Privacy policy page
├── css/
│   └── style.css       # Main stylesheet
├── js/
│   └── script.js       # Interactive features
├── images/             # Static images (placeholder)
├── _redirects          # Cloudflare Pages redirects
├── _headers            # Security and cache headers
└── README.md           # This file
```

## 🎨 Features

- **Modern Design**: Clean, professional layout with gradient accents
- **Responsive**: Mobile-first design that works on all devices
- **Interactive**: Smooth animations and typing effects
- **Performance**: Optimized for fast loading
- **SEO Ready**: Proper meta tags and semantic HTML
- **Accessible**: WCAG compliant with proper focus management

## 🛠️ Development

### Local Development

1. **Serve locally**:
   ```bash
   cd website
   python3 -m http.server 8000
   # or
   npx serve .
   ```

2. **Open in browser**: http://localhost:8000

### Making Changes

1. Edit HTML, CSS, or JS files
2. Test locally
3. Commit and push to trigger Cloudflare Pages deployment

## 📝 Content Updates

### Updating Download Links
When the app is ready for download, update the download button hrefs in:
- `index.html` (multiple download buttons)
- Update `_redirects` file for `/download` path

### Adding New Pages
1. Create new HTML file in `website/` directory
2. Add navigation links in header
3. Update footer links if needed
4. Add any new redirects to `_redirects`

## 🔧 Configuration Files

### `_redirects`
- URL redirects and rewrites
- Download page redirects
- GitHub and support redirects
- SPA-like fallback routing

### `_headers`
- Security headers (XSS protection, frame options)
- Cache control for static assets
- CORS headers for future API endpoints

## 🎯 SEO & Analytics

### Current SEO Features
- Semantic HTML structure
- Meta descriptions and titles
- Open Graph tags ready
- Structured data ready

### Adding Analytics (Optional)
To add Google Analytics or other tracking:

1. Add tracking script to `<head>` in HTML files
2. Update privacy policy accordingly
3. Add consent management if required

## 🔒 Security

- Content Security Policy ready
- XSS protection headers
- Frame denial for clickjacking prevention
- HTTPS enforced via Cloudflare

## 📞 Support

- **Website Issues**: Create issue in main repository
- **Content Updates**: Contact development team
- **Domain Issues**: Check Cloudflare Pages settings

---

Built with ❤️ for the DictaFlow.ai project
