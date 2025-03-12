import { writable, derived } from 'svelte/store';
import { page } from '$app/stores';

// Theme colors for different routes with vibrant sea-inspired backgrounds and warm accents
const themeColors = {
  '/': { background: '#E0F2F7', primary: '#333333', accent: '#FFA62B' },
  '/about': { background: '#D6EDF5', primary: '#333333', accent: '#FFD166' },
  '/exhibitions': { background: '#CCE8F2', primary: '#333333', accent: '#FF9E44' },
  '/art': { background: '#E5F4F9', primary: '#333333', accent: '#FFA62B' },
  '/murals': { background: '#C2E3EF', primary: '#333333', accent: '#FFD166' },
  '/workshops': { background: '#DAEEF6', primary: '#333333', accent: '#FFA62B' },
  '/shop': { background: '#D0EAF3', primary: '#333333', accent: '#FFD166' },
  '/contact': { background: '#C8E5F0', primary: '#333333', accent: '#FF9E44' }
};

// Default theme with orange accent
const defaultTheme = { background: '#E0F2F7', primary: '#333333', accent: '#FFA62B' };

// Create the theme store
export const currentTheme = writable(defaultTheme);

// Create a derived store that updates the theme based on the current route
export const theme = derived(page, ($page) => {
  const path = $page.url.pathname;
  const theme = themeColors[path] || defaultTheme;
  
  // Update the currentTheme store
  currentTheme.set(theme);
  
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
    const r = Math.min(1, Math.max(0, rgb.r + (Math.random() * 0.3 - 0.15)));
    const g = Math.min(1, Math.max(0, rgb.g + (Math.random() * 0.3 - 0.15)));
    const b = Math.min(1, Math.max(0, rgb.b + (Math.random() * 0.3 - 0.15)));
    
    colors.push({ r, g, b });
  }
  
  return colors;
} 