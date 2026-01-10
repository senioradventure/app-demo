import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:senior_circle/core/common/widgets/image_preview.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/attachment_picker_widget.dart';

class IndividualMessageInputField extends StatefulWidget {
  const IndividualMessageInputField({
    super.key,
    required this.replyTo,
    required this.imagePath,
    required this.filePath,
    required this.isSending,
    required this.onClearReply,
    required this.onPickImage,
    required this.onPickCamera,
    required this.onPickFile,
    required this.onRemoveImage,
    required this.onRemoveFile,
    required this.onSend,
    required this.onSendVoice,
  });

  final dynamic replyTo;
  final String? imagePath;
  final String? filePath;
  final bool isSending;

  final VoidCallback onClearReply;
  final Future<void> Function() onPickImage;
  final Future<void> Function() onPickCamera;
  final Future<void> Function() onPickFile;
  final VoidCallback onRemoveImage;
  final VoidCallback onRemoveFile;

  /// TEXT MESSAGE
  final void Function(String text) onSend;

  /// 🎤 VOICE MESSAGE
  final void Function(File audioFile) onSendVoice;

  @override
  State<IndividualMessageInputField> createState() =>
      _IndividualMessageInputFieldState();
}

class _IndividualMessageInputFieldState
    extends State<IndividualMessageInputField> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _recordingPath;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final ValueNotifier<List<double>> _waveform = ValueNotifier<List<double>>([]);
  Duration _recordingDuration = Duration.zero;
  Timer? _durationTimer;

  bool get _hasText => _controller.text.trim().isNotEmpty;
  bool get _hasAttachment =>
      widget.imagePath != null || widget.filePath != null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _amplitudeSubscription?.cancel();
    _durationTimer?.cancel();
    _waveform.dispose();
    _recorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  double _smoothAmplitude(double current, double previous) {
    const smoothingFactor = 0.7; // WhatsApp-like smoothing
    return previous * smoothingFactor + current * (1 - smoothingFactor);
  }

  /// 🎤 START RECORDING
  Future<void> _startRecording() async {
    if (_isRecording) return;

    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission denied'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final dir = Directory.systemTemp;
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    try {
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
          numChannels: 1,
        ),
        path: path,
      );

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _recordingDuration = Duration.zero;
      });

      // Reset waveform to empty
      _waveform.value = [];

      // ✅ Use stream subscription for smoother amplitude updates
      _amplitudeSubscription = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 150))
          .listen(
            (amp) {
              if (!_isRecording || !mounted) return;

              // Normalize amplitude to 0.0-1.0 range
              final normalized = ((amp.current + 50) / 50).clamp(0.1, 1.0);

              final bars = List<double>.from(_waveform.value);

              // Apply smoothing if we have previous values
              final smoothed = bars.isEmpty
                  ? normalized
                  : _smoothAmplitude(normalized, bars.last);

              // Add new bar (grows from right)
              bars.add(smoothed);

              // Limit to reasonable number of bars to prevent memory issues
              // With 150ms interval, 200 bars = 30 seconds of recording
              if (bars.length > 200) {
                bars.removeAt(0); // Remove oldest bar from left
              }

              _waveform.value = bars;
            },
            onError: (error) {
              debugPrint('Amplitude stream error: $error');
            },
            cancelOnError: false,
          );

      // Start duration timer
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || !_isRecording) {
          timer.cancel();
          return;
        }

        setState(() {
          _recordingDuration = Duration(
            seconds: _recordingDuration.inSeconds + 1,
          );
        });
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// ⏹ STOP & SEND
  Future<void> _stopRecording({bool send = true}) async {
    if (!_isRecording) return;

    // Cancel subscriptions first
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    _durationTimer?.cancel();
    _durationTimer = null;

    String? path;
    try {
      path = await _recorder.stop();
    } catch (e) {
      debugPrint('Stop recording error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    if (!mounted) return;

    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });

    // Reset waveform
    _waveform.value = [];

    if (send && path != null) {
      final file = File(path);
      if (await file.exists()) {
        widget.onSendVoice(file);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recording file not found'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: AppColors.lightGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// -------- REPLY --------
          if (widget.replyTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.replyTo.content.isNotEmpty
                          ? widget.replyTo.content
                          : 'Attachment',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: widget.onClearReply,
                  ),
                ],
              ),
            ),

          /// -------- IMAGE PREVIEW --------
          if (widget.imagePath != null)
            ImagePreview(
              selectedImage: XFile(widget.imagePath!),
              onRemove: widget.onRemoveImage,
            ),

          /// -------- FILE PREVIEW --------
          if (widget.filePath != null)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.filePath!.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: widget.onRemoveFile,
                  ),
                ],
              ),
            ),

          /// -------- INPUT ROW --------
          _isRecording ? _buildRecordingUI() : _buildNormalUI(),
        ],
      ),
    );
  }

  /// Normal input UI (not recording)
  Widget _buildNormalUI() {
    return Row(
      children: [
        IconButton(
          onPressed: () => showAttachmentPicker(
            context,
            widget.onPickImage,
            widget.onPickCamera,
            widget.onPickFile,
          ),
          icon: Icon(Icons.add, color: AppColors.buttonBlue),
        ),

        Expanded(
          child: TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type a message',
              border: InputBorder.none,
            ),
          ),
        ),

        /// SEND / MIC
        (_hasText || _hasAttachment)
            ? IconButton.filled(
                color: AppColors.buttonBlue,
                onPressed: widget.isSending
                    ? null
                    : () {
                        widget.onSend(_controller.text.trim());
                        _controller.clear();
                      },
                icon: const Icon(Icons.send, color: Colors.white),
              )
            : GestureDetector(
                onLongPressStart: (_) => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(send: true),
                onLongPressCancel: () => _stopRecording(send: false),
                child: CircleAvatar(
                  backgroundColor: AppColors.buttonBlue,
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              ),
      ],
    );
  }

  /// Recording UI - [Delete] [Waveform + Time] [Send]
  Widget _buildRecordingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// LEFT: Delete button
          IconButton(
            onPressed: () => _stopRecording(send: false),
            icon: const Icon(Icons.delete, color: Colors.red, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const SizedBox(width: 8),

          /// CENTER: Waveform + Duration
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Duration with pulsing red dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDuration(_recordingDuration),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Waveform
                SizedBox(
                  height: 40,
                  child: ValueListenableBuilder<List<double>>(
                    valueListenable: _waveform,
                    builder: (_, bars, __) {
                      return CustomPaint(
                        size: const Size(double.infinity, 40),
                        painter: WaveformPainter(bars),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// RIGHT: Send button
          IconButton.filled(
            onPressed: () => _stopRecording(send: true),
            icon: const Icon(Icons.send, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: AppColors.buttonBlue),
          ),
        ],
      ),
    );
  }
}

/// WhatsApp-style scrolling waveform painter (RIGHT TO LEFT)
class WaveformPainter extends CustomPainter {
  final List<double> bars;

  WaveformPainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    const barWidth = 3.0;
    const barGap = 3.0;
    const totalBarWidth = barWidth + barGap;

    final paint = Paint()
      ..color = AppColors.iconColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final centerY = size.height / 2;

    // Calculate how many bars we can fit in the available width
    final maxVisibleBars = (size.width / totalBarWidth).floor();

    // Determine which bars to display (only the most recent ones)
    final startIndex = bars.length > maxVisibleBars
        ? bars.length - maxVisibleBars
        : 0;
    final visibleBars = bars.sublist(startIndex);

    // ✅ Draw bars from RIGHT to LEFT (newest on right, oldest on left)
    for (int i = 0; i < visibleBars.length; i++) {
      // Calculate x position from right to left
      final x = size.width - (i * totalBarWidth) - (barWidth / 2);

      // Use reversed index to get bars in correct order
      final barIndex = visibleBars.length - 1 - i;

      // Clamp height to minimum 4.0 for visibility, max 80% of height
      final barHeight = (visibleBars[barIndex] * size.height * 0.8).clamp(
        4.0,
        size.height * 0.8,
      );

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    // Only repaint if the bars have actually changed
    return oldDelegate.bars != bars;
  }
}
