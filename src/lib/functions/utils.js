export function getDeviceType() {
	const width =
		window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

	if ('ontouchstart' in window || navigator.maxTouchPoints > 0 || navigator.msMaxTouchPoints > 0) {
		// This is a device which supports touch
		if (width <= 767) {
			// Mobile
			return 1;
		} else {
			// Tablet
			return 2;
		}
	} else {
		// This is likely a laptop or desktop
		return 3;
	}
}

export function getScreenSize() {
	const width = window.innerWidth;
	const height = window.innerHeight;
	return { width, height };
}
