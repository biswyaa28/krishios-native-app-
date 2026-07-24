import 'dart:math';
import 'package:flutter/material.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/services/kavya/voice_service.dart';

class VoiceWaveform extends StatefulWidget {
  final VoiceState state;

  const VoiceWaveform({super.key, required this.state});

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = List.generate(15, (_) => 10.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        if (widget.state == VoiceState.listening || widget.state == VoiceState.speaking) {
          setState(() {
            for (int i = 0; i < _barHeights.length; i++) {
            final waveScale = widget.state == VoiceState.listening ? 40 : 25;
            _barHeights[i] = 10 + sin(_controller.value * 2 * pi + i) * Random().nextDouble() * waveScale;
          }
        });
      }
    });

    if (widget.state != VoiceState.ready) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == VoiceState.ready) {
        _controller.stop();
        setState(() {
          _barHeights.fillRange(0, _barHeights.length, 10.0);
        });
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == VoiceState.thinking) {
      return  SizedBox(
        height: 60,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barHeights.length, (idx) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: 4,
            height: max(5, _barHeights[idx]),
            decoration: BoxDecoration(
              color: widget.state == VoiceState.speaking
                  ? AppColors.primary
                  : (widget.state == VoiceState.listening ? Colors.redAccent : Colors.grey.shade400),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
