import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/reports_cubit.dart';
import '../bloc/reports_state.dart';

class ShopProfileReportsPage extends StatefulWidget {
  final String tenantId;

  const ShopProfileReportsPage({
    super.key,
    required this.tenantId,
  });

  @override
  State<ShopProfileReportsPage> createState() => _ShopProfileReportsPageState();
}

class _ShopProfileReportsPageState extends State<ShopProfileReportsPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _fetchReports() {
    context.read<ReportsCubit>().loadReports(
          widget.tenantId,
          startDate: _startDate,
          endDate: _endDate,
        );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        // set end date to end of day
        _endDate = DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        );
      });
      _fetchReports();
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Profile & Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchReports,
          ),
        ],
      ),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReportsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchReports,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ReportsLoaded) {
            final profile = state.shopProfile;
            final sales = state.salesSummary;
            final purchase = state.purchaseSummary;

            return RefreshIndicator(
              onRefresh: () async => _fetchReports(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Shop Profile Header Card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  radius: 24,
                                  child: Icon(Icons.storefront, size: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile.shopName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        'License: ${profile.licenseKey}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              Icons.email_outlined,
                              'Email',
                              profile.email,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.phone_outlined,
                              'Phone',
                              profile.phoneNumber,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.location_on_outlined,
                              'Address',
                              profile.address,
                            ),
                            if (profile.taxNumber != null &&
                                profile.taxNumber!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.receipt_long_outlined,
                                'Tax ID',
                                profile.taxNumber!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Date Filter Controls
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _startDate != null && _endDate != null
                                    ? '${dateFormatter.format(_startDate!)} - ${dateFormatter.format(_endDate!)}'
                                    : 'Filter Date Range (All Time)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            if (_startDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: _clearDateFilter,
                              ),
                            OutlinedButton.icon(
                              onPressed: _selectDateRange,
                              icon: const Icon(Icons.filter_list, size: 18),
                              label: const Text('Filter'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(80, 36),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Reports Grid / Cards
                    Text(
                      'Business Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    // Sales Summary Report Card
                    _buildReportCard(
                      context,
                      title: 'Sales Summary',
                      icon: Icons.trending_up,
                      color: AppColors.accent,
                      primaryStat: currencyFormatter.format(sales.totalRevenue),
                      primaryLabel: 'Total Revenue',
                      secondaryStat: '${sales.totalInvoicesCount}',
                      secondaryLabel: 'Invoices Issued',
                    ),

                    const SizedBox(height: 16),

                    // Purchase Summary Report Card
                    _buildReportCard(
                      context,
                      title: 'Purchase Summary',
                      icon: Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      primaryStat: currencyFormatter.format(purchase.totalSpending),
                      primaryLabel: 'Total Spending',
                      secondaryStat: '${purchase.totalPurchasesCount}',
                      secondaryLabel: 'Purchase Orders',
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Press refresh to load reports.'));
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String primaryStat,
    required String primaryLabel,
    required String secondaryStat,
    required String secondaryLabel,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryStat,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        primaryLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.border,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        secondaryStat,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        secondaryLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
