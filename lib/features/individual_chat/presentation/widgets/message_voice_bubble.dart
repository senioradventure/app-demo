import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class MessageVoiceBubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const MessageVoiceBubble({
    super.key,
    required this.audioUrl,
    required this.isMe,
  });

  @override
  State<MessageVoiceBubble> createState() => _MessageVoiceBubbleState();
}

class _MessageVoiceBubbleState extends State<MessageVoiceBubble> {
  late final AudioPlayer _player;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  double _speed = 1.0;

  final List<double> _speedOptions = [0.5, 1.0, 1.5, 2.0];

  // Stream subscriptions to cancel on dispose
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _init();
  }

  Future<void> _init() async {
    try {
      final d = await _player.setUrl(widget.audioUrl);
      if (d != null && mounted) {
        setState(() => _duration = d);
      }

      _positionSubscription = _player.positionStream.listen((p) {
        if (mounted) {
          setState(() => _position = p);
        }
      });

      _playerStateSubscription = _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state.playing);

          // Reset to start when playback completes
          if (state.processingState == ProcessingState.completed) {
            _player.seek(Duration.zero);
            _player.pause();
          }
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    // Cancel stream subscriptions BEFORE disposing the player
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _cycleSpeed() {
    final currentIndex = _speedOptions.indexOf(_speed);
    final nextIndex = (currentIndex + 1) % _speedOptions.length;
    final newSpeed = _speedOptions[nextIndex];

    if (mounted) {
      setState(() => _speed = newSpeed);
      _player.setSpeed(newSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isMe ? Colors.blueAccent.shade200 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ▶️ / ⏸
          InkWell(
            onTap: () async {
              if (_isPlaying) {
                await _player.pause();
              } else {
                await _player.play();
              }
            },
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.isMe ? Colors.white : Colors.black87,
              size: 28,
            ),
          ),

          const SizedBox(width: 8),

          /// 📈 PROGRESS BAR
          SizedBox(
            width: 120,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (v) {
                  final seek = _duration * v;
                  _player.seek(seek);
                },
                activeColor: widget.isMe ? Colors.white : Colors.black87,
                inactiveColor: widget.isMe ? Colors.white54 : Colors.black26,
              ),
            ),
          ),

          const SizedBox(width: 6),

          /// ⏱ TIME
          Text(
            _format(_position),
            style: TextStyle(
              fontSize: 12,
              color: widget.isMe ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(width: 8),

          /// 🔄 SPEED CONTROL
          InkWell(
            onTap: _cycleSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: widget.isMe
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_speed}x',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
