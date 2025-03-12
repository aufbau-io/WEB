import { writable } from 'svelte/store';

// Create a custom writable store with isSet flag
function createFlaggedStore(initialValue) {
    const { subscribe, set: originalSet, update } = writable(initialValue);
    let isSet = false;
    
    function set(value) {
        isSet = true;
        originalSet(value);
    }
    
    return {
        subscribe,
        set,
        update,
        get isSet() { return isSet; }
    };
}

export const userType = writable(null);
export const screenType = writable(null);
export const isIframe = createFlaggedStore(false);

export const DARK_PAGES = ['/ml-network'];
export const darkMode = writable(false);

export const lobbySelected = writable(false);
export const mouseOnLink = writable(false);

// Use a single store for mouse position to reduce updates
export const mousePosition = writable({ x: 0, y: 0, z: 0 });
export const screenSize = writable({ width: 0, height: 0 });
