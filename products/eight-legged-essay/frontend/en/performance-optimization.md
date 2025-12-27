# Frontend Performance Optimization

## Introduction

Frontend performance directly impacts user experience. Slow websites lead to higher bounce rates and lower conversion rates.

## Core Web Vitals

### 1. Largest Contentful Paint (LCP)
- **Target**: < 2.5 seconds
- When the largest element is rendered
- Impacts perceived loading performance

### 2. First Input Delay (FID)
- **Target**: < 100 milliseconds
- Time from user interaction to response
- Measures interactivity

### 3. Cumulative Layout Shift (CLS)
- **Target**: < 0.1
- Unexpected layout changes
- Impacts visual stability

## Performance Optimization Techniques

### 1. Image Optimization
- Use modern formats (WebP)
- Lazy loading
- Responsive images
- CDN delivery

### 2. Code Splitting
- Split large bundles
- Lazy load routes
- Tree shaking
- Remove unused code

### 3. Caching Strategies
- Browser caching
- Service workers
- CDN caching
- API response caching

### 4. Critical CSS
- Inline critical CSS
- Defer non-critical CSS
- Minimize CSS files

## Monitoring Tools

### Lighthouse
- Built into Chrome DevTools
- Audits performance, SEO, accessibility
- Provides actionable recommendations

### Web Vitals Library
```javascript
import { getCLS, getFID, getLCP } from 'web-vitals';

getCLS(console.log);
getFID(console.log);
getLCP(console.log);
```

### RUM (Real User Monitoring)
- Collect real performance data
- Identify performance bottlenecks
- Track improvements over time

## Best Practices

1. **Optimize Images**: Image files are often the largest assets
2. **Minify Resources**: Remove unnecessary characters
3. **Use Compression**: Enable gzip/brotli compression
4. **Prioritize Above-the-fold**: Load critical content first
5. **Defer Non-critical Scripts**: Load JavaScript strategically
6. **Implement Caching**: Leverage browser and CDN caching

## Conclusion

Frontend performance is a continuous process. Regularly monitor metrics and optimize based on real user data.
