import { writable, derived } from 'svelte/store';
import { page } from '$app/stores';

// Theme colors with more vibrant and varied colors for different routes
// Each route has a distinct color palette
const themeColors = {
  '/': { background: '#F2F0EB', primary: '#333333', accent: '#E8846B' },           // Warm coral/orange
  '/about': { background: '#EFEEE9', primary: '#333333', accent: '#4A9F7B' },      // Vibrant teal/green
  '/exhibitions': { background: '#F0EDE8', primary: '#333333', accent: '#D6A461' }, // Rich yellow/gold
  '/art': { background: '#F5F3EE', primary: '#333333', accent: '#E17A9F' },        // Vibrant pink
  '/murals': { background: '#EDEAE5', primary: '#333333', accent: '#4F97C4' },      // Bright blue
  '/workshops': { background: '#F1EFE9', primary: '#333333', accent: '#9C75BB' },   // Rich purple
  '/shop': { background: '#F4F1EC', primary: '#333333', accent: '#E35D5D' },        // Vibrant red
  '/contact': { background: '#F9F9F7', primary: '#333333', accent: '#555555' }      // Near black/white
};

// Default theme with warm coral accent
const defaultTheme = { background: '#F2F0EB', primary: '#333333', accent: '#E8846B' };

// Create the theme store
export const currentTheme = writable(defaultTheme);

// Create a derived store that updates the theme based on the current route
export const theme = derived(page, ($page) => {
  const path = $page.url.pathname;
  
  // Find the exact match first
  let theme = themeColors[path];
  
  // If no exact match, try to find a parent route match
  if (!theme) {
    // Sort paths by length (longest first) to match the most specific route
    const sortedPaths = Object.keys(themeColors).sort((a, b) => b.length - a.length);
    
    for (const routePath of sortedPaths) {
      // Check if the current path starts with this route path
      if (path.startsWith(routePath) && routePath !== '/') {
        theme = themeColors[routePath];
        break;
      }
    }
    
    // If still no match, use default
    if (!theme) {
      theme = defaultTheme;
    }
  }
  
  // Update the currentTheme store with a new object to ensure reactivity
  currentTheme.set({...theme});
  
  return theme;
});

// Convert hex to RGB for shaders
export function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16) / 255,
    g: parseInt(result[2], 16) / 255,
    b: parseInt(result[3], 16) / 255
  } : { r: 0, g: 0, b: 0 };
}

// Generate random pastel colors based on the theme
export function generateRandomPastelColors(baseColor) {
  const rgb = hexToRgb(baseColor);
  const colors = [];
  
  for (let i = 0; i < 5; i++) {
    // Add some randomness to the base color
    const r = Math.min(1, Math.max(0, rgb.r + (Math.random() * 0.2 - 0.1)));
    const g = Math.min(1, Math.max(0, rgb.g + (Math.random() * 0.2 - 0.1)));
    const b = Math.min(1, Math.max(0, rgb.b + (Math.random() * 0.2 - 0.1)));
    
    colors.push({ r, g, b });
  }
  
  return colors;
} 