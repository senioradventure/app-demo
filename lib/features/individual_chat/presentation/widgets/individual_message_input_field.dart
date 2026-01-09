import 'dart:io';
import 'dart:async';
import 'dart:math' as math;

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
  Timer? _amplitudeTimer;
  List<double> _amplitudes = [];
  Duration _recordingDuration = Duration.zero;
  Timer? _durationTimer;

  bool get _hasText => _controller.text.trim().isNotEmpty;
  bool get _hasAttachment =>
      widget.imagePath != null || widget.filePath != null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _amplitudeTimer?.cancel();
    _durationTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  /// 🎤 START RECORDING
  Future<void> _startRecording() async {
    if (_isRecording) return;

    if (!await _recorder.hasPermission()) return;

    final dir = Directory.systemTemp;
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
        numChannels: 1,
      ),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordingPath = path;
      _amplitudes = [];
      _recordingDuration = Duration.zero;
    });

    // Start amplitude monitoring
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) async {
      final amplitude = await _recorder.getAmplitude();
      if (mounted && _isRecording) {
        setState(() {
          // Normalize amplitude to 0.0-1.0 range
          final normalized = (amplitude.current + 50) / 50;
          final clamped = normalized.clamp(0.0, 1.0);
          _amplitudes.add(clamped);

          // Keep only last 50 samples for display
          if (_amplitudes.length > 50) {
            _amplitudes.removeAt(0);
          }
        });
      }
    });

    // Start duration timer
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording) {
        setState(() {
          _recordingDuration = Duration(
            seconds: _recordingDuration.inSeconds + 1,
          );
        });
      }
    });
  }

  /// ⏹ STOP & SEND
  Future<void> _stopRecording({bool send = true}) async {
    if (!_isRecording) return;

    _amplitudeTimer?.cancel();
    _durationTimer?.cancel();

    String? path;
    try {
      path = await _recorder.stop();
    } catch (_) {
      return;
    }

    setState(() {
      _isRecording = false;
      _amplitudes = [];
      _recordingDuration = Duration.zero;
    });

    if (send && path != null && File(path).existsSync()) {
      widget.onSendVoice(File(path));
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
                // Duration
                Text(
                  _formatDuration(_recordingDuration),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                // Waveform
                SizedBox(
                  height: 40,
                  child: CustomPaint(
                    size: const Size(double.infinity, 40),
                    painter: RecordingWaveformPainter(amplitudes: _amplitudes),
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

class RecordingWaveformPainter extends CustomPainter {
  final List<double> amplitudes;

  RecordingWaveformPainter({required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    const barWidth = 3.0;
    const spacing = 2.0;
    final maxBars = (size.width / (barWidth + spacing)).floor();

    // Show only the most recent bars that fit
    final startIndex = math.max(0, amplitudes.length - maxBars);
    final visibleAmplitudes = amplitudes.sublist(startIndex);

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < visibleAmplitudes.length; i++) {
      final x = i * (barWidth + spacing);
      final barHeight = (visibleAmplitudes[i] * size.height * 0.8).clamp(
        4.0,
        size.height,
      );
      final centerY = size.height / 2;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RecordingWaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
