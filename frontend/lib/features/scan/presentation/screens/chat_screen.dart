import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/models/chat_message.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/presentation/widgets/voice_waveform.dart';
import 'package:krishios/shared/services/kavya/voice_service.dart';
import 'package:krishios/shared/services/kavya/voice_settings.dart';
import '../providers/chat_provider.dart';
import '../providers/scan_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String scanId;
  final String cropName;
  final String diagnosis;
  final String? initialQuery;
  final bool startListeningOnLaunch;

  const ChatScreen({
    super.key,
    required this.scanId,
    required this.cropName,
    required this.diagnosis,
    this.initialQuery,
    this.startListeningOnLaunch = false,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialQuery!);
      });
    } else if (widget.startListeningOnLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final activeLang = ref.read(languageProvider);
        ref.read(voiceServiceProvider.notifier).startListening(
          languageCode: activeLang,
          onResult: (spokenText) {
            _messageController.text = spokenText;
            _sendMessage(spokenText);
          },
        );
      });
    }
  }

  @override
  void dispose() {
    // Suspend any active TTS operations when user exits
    ref.read(voiceServiceProvider.notifier).stopSpeaking();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _messageController.clear();

    if (!mounted) return;
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    final activeLang = ref.read(languageProvider);

    try {
      await ref.read(chatHistoryProvider(widget.scanId).notifier).sendMessage(
            query: text,
            scanId: widget.scanId,
            languageCode: activeLang,
          );
      final history = ref.read(chatHistoryProvider(widget.scanId));
      if (history.isNotEmpty && !history.last.isUser) {
        ref.read(voiceServiceProvider.notifier).speak(history.last.text, activeLang);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
  }

  List<String> _getQuickSuggestions(String langCode) {
    switch (langCode) {
      case 'hi':
        return ['जैविक उपचार', 'रासायनिक उपचार', 'बचाव के उपाय'];
      case 'te':
        return ['సేంద్రీయ చికిత్స', 'రसायన చికిత్స', 'నివారణ చికిత్స'];
      case 'ta':
        return ['இயற்கை சிகிச்சை', 'ரசாயன சிகிச்சை', 'தடுப்பு முறை'];
      case 'kn':
        return ['ಸಾವಯವ ಚಿಕಿತ್ಸೆ', 'ರಾಸಾಯನಿಕ ಚಿಕಿತ್ಸೆ', 'ತಡೆಗಟ್ಟುವಿಕೆ'];
      case 'mr':
        return ['सेंद्रिय उपचार', 'रासायनिक उपचार', 'बचाव उपाय'];
      case 'bn':
        return ['জৈব চিকিৎসা', 'রাসায়নিক চিকিৎসা', 'প্রতিরোধমূলক ব্যবস্থা'];
      default:
        return ['Organic Care', 'Chemical Spray', 'Prevention Guide'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeLang = ref.watch(languageProvider);
    final chatHistory = ref.watch(chatHistoryProvider(widget.scanId));
    final manager = ref.watch(aiEngineManagerProvider);
    final voiceState = ref.watch(voiceServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              radius: 18,
              child:  Icon(
                Icons.spa,
                color: AppColors.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kavya',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  manager.isUsingLocal ? 'Kavya Offline Brain' : 'Kavya FastAPI Cloud',
                  style: AppTextStyles.labelSm.copyWith(
                    color: manager.isUsingLocal ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_voice_rounded),
            onPressed: () => _showVoiceSettingsBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(chatHistoryProvider(widget.scanId).notifier).clear(activeLang);
              ref.read(voiceServiceProvider.notifier).stopSpeaking();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history cleared.')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final message = chatHistory[index];
                return _buildMessageBubble(message, activeLang);
              },
            ),
          ),

          // Voice Waveform Overlay
          if (voiceState != VoiceState.ready)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: VoiceWaveform(state: voiceState),
            ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.surfaceContainer,
                    radius: 14,
                    child: Icon(Icons.spa, size: 14, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Kavya is thinking...',
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          // Quick Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: _getQuickSuggestions(activeLang).map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label: Text(suggestion),
                    labelStyle: AppTextStyles.labelSm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                    side: BorderSide(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
                    onPressed: () => _sendMessage(suggestion),
                  ),
                );
              }).toList(),
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Microphone / Push-to-Talk button
                  CircleAvatar(
                    backgroundColor: voiceState == VoiceState.listening
                        ? Colors.redAccent.withValues(alpha: 0.2)
                        : AppColors.surfaceContainerLow,
                    radius: 22,
                    child: IconButton(
                      icon: Icon(
                        voiceState == VoiceState.listening ? Icons.mic : Icons.mic_none,
                        color: voiceState == VoiceState.listening ? Colors.red : AppColors.primary,
                      ),
                      onPressed: () {
                        final voiceNotifier = ref.read(voiceServiceProvider.notifier);
                        if (voiceState == VoiceState.listening) {
                          voiceNotifier.stopListening();
                        } else {
                          voiceNotifier.startListening(
                            languageCode: activeLang,
                            onResult: (spokenText) {
                              _messageController.text = spokenText;
                              _sendMessage(spokenText);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: AppTextStyles.bodyMd,
                      decoration: InputDecoration(
                        hintText: TranslationService.translate('chat_hint', activeLang),
                        hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 22,
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: AppColors.onPrimary, size: 20),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, String activeLang) {
    final isMe = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.2),
                  radius: 16,
                  child: Icon(Icons.spa, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: isMe ? AppColors.onPrimary : AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          DateFormat('hh:mm a').format(message.timestamp),
                          style: AppTextStyles.labelSm.copyWith(
                            color: isMe
                                ? AppColors.onPrimaryContainer.withValues(alpha: 0.7)
                                : AppColors.outline,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.secondaryContainer,
                  radius: 16,
                  child: Text(
                    'U',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, size: 16, color: AppColors.outline),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message copied to clipboard.')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, size: 16, color: AppColors.outline),
                    onPressed: () => Share.share(message.text),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, size: 16, color: AppColors.outline),
                    onPressed: () {
                      ref.read(voiceServiceProvider.notifier).speak(message.text, activeLang);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.autorenew, size: 16, color: AppColors.outline),
                    onPressed: () {
                      // Attempt to regenerate response by querying previous human turn if any
                      _sendMessage(message.text);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showVoiceSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final settings = ref.watch(voiceSettingsProvider);
            final voiceState = ref.watch(voiceServiceProvider);
            final voiceNotifier = ref.read(voiceServiceProvider.notifier);
            final settingsNotifier = ref.read(voiceSettingsProvider.notifier);

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kavya Voice Assistant Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Voice Enabled'),
                    subtitle: const Text('Enable/disable Kavya voice features'),
                    value: settings.voiceEnabled,
                    onChanged: (val) => settingsNotifier.updateVoiceEnabled(val),
                  ),
                  SwitchListTile(
                    title: const Text('Auto Speak Responses'),
                    subtitle: const Text('Read AI responses aloud automatically'),
                    value: settings.autoSpeak,
                    onChanged: (val) => settingsNotifier.updateAutoSpeak(val),
                  ),
                  SwitchListTile(
                    title: const Text('Continuous Hands-free Mode'),
                    subtitle: const Text('Keep conversation active after speaking responses'),
                    value: settings.continuousMode,
                    onChanged: (val) {
                      voiceNotifier.setContinuousMode(val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Speech Speed:'),
                            Text('${settings.speechSpeed.toStringAsFixed(2)}x'),
                          ],
                        ),
                        Slider(
                          value: settings.speechSpeed,
                          min: 0.1,
                          max: 1.0,
                          activeColor: AppColors.primary,
                          onChanged: (val) => settingsNotifier.updateSpeechSpeed(val),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Speech Pitch:'),
                            Text(settings.speechPitch.toStringAsFixed(2)),
                          ],
                        ),
                        Slider(
                          value: settings.speechPitch,
                          min: 0.5,
                          max: 2.0,
                          activeColor: AppColors.primary,
                          onChanged: (val) => settingsNotifier.updateSpeechPitch(val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Voice Status: ${voiceState.name.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
