# DictaFlow.ai Brand Guide

## 🎨 Logo Variations

### Primary Logo
- **File**: `images/logo.svg`
- **Usage**: Main marketing materials, presentations
- **Dimensions**: 200x60px
- **Features**: Animated soundwaves, full branding

### Horizontal Logo
- **File**: `images/logo-horizontal.svg`
- **Usage**: Website headers, navigation, email signatures
- **Dimensions**: 160x40px
- **Features**: Compact layout, optimized for headers

### Icon Logo
- **File**: `images/logo-icon.svg`
- **Usage**: App icons, social media profiles, small spaces
- **Dimensions**: 64x64px
- **Features**: Simplified soundwave, circular design

### Dark Background Logo
- **File**: `images/logo-dark.svg`
- **Usage**: Dark themes, presentations on dark backgrounds
- **Dimensions**: 160x40px
- **Features**: Light colors optimized for dark backgrounds

### Favicon
- **File**: `images/favicon.svg`
- **Usage**: Browser tabs, bookmarks
- **Dimensions**: 32x32px
- **Features**: Simplified icon, high contrast

## 🎵 Logo Elements

### Soundwave Visualization
- **Concept**: Represents voice input being converted to text
- **Animation**: Bars move up and down to simulate real-time audio
- **Colors**: Blue gradient (#3b82f6 to #8b5cf6)
- **Meaning**: Technology, innovation, real-time processing

### Typography
- **Font**: Inter (Sans-serif)
- **Primary**: DictaFlow (Bold, 700 weight)
- **Secondary**: .ai (Medium, 500 weight, muted)
- **Characteristics**: Modern, clean, highly legible

### Flow Elements
- **Arrow**: Represents transformation from voice to text
- **Text Lines**: Represent output text/documents
- **Gradients**: Suggest smooth flow and technology

## 🎨 Color Palette

### Primary Colors
```css
--primary-blue: #3b82f6    /* Main brand color */
--primary-cyan: #06b6d4    /* Accent color */
--primary-purple: #8b5cf6  /* Gradient end */
```

### Secondary Colors
```css
--text-primary: #1e293b    /* Main text */
--text-secondary: #64748b  /* Secondary text */
--text-muted: #94a3b8     /* Muted text */
--background: #ffffff      /* Main background */
--background-alt: #f8fafc  /* Alternative background */
```

### Gradient
```css
--gradient-primary: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
```

## 📐 Logo Usage Guidelines

### Minimum Sizes
- **Horizontal Logo**: 80px width minimum
- **Icon Logo**: 16px width minimum
- **Primary Logo**: 100px width minimum

### Clear Space
- Maintain clear space around logo equal to the height of one soundwave bar
- Minimum padding: 8px on all sides

### Backgrounds
- **Light Backgrounds**: Use primary logo variants
- **Dark Backgrounds**: Use dark variant or white version
- **Complex Backgrounds**: Place logo on solid color backdrop

### Don'ts
- ❌ Don't stretch or distort the logo
- ❌ Don't change colors outside brand palette
- ❌ Don't add effects (drop shadows, outlines, etc.)
- ❌ Don't place on busy backgrounds without backdrop
- ❌ Don't use low-resolution versions

## 🖼️ File Formats

### SVG (Preferred)
- **Advantages**: Scalable, small file size, CSS customizable
- **Usage**: Web, print, any scalable application
- **Browser Support**: All modern browsers

### PNG (When SVG not supported)
- **Sizes**: 32px, 64px, 128px, 256px, 512px
- **Background**: Transparent
- **Usage**: Legacy systems, some social media

### ICO (Favicons)
- **Sizes**: 16px, 32px, 48px in single file
- **Usage**: Browser favicons, Windows applications

## 🌐 Web Implementation

### HTML
```html
<!-- Navigation -->
<img src="images/logo-horizontal.svg" alt="DictaFlow.ai" class="logo">

<!-- Favicon -->
<link rel="icon" type="image/svg+xml" href="images/favicon.svg">
<link rel="alternate icon" href="images/favicon.ico">
```

### CSS
```css
.logo {
    height: 32px;
    width: auto;
    transition: transform 0.3s ease;
}

.logo:hover {
    transform: scale(1.05);
}
```

## 📱 Social Media Specs

### Profile Pictures
- **File**: `logo-icon.svg` converted to PNG
- **Dimensions**: 512x512px (high-res)
- **Background**: White or transparent

### Cover Photos
- **Facebook**: 820x312px
- **Twitter**: 1500x500px
- **LinkedIn**: 1584x396px
- Use horizontal logo with ample white space

## 🎯 Brand Personality

### Visual Traits
- **Modern**: Clean lines, contemporary design
- **Trustworthy**: Blue color palette, professional typography
- **Innovative**: Animated elements, gradient effects
- **Accessible**: High contrast, clear typography

### Emotional Qualities
- Professional yet approachable
- Innovative but reliable
- Sophisticated but not intimidating
- Tech-savvy but user-friendly

## 📋 Logo Checklist

Before using any logo variation:

- [ ] Is it the correct size for the application?
- [ ] Is there adequate clear space around the logo?
- [ ] Is the background suitable for the logo variant?
- [ ] Are the colors from the approved palette?
- [ ] Is the file format appropriate?
- [ ] Does it maintain legibility at the intended size?

## 🔄 Updates and Versions

### Current Version: 1.0
- Initial brand identity
- Created: January 2025
- Designer: DictaFlow Team

### Future Considerations
- App icon variations for different platforms
- Merchandise applications
- Video/motion graphics versions
- Accessibility improvements

---

For questions about logo usage or to request new variations, contact the design team or create an issue in the repository.
