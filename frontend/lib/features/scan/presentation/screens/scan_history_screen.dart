import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/scan_result.dart';
import '../providers/scan_provider.dart';
import 'scan_result_screen.dart';

class ScanHistoryScreen extends ConsumerStatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  ConsumerState<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends ConsumerState<ScanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All'; // All, Healthy, Diseased

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(ScanResult scan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Scan Record'),
        content: Text('Are you sure you want to remove the scan for "${scan.cropName}" from your database?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(scanRepositoryProvider).deleteScan(scan.id);
              ref.invalidate(scanHistoryProvider);
              ref.invalidate(averageHealthProvider);
              ref.invalidate(weeklyScanCountProvider);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Scan record deleted.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scans = ref.watch(scanHistoryProvider);
    final query = _searchController.text.toLowerCase();

    final filteredScans = scans.where((scan) {
      final matchesQuery = scan.cropName.toLowerCase().contains(query) ||
          scan.diagnosis.toLowerCase().contains(query) ||
          scan.fieldName.toLowerCase().contains(query);

      final isHealthy = scan.diagnosis.toLowerCase().contains('healthy');
      if (_selectedFilter == 'Healthy') {
        return matchesQuery && isHealthy;
      } else if (_selectedFilter == 'Diseased') {
        return matchesQuery && !isHealthy;
      }
      return matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scan Logs'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by crop, field, disease...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerHigh,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Healthy'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Diseased'),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: filteredScans.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredScans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, idx) {
                      final scan = filteredScans[idx];
                      final isHealthy = scan.diagnosis.toLowerCase().contains('healthy');
                      final color = isHealthy ? AppColors.primary : AppColors.error;

                      return Dismissible(
                        key: Key(scan.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          _confirmDelete(scan);
                          return false; // prevent auto-dismiss before dialog confirm
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isHealthy ? Icons.eco : Icons.pest_control,
                                color: color,
                              ),
                            ),
                            title: Text(
                              '${scan.cropName} (${scan.fieldName})',
                              style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${scan.diagnosis} • ${Formatters.relativeTime(scan.scannedAt)}',
                              style: AppTextStyles.bodySm,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ScanResultScreen(scan: scan),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          filter,
          style: AppTextStyles.labelSm.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 72,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No scan history found',
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No results match your search keywords.'
                  : 'Start scanning your crops using the scan viewport tool to view diagnosis details here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
