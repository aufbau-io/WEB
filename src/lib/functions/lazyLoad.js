// See how the options work here: https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API
let options = {
	root: null,
	rootMargin: '0px',
	threshold: 0
};

export const lazyLoad = (image, src) => {
	const isPreloaded = (src) => {
		return !!document.querySelector(`link[rel="preload"][href="${src}"]`);
	};

	const loaded = () => {
		if (!isPreloaded(src)) {
			image.style.opacity = '1';
		}
	};

	const observer = new IntersectionObserver((entries) => {
		if (entries[0].isIntersecting) {
			// console.log('an image has loaded');
			image.src = src;

			if (isPreloaded(src)) {
				// Do nothing if the image is preloaded; it should appear instantly.
			} else {
				image.addEventListener('load', loaded);
			}
		}
	}, options);
	observer.observe(image); // intersection observer

	return {
		destroy() {
			image.removeEventListener('load', loaded); // clean up the event listener
		}
	};
};
