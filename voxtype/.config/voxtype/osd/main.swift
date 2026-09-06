import Cocoa
import Foundation
import Darwin

// MARK: - Audio Frame Wire Structure (16 bytes, native endian)
struct AudioFrame {
    var seq: UInt32
    var min: Float32
    var max: Float32
    var peakDbfs: Float32
}

// MARK: - Audio Socket Client
final class AudioSocketClient {
    private var socketFd: Int32 = -1
    private var readSource: DispatchSourceRead?
    private let socketPath = "/tmp/voxtype/audio.sock"
    var onLevelUpdate: ((Float) -> Void)?

    func start() {
        stop()
        let fd = socket(AF_UNIX, SOCK_STREAM, 0)
        guard fd >= 0 else { return }

        // Set non-blocking
        let flags = fcntl(fd, F_GETFL, 0)
        _ = fcntl(fd, F_SETFL, flags | O_NONBLOCK)

        var addr = sockaddr_un()
        addr.sun_len = UInt8(MemoryLayout<sockaddr_un>.size)
        addr.sun_family = sa_family_t(AF_UNIX)

        withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            _ = socketPath.withCString { cstr in
                strncpy(ptr, cstr, 104)
            }
        }

        let res = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                connect(fd, sa, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }

        if res != 0 && errno != EINPROGRESS {
            close(fd)
            return
        }

        self.socketFd = fd

        let source = DispatchSource.makeReadSource(fileDescriptor: fd, queue: DispatchQueue.global(qos: .userInteractive))
        source.setEventHandler { [weak self] in
            guard let self = self else { return }
            var buffer = [UInt8](repeating: 0, count: 256)
            let bytesRead = Darwin.read(self.socketFd, &buffer, buffer.count)
            guard bytesRead >= 16 else { return }

            let frameCount = bytesRead / 16
            let lastFrameOffset = (frameCount - 1) * 16

            let frame = buffer.withUnsafeBytes { rawPtr -> AudioFrame in
                let base = rawPtr.baseAddress!.advanced(by: lastFrameOffset)
                return base.load(as: AudioFrame.self)
            }

            // Map dBFS (-55 dBFS to 0 dBFS) to 0.0 ... 1.0
            let clamped = max(-55.0, min(0.0, frame.peakDbfs))
            let normalized = Float((clamped + 55.0) / 55.0)

            DispatchQueue.main.async {
                self.onLevelUpdate?(normalized)
            }
        }

        source.setCancelHandler {
            close(fd)
        }

        source.resume()
        self.readSource = source
    }

    func stop() {
        if let source = readSource {
            source.cancel()
            readSource = nil
        } else if socketFd >= 0 {
            close(socketFd)
        }
        socketFd = -1
    }

    deinit {
        stop()
    }
}

// MARK: - Waveform View
final class WaveformView: NSView {
    private var levels: [CGFloat] = [0.15, 0.25, 0.4, 0.25, 0.15]
    private var targetLevel: CGFloat = 0.0
    private var displayTimer: Timer?

    func startAnimation() {
        stopAnimation()
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.stepAnimation()
        }
    }

    func stopAnimation() {
        displayTimer?.invalidate()
        displayTimer = nil
        targetLevel = 0.0
        levels = [0.15, 0.25, 0.4, 0.25, 0.15]
        needsDisplay = true
    }

    func setAudioLevel(_ level: Float) {
        targetLevel = CGFloat(pow(level, 0.75))
    }

    private func stepAnimation() {
        let multipliers: [CGFloat] = [0.45, 0.75, 1.0, 0.75, 0.45]
        for i in 0..<levels.count {
            let base: CGFloat = 0.15
            let target = base + (targetLevel * (1.0 - base) * multipliers[i])
            let rate: CGFloat = target > levels[i] ? 0.35 : 0.12
            levels[i] += (target - levels[i]) * rate
        }

        targetLevel = max(0.0, targetLevel * 0.92)
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }

        let barCount = levels.count
        let barWidth: CGFloat = 3.0
        let barSpacing: CGFloat = 3.5
        let totalWidth = CGFloat(barCount) * barWidth + CGFloat(barCount - 1) * barSpacing
        let startX = (bounds.width - totalWidth) / 2.0
        let centerY = bounds.height / 2.0
        let maxHeight = bounds.height * 0.75
        let minHeight: CGFloat = 4.0

        for i in 0..<barCount {
            let x = startX + CGFloat(i) * (barWidth + barSpacing)
            let h = max(minHeight, min(maxHeight, levels[i] * maxHeight))
            let y = centerY - (h / 2.0)
            let barRect = CGRect(x: x, y: y, width: barWidth, height: h)
            let path = CGPath(roundedRect: barRect, cornerWidth: barWidth / 2.0, cornerHeight: barWidth / 2.0, transform: nil)

            context.setFillColor(CGColor(srgbRed: 1.0, green: 0.28, blue: 0.25, alpha: 0.9))
            context.addPath(path)
            context.fillPath()
        }
    }

    deinit {
        displayTimer?.invalidate()
    }
}

// MARK: - Pulsing Recording Dot View
final class PulsingDotView: NSView {
    private let dotLayer = CALayer()
    private let haloLayer = CALayer()
    private var isPulsing = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        setupLayers()
    }

    private func setupLayers() {
        guard let layer = self.layer else { return }

        let dotSize: CGFloat = 8.0
        let haloSize: CGFloat = 16.0
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        haloLayer.bounds = CGRect(x: 0, y: 0, width: haloSize, height: haloSize)
        haloLayer.position = center
        haloLayer.cornerRadius = haloSize / 2.0
        haloLayer.backgroundColor = NSColor.systemRed.withAlphaComponent(0.35).cgColor
        layer.addSublayer(haloLayer)

        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        dotLayer.position = center
        dotLayer.cornerRadius = dotSize / 2.0
        dotLayer.backgroundColor = NSColor.systemRed.cgColor
        layer.addSublayer(dotLayer)
    }

    func startPulsing() {
        guard !isPulsing else { return }
        isPulsing = true

        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 0.85
        pulseAnimation.toValue = 1.35
        pulseAnimation.duration = 0.8
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        haloLayer.add(pulseAnimation, forKey: "pulse")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.7
        opacityAnimation.toValue = 0.2
        opacityAnimation.duration = 0.8
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        haloLayer.add(opacityAnimation, forKey: "opacity")
    }

    func stopPulsing() {
        isPulsing = false
        haloLayer.removeAllAnimations()
    }
}

// MARK: - Floating OSD Overlay Panel
final class OSDOverlayPanel: NSPanel {
    private let visualEffectView = NSVisualEffectView()
    private let dotView = PulsingDotView(frame: NSRect(x: 14, y: 13, width: 16, height: 16))
    private let statusLabel = NSTextField(labelWithString: "Listening...")
    private let waveformView = WaveformView(frame: NSRect(x: 148, y: 6, width: 38, height: 30))
    private let spinner = NSProgressIndicator(frame: NSRect(x: 154, y: 13, width: 16, height: 16))

    init() {
        let contentRect = NSRect(x: 0, y: 0, width: 196, height: 42)
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        isFloatingPanel = true
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.statusWindow)) + 1)
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        ignoresMouseEvents = true

        setupView(contentRect: contentRect)
    }

    private func setupView(contentRect: NSRect) {
        visualEffectView.frame = contentRect
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = contentRect.height / 2.0
        visualEffectView.layer?.masksToBounds = true
        visualEffectView.layer?.borderWidth = 1.0
        visualEffectView.layer?.borderColor = NSColor.white.withAlphaComponent(0.18).cgColor

        // Status Label
        statusLabel.frame = NSRect(x: 36, y: 12, width: 104, height: 18)
        statusLabel.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        statusLabel.textColor = NSColor.white.withAlphaComponent(0.95)
        statusLabel.alignment = .left

        // Spinner for transcribing
        spinner.style = .spinning
        spinner.controlSize = .small
        spinner.isDisplayedWhenStopped = false
        spinner.appearance = NSAppearance(named: .darkAqua)

        visualEffectView.addSubview(dotView)
        visualEffectView.addSubview(statusLabel)
        visualEffectView.addSubview(waveformView)
        visualEffectView.addSubview(spinner)

        contentView = visualEffectView
    }

    func setAudioLevel(_ level: Float) {
        waveformView.setAudioLevel(level)
    }

    func setMode(recording: Bool, transcribing: Bool) {
        if recording {
            dotView.isHidden = false
            dotView.startPulsing()
            waveformView.isHidden = false
            waveformView.startAnimation()
            spinner.stopAnimation(nil)
            spinner.isHidden = true
            statusLabel.stringValue = "Listening..."
        } else if transcribing {
            dotView.stopPulsing()
            dotView.isHidden = true
            waveformView.stopAnimation()
            waveformView.isHidden = true
            spinner.isHidden = false
            spinner.startAnimation(nil)
            statusLabel.stringValue = "Transcribing..."
        } else {
            dotView.stopPulsing()
            waveformView.stopAnimation()
            spinner.stopAnimation(nil)
        }
    }

    func showAnimated() {
        positionOnActiveScreen()
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.animator().alphaValue = 1.0
        }
        orderFrontRegardless()
    }

    func hideAnimated() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.animator().alphaValue = 0.0
        }, completionHandler: { [weak self] in
            if self?.alphaValue == 0.0 {
                self?.orderOut(nil)
            }
        })
    }

    private func positionOnActiveScreen() {
        let screen = NSScreen.main ?? NSScreen.screens.first ?? NSScreen()
        let screenFrame = screen.visibleFrame
        let x = screenFrame.midX - (frame.width / 2.0)
        let y = screenFrame.minY + 48.0
        setFrameOrigin(NSPoint(x: x, y: y))
    }
}

// MARK: - State Monitor & App Coordinator
final class AppCoordinator {
    static let shared = AppCoordinator()

    private let panel = OSDOverlayPanel()
    private let socketClient = AudioSocketClient()
    private let statePath = "/tmp/voxtype/state"
    private var timer: Timer?
    private var currentState: String = "idle"

    init() {
        socketClient.onLevelUpdate = { [weak self] level in
            self?.panel.setAudioLevel(level)
        }
    }

    func start() {
        panel.alphaValue = 0.0

        // Poll state file every 50ms for low latency
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.checkState()
        }

        checkState()
    }

    private func checkState() {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: statePath)),
              let rawString = String(data: data, encoding: .utf8) else {
            if currentState != "idle" {
                transitionTo(state: "idle")
            }
            return
        }

        let state = rawString.trimmingCharacters(in: .whitespacesAndNewlines)
        if state != currentState {
            transitionTo(state: state)
        }
    }

    private func transitionTo(state: String) {
        currentState = state

        switch state {
        case "recording":
            panel.setMode(recording: true, transcribing: false)
            socketClient.start()
            panel.showAnimated()
        case "transcribing":
            panel.setMode(recording: false, transcribing: true)
            socketClient.stop()
            panel.showAnimated()
        case "idle":
            fallthrough
        default:
            panel.setMode(recording: false, transcribing: false)
            socketClient.stop()
            panel.hideAnimated()
        }
    }
}

// MARK: - Main Application Entry
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        AppCoordinator.shared.start()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Handle SIGINT and SIGTERM cleanly
signal(SIGINT) { _ in exit(0) }
signal(SIGTERM) { _ in exit(0) }

app.run()
