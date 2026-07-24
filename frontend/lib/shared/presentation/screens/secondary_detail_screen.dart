import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondaryDetailScreen extends StatelessWidget {
  final String type;

  const SecondaryDetailScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    String title = '';
    Widget body = const SizedBox.shrink();

    switch (type) {
      case 'my_farms':
        title = 'My Farms';
        body = _buildMyFarmsBody(context);
        break;
      case 'detailed_weather':
        title = 'Detailed Weather';
        body = _buildDetailedWeatherBody(context);
        break;
      case 'crop_analytics':
        title = 'Crop Analytics';
        body = _buildCropAnalyticsBody(context);
        break;
      case 'help_support':
        title = 'Help & Support';
        body = _buildHelpSupportBody(context);
        break;
      case 'user_guide':
        title = 'User Guide';
        body = _buildUserGuideBody(context);
        break;
      case 'privacy_policy':
        title = 'Privacy Policy';
        body = _buildPrivacyPolicyBody(context);
        break;
      case 'terms_conditions':
        title = 'Terms & Conditions';
        body = _buildTermsConditionsBody(context);
        break;
      case 'about':
        title = 'About KrishiOS';
        body = _buildAboutBody(context);
        break;
      default:
        title = 'Detail';
        body = const Center(child: Text('Under construction'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SafeArea(child: body),
    );
  }

  // --- MY FARMS BODY ---
  Widget _buildMyFarmsBody(BuildContext context) {
    final fields = [
      {'name': 'North Field', 'crop': 'Wheat A-12', 'moisture': 0.65, 'status': 'Optimal', 'statusColor': Colors.green},
      {'name': 'East Sector', 'crop': 'Rice Premium', 'moisture': 0.82, 'status': 'Saturated', 'statusColor': Colors.blue},
      {'name': 'South Plot', 'crop': 'Corn Hybrid', 'moisture': 0.58, 'status': 'Dry / Alert', 'statusColor': Colors.orange},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.primaryContainer.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                 CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 28,
                  child: Icon(Icons.terrain, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Farm Area', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text('35 Active Acres', style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Managed Fields', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
        const SizedBox(height: 8),
        ...fields.map((f) {
          final moistureVal = f['moisture'] as double;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(f['name'] as String, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (f['statusColor'] as Color).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          f['status'] as String,
                          style: TextStyle(
                            color: f['statusColor'] as Color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Crop: ${f['crop']}', style: AppTextStyles.bodySm.copyWith(color: AppColors.outline)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Soil Moisture', style: AppTextStyles.bodySm),
                      Text('${(moistureVal * 100).toInt()}%', style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: moistureVal,
                    backgroundColor: Colors.grey.shade200,
                    color: f['statusColor'] as Color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // --- WEATHER BODY ---
  Widget _buildDetailedWeatherBody(BuildContext context) {
    final metrics = [
      {'icon': Icons.wind_power, 'title': 'Wind Speed', 'value': '14 km/h SE'},
      {'icon': Icons.wb_sunny, 'title': 'UV Index', 'value': '4 (Moderate)'},
      {'icon': Icons.water_drop, 'title': 'Humidity', 'value': '71%'},
      {'icon': Icons.compress, 'title': 'Pressure', 'value': '1012 hPa'},
      {'icon': Icons.thermostat, 'title': 'Soil Temp', 'value': '26°C'},
      {'icon': Icons.cloudy_snowing, 'title': 'Precipitation', 'value': '0%'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.lightBlue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bachamari, West Bengal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Partly Cloudy', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Icon(Icons.cloud_queue, size: 48, color: Colors.blue),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('30°C', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Spacer(),
                    Text('Feels like 33°C', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Climate Metrics', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final m = metrics[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(m['icon'] as IconData, color: AppColors.primary, size: 24),
                    const SizedBox(height: 8),
                    Text(m['title'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(m['value'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // --- CROP ANALYTICS BODY ---
  Widget _buildCropAnalyticsBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Agronomic Yield Stats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Real-time statistical evaluation of crop categories.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        _buildStatProgressRow('Wheat Recovery Rate', 0.85, Colors.green),
        _buildStatProgressRow('Rice Disease Prevention', 0.92, AppColors.primary),
        _buildStatProgressRow('Corn Yield Projection', 0.74, Colors.orange),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child:  Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diagnosis Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _OverviewBadge(title: 'Active Scans', value: '14', color: AppColors.primary),
                    _OverviewBadge(title: 'Healthy', value: '10', color: Colors.green),
                    _OverviewBadge(title: 'Infected', value: '4', color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatProgressRow(String title, double val, Color col) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(val * 100).toInt()}%', style: TextStyle(color: col, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: val,
            color: col,
            backgroundColor: Colors.grey.shade200,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }


  // --- HELP & SUPPORT BODY ---
  Widget _buildHelpSupportBody(BuildContext context) {
    final faqItems = [
      {
        'q': 'How to capture a good leaf image?',
        'a': 'To ensure highly accurate AI predictions, place the affected crop leaf flat in direct, natural lighting. Hold the camera 15-20 cm away, focusing directly on the leaf symptoms or lesions. Avoid deep shadows, blurry backgrounds, or clutter in the viewport.'
      },
      {
        'q': 'Why was my scan rejected?',
        'a': 'Scans are rejected by the validation pipeline if the image does not contain a recognizable crop leaf. Ensure you are not scanning dirt, hands, wide landscapes, or unrelated items.'
      },
      {
        'q': 'Why is confidence low?',
        'a': 'Confidence scores may drop if the image is out of focus, taken in poor low-light environments, or if the symptoms do not clearly match known pathology indices in our database. Try scanning a different leaf showing clearer symptoms.'
      },
      {
        'q': 'Why does the app reject selfies?',
        'a': 'The on-device classification pipeline is trained specifically to validate crop leaf structures. Human faces, clothing, or general portrait orientations fail leaf layout checks and are rejected immediately.'
      },
      {
        'q': 'Which crops are supported?',
        'a': 'KrishiOS currently supports diagnosis for Apple (Scab, Rust, Healthy), Corn (Gray Leaf Spot, Common Rust, Northern Leaf Blight, Healthy), Pepper (Bacterial Spot, Healthy), Potato (Early Blight, Late Blight, Healthy), Tomato (Early Blight, Late Blight, Septoria Leaf Spot, Mosaic Virus, Healthy), and Cherry (Healthy, Powdery Mildew).'
      },
      {
        'q': 'Can I use KrishiOS offline?',
        'a': 'Yes! KrishiOS includes an optimized local ONNX Runtime classifier. If you are offline, the app switches to on-device evaluation, parsing leaf characteristics locally without cloud server requirements.'
      },
      {
        'q': 'How are recommendations generated?',
        'a': 'Recommendations are compiled from verified local agricultural guides and expert-approved treatment protocols. The advisory suggestions correspond dynamically to the identified crop disease.'
      },
      {
        'q': 'How accurate is the AI?',
        'a': 'Under ideal lighting and clear framing, our PyTorch-trained ONNX classification model achieves over 95% accuracy. However, results serve as educational advisory suggestions; consult local agronomists for high-stakes decisions.'
      },
      {
        'q': 'How do I report incorrect predictions?',
        'a': 'If you notice a misdiagnosis, copy the Scan ID and send an email explaining the crop type and actual symptoms using the "Email Support" button below. This feedback helps improve our model updates.'
      },
      {
        'q': 'How do I update the application?',
        'a': 'App updates are announced in the Notification Center. Download the latest version of KrishiOS from the official repository or app portal to receive refreshed ONNX models.'
      },
      {
        'q': 'How do I manage my scan history?',
        'a': 'Go to the Navigation Drawer and select "Scan History". You can search scans, tap to view recommendations, or swipe left on a scan card to delete it from the local secure storage.'
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
         Text(
          'Frequently Asked Questions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        ...faqItems.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          child: ExpansionTile(
            title: Text(
              item['q']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  item['a']!,
                  style: const TextStyle(height: 1.5, color: Colors.black87),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 24),
        Card(
          color: AppColors.primaryContainer.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.email_outlined, size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                 Text(
                  'Need Direct Support?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get in touch with our engineering team for technical bugs or agronomy feedback.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'zorodev.exe@gmail.com',
                      queryParameters: {
                        'subject': 'KrishiOS Support Request',
                      },
                    );
                    try {
                      final bool launched = await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
                      if (!launched) {
                        await Clipboard.setData(const ClipboardData(text: 'zorodev.exe@gmail.com'));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open email client. Copied support email to clipboard.')),
                          );
                        }
                      }
                    } catch (e) {
                      await Clipboard.setData(const ClipboardData(text: 'zorodev.exe@gmail.com'));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied support email to clipboard.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.email),
                  label: const Text('Email Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- USER GUIDE BODY ---
  Widget _buildUserGuideBody(BuildContext context) {
    final guideSections = [
      {
        'title': 'Welcome to KrishiOS',
        'icon': Icons.agriculture,
        'desc': 'KrishiOS is a premium, offline-first smart agronomy advisor that empowers farmers to diagnose crop diseases, monitor weather patterns, and consult agricultural intelligence without internet requirements.'
      },
      {
        'title': 'Getting Started',
        'icon': Icons.rocket_launch,
        'desc': 'Log in securely or enter via Guest Mode. Set up your language preferences upon onboarding to translate the entire mobile dashboard instantly.'
      },
      {
        'title': 'Navigation Overview',
        'icon': Icons.explore,
        'desc': 'Use the Bottom Navigation to switch between Home dashboard, Scan viewport, Health statistics, and the Farmers Community. Open the Navigation Drawer for settings, profile, and legal guides.'
      },
      {
        'title': 'Weather Dashboard',
        'icon': Icons.thermostat,
        'desc': 'Check localized humidity, rainfall forecasts, wind speeds, and UV index. Use weather alerts to plan irrigation schedules and nitrogen fertilizer windows.'
      },
      {
        'title': 'Disease Scanning',
        'icon': Icons.center_focus_weak,
        'desc': 'Tap the Scan tab, frame a crop leaf inside the viewport indicator, and capture. Ensure clean focus and natural lighting for high-fidelity evaluation.'
      },
      {
        'title': 'AI Diagnosis',
        'icon': Icons.psychology,
        'desc': 'KrishiOS routes photos to the FastAPI backend when connected, or evaluates locally using the integrated PyTorch-trained ONNX engine.'
      },
      {
        'title': 'Understanding Confidence',
        'icon': Icons.percent,
        'desc': 'Confidence scores indicate the model\'s certainty level. A confidence value above 80% represents a high-probability match. Low-light or blurry pictures return low confidence.'
      },
      {
        'title': 'Viewing Recommendations',
        'icon': Icons.assignment,
        'desc': 'Once diagnosed, the app provides treatment plans, biological control recommendations, and chemical applications corresponding to the crop pathology.'
      },
      {
        'title': 'Scan History Logs',
        'icon': Icons.history,
        'desc': 'Access your scan records through the Navigation Drawer. Review past diagnosis details or swipe to delete records from the local memory storage.'
      },
      {
        'title': 'Language Settings',
        'icon': Icons.translate,
        'desc': 'Select from English and major Indian languages. Setting changes translate the entire application shell, cards, alerts, and chatbot prompts.'
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications_active,
        'desc': 'Review app updates, announcements, and system alerts in the Notification Center. Future updates will introduce smart reminder schedules.'
      },
      {
        'title': 'Offline Features',
        'icon': Icons.wifi_off,
        'desc': 'Enable Offline Database Caching in settings to save diagnosis cards, local database metrics, and offline expert advisor logic directly on your phone.'
      },
      {
        'title': 'Settings Preferences',
        'icon': Icons.settings,
        'desc': 'Manage Theme preferences (Dark Mode / Light Mode), push notification status, offline synch toggles, language overrides, and clear cache triggers.'
      },
      {
        'title': 'Troubleshooting',
        'icon': Icons.build,
        'desc': 'If scans fail, verify camera permissions. For slow predictions, check network strength or toggle offline mode to use on-device ONNX runtime.'
      },
      {
        'title': 'Guide FAQ',
        'icon': Icons.help_outline,
        'desc': 'Refer to the Help & Support screen for detailed inquiries regarding neural classifier precision, crop species support, and agronomist advisory reporting.'
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
         Text(
          'KrishiOS User Guide',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Step-by-step documentation for smart farm management.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        ...guideSections.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final val = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(val['icon'] as IconData, color: AppColors.primary),
              ),
              title: Text(
                '$idx. ${val['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    val['desc'] as String,
                    style: const TextStyle(height: 1.5, color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- PRIVACY POLICY ---
  Widget _buildPrivacyPolicyBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child:  Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy & Data Protection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              SizedBox(height: 4),
              Text('Last Updated: July 2026', style: TextStyle(fontSize: 11, color: Colors.grey)),
              Divider(height: 24),
              
              Text('1. Information We Collect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'KrishiOS collects user profile data (name, email, role), geo-location parameters during scan operations, and leaf photography uploads. All transactions run securely.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('2. Camera Permission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'Camera authorization is required to capture images of diseased crop foliage. Photos are evaluated locally or routed to backend API routes, and are never shared without authorization.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('3. Location Permission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'We query coordinates during scans to catalog disease spreads and map stats indicators. Location access is optional and works offline.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('4. Offline AI Processing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'Your leaves can be evaluated completely offline using our ONNX runtime model. In offline mode, crop diagnosis occurs entirely on your device, and no photos are sent over networks.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('5. Local Storage & Encryption', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'Scan results, localized weather records, and drafts are cached locally in encrypted Hive boxes. Data is isolated inside sandbox containers.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('6. User Rights & Data Retention', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'You retain ownership of your agronomy history. You can wipe records from the settings cache or clear scan logs at any time. Accounts can be deleted upon request.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('7. Contact Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'For privacy requests, reach our compliance team using the email support button in the Help & Support center.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TERMS AND CONDITIONS ---
  Widget _buildTermsConditionsBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child:  Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              SizedBox(height: 4),
              Text('Last Updated: July 2026', style: TextStyle(fontSize: 11, color: Colors.grey)),
              Divider(height: 24),

              Text('1. Acceptable Use', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'KrishiOS grants users a limited license to execute neural leaf checks, check analytics, and interact with the farming community. Users agree not to upload malicious payloads or bypass device security layers.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('2. AI & Recommendation Disclaimer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'KrishiOS neural outputs function purely as general advisory diagnostics. We make no guarantees regarding diagnostic accuracy, total crop security, or treatment solutions. High-stakes crop care should be verified with regional agronomists.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('3. Limitation of Liability', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'The KrishiOS team, including developers and cloud sponsors, assumes no liability for harvest failures, yield reductions, chemical misapplications, or business losses resulting from advisor usage.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('4. User Responsibilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'Farmers are responsible for validating local regulations regarding pesticide spraying and fertilizer usage. Ensure that diagnostic suggestions comply with state and national farming laws.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('5. Intellectual Property & Updates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'All application source code, neural assets, and UI components are protected under intellectual property covenants. Model parameters undergo periodic updates to support additional crops.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 16),

              Text('6. Agreement Termination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'Violation of access policies or server abuse will result in instant profile termination. Terms are governed by local statutes.',
                style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ABOUT BODY ---
  Widget _buildAboutBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/brand/app_icon.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'KrishiOS',
                style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Smart Agronomy Platform',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Divider(height: 32),

               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mission & Vision', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text(
                    'Our mission is to democratize agricultural intelligence by putting artificial intelligence in the hands of every farmer, online or offline. We envision sustainable, disease-free crops managed via smart mobile diagnostic assistance.',
                    style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 16),

                  Text('Key Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text(
                    '• Real-time leaf disease diagnosis\n• On-device PyTorch/ONNX runtime model\n• Localized weather forecast metrics\n• Multilingual chat support in major Indian languages\n• Crop analytics dashboard\n• Interactive farmer community boards',
                    style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 16),

                  Text('Technology Stack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text(
                    '• Frontend: Flutter (Dart)\n• Backend: FastAPI (Python)\n• AI Core: PyTorch & ONNX Runtime\n• Database: Cloud Firestore, Hive Local Cache',
                    style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 16),

                  Text('Future Roadmap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text(
                    '• Phase 2: Offline model update manifest server\n• Expanded crop disease classification indexes\n• Smart reminder alarms for fertilizer & spraying\n• Satellite imagery crop monitoring integrations',
                    style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 16),

                  Text('Open Source Acknowledgements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text(
                    'Special thanks to the developer community for maintaining packages like Flutter Riverpod, Hive, ONNX Runtime, and PyTorch Mobile. You make offline AI possible.',
                    style: TextStyle(height: 1.5, fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                'Version: 1.0.0 (Production Release)',
                style: AppTextStyles.bodySm.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewBadge extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _OverviewBadge({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
