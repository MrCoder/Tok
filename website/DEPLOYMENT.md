# DictaFlow.ai - Cloudflare Pages Deployment Guide

This guide walks you through deploying the DictaFlow.ai website to Cloudflare Pages.

## 🚀 Quick Deployment Steps

### 1. Prepare Repository

The website is ready to deploy from the `/website` folder in this repository.

### 2. Cloudflare Pages Setup

1. **Log in to Cloudflare**:
   - Go to [Cloudflare Pages](https://pages.cloudflare.com/)
   - Sign in to your Cloudflare account

2. **Create New Project**:
   - Click "Create a project"
   - Choose "Connect to Git"

3. **Connect Repository**:
   - Select your Git provider (GitHub recommended)
   - Choose this repository: `dictaflow/dictaflow`
   - Authorize Cloudflare access

4. **Configure Build Settings**:
   ```
   Project name: dictaflow-website
   Production branch: main
   Build command: # (leave empty - no build needed)
   Build output directory: website
   Root directory: website
   ```

5. **Deploy**:
   - Click "Save and Deploy"
   - Wait for initial deployment (usually 1-2 minutes)

### 3. Custom Domain Setup

1. **Add Custom Domain**:
   - In your Cloudflare Pages project
   - Go to "Custom domains" tab
   - Click "Set up a custom domain"
   - Enter: `dictaflow.ai`

2. **DNS Configuration**:
   - In Cloudflare DNS settings
   - Add CNAME record: `dictaflow.ai` → `dictaflow-website.pages.dev`
   - Add CNAME record: `www.dictaflow.ai` → `dictaflow-website.pages.dev`

3. **SSL Certificate**:
   - Cloudflare automatically provisions SSL
   - Certificate should be active within 15 minutes

## 🔧 Environment Configuration

### Build Settings Details

```yaml
Build command: # (none needed)
Build output directory: website
Root directory: website
Node.js version: # (not needed)
Environment variables: # (none needed)
```

### Branch Deployments

- **Production**: `main` branch → `dictaflow.ai`
- **Preview**: Feature branches → `<branch-name>.dictaflow-website.pages.dev`

## 📁 File Structure

The website deployment includes:

```
website/
├── index.html          # Main page
├── privacy.html        # Privacy policy
├── 404.html           # Error page
├── css/style.css      # Styles
├── js/script.js       # JavaScript
├── _redirects         # URL redirects
├── _headers          # HTTP headers
└── images/           # Static assets
```

## 🌐 Domain & DNS Setup

### DNS Records Required

```
Type  Name              Content                          TTL
CNAME dictaflow.ai      dictaflow-website.pages.dev     Auto
CNAME www.dictaflow.ai  dictaflow-website.pages.dev     Auto
```

### SSL/TLS Settings

- **SSL Mode**: Full (strict)
- **Edge Certificates**: Cloudflare managed
- **HSTS**: Enabled (recommended)

## 🔄 Automatic Deployments

### How It Works

1. **Push to GitHub**: Any push to `main` branch
2. **Auto Deploy**: Cloudflare Pages detects changes
3. **Build Process**: Files copied from `/website` folder
4. **Go Live**: New version deployed automatically

### Deployment Triggers

- ✅ Push to `main` branch
- ✅ Pull request merge
- ❌ Draft pull requests (preview only)

## 🔒 Security Configuration

### HTTP Headers (`_headers` file)

```
Security Headers:
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

Caching:
- Static assets: 1 year cache
- HTML: 1 hour cache
- Root page: 5 minute cache
```

### Redirects (`_redirects` file)

```
URL Redirects:
- /download → /#download
- /github → GitHub repository
- /support → Support email
- www.* → apex domain
- Catch-all SPA routing
```

## 📊 Performance Optimization

### Cloudflare Features Enabled

- **CDN**: Global edge caching
- **Minification**: Auto-minify CSS, JS, HTML
- **Compression**: Brotli & Gzip
- **HTTP/2**: Enabled by default
- **Image Optimization**: For future image assets

### Lighthouse Scores Target

- Performance: 95+
- Accessibility: 95+
- Best Practices: 95+
- SEO: 95+

## 🔍 Monitoring & Analytics

### Cloudflare Analytics

- **Page Views**: Built-in analytics
- **Performance**: Core Web Vitals
- **Security**: Threat monitoring

### Optional Third-Party Analytics

To add Google Analytics:

1. Add tracking script to HTML files
2. Update privacy policy
3. Consider GDPR compliance

## 🛠️ Troubleshooting

### Common Issues

**Build Fails**:
- Ensure build command is empty
- Check root directory is set to `website`

**Custom Domain Not Working**:
- Verify DNS records are correct
- Wait up to 24 hours for DNS propagation
- Check SSL certificate status

**Redirects Not Working**:
- Verify `_redirects` file syntax
- Check redirect rules in Cloudflare Pages dashboard

**404 Errors**:
- Ensure `404.html` exists in root
- Check SPA routing in `_redirects`

### Support Resources

- [Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)
- [Troubleshooting Guide](https://developers.cloudflare.com/pages/platform/troubleshooting/)
- [Community Forum](https://community.cloudflare.com/c/developers/pages/)

## 🔄 Rollback Procedure

### How to Rollback

1. **Via Dashboard**:
   - Go to Cloudflare Pages dashboard
   - Select deployment history
   - Click "Rollback" on previous version

2. **Via Git**:
   - Revert commits in repository
   - Push to `main` branch
   - New deployment triggers automatically

### Emergency Contacts

- **Domain Issues**: Cloudflare support
- **Code Issues**: Repository maintainers
- **Content Issues**: Development team

---

✅ **Ready to Deploy!** Follow the steps above to get DictaFlow.ai live on Cloudflare Pages.
