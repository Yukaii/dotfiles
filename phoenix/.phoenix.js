var BASE = 10

function targetSize (deltaX, deltaY) {
	return function (point) {
		return {
			x: point.x + deltaX * BASE,
			y: point.y + deltaY * BASE
		}
	}
}

var deltas = [
	['L', [1, 0]],
	['H', [-1, 0]],
	['K', [0, -1]],
	['J', [0, 1]]
]

deltas.forEach(function (data) {
	var key = data[0]
	var delta = data[1]

	Key.on(key, [ 'cmd', 'alt', 'shift' ], function () {
		var window = Window.focused();

		if (window) {
			var topLeft = window.topLeft()

			window.setTopLeft(
				targetSize(delta[0], delta[1])(topLeft)
			)
		}
	})

	Key.on(key, ['cmd', 'alt', 'ctrl'], function () {
		var window = Window.focused();

		if (window) {
			var frame = window.frame()

			window.setFrame(
				targetFrame(delta[0], delta[1])(frame)
			)
		}
	})
})

function targetFrame (deltaWidth, deltaHeight) {
	return function (frame) {
		return {
			x: frame.x,
			y: frame.y,
			width: frame.width + deltaWidth * BASE * 2,
			height: frame.height + deltaHeight * BASE * 2
		}
	}
}
