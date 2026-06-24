import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

class PipelineBoardPage extends StatelessWidget {
  const PipelineBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pipeline',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Track your leads in pipeline stages.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Search Bar
                    Container(
                      width: 250,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search leads...',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          prefixIcon: Icon(Iconsax.search_normal, color: AppColors.textSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter Button
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: const [
                          Icon(Iconsax.filter, size: 20, color: AppColors.textSecondary),
                          SizedBox(width: 8),
                          Text('Filters', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Kanban Board
            SizedBox(
              height: MediaQuery.of(context).size.height - 180, // Adjust height based on screen
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKanbanColumn('New (12)', AppColors.iconBlue, AppColors.iconBgBlue, [
                      _buildLeadCard('Rohit Sharma', 'Delhi', '24 May'),
                      _buildLeadCard('Ankita Singh', 'Mumbai', '25 May'),
                      _buildLeadCard('Vikas Mehta', 'Pune', '26 May'),
                    ]),
                    const SizedBox(width: 16),
                    _buildKanbanColumn('Contacted (8)', AppColors.iconGreen, AppColors.iconBgGreen, [
                      _buildLeadCard('Neha Verma', 'Delhi', '24 May'),
                      _buildLeadCard('Pooja Mehta', 'Jaipur', '25 May'),
                      _buildLeadCard('Amar Verma', 'Lucknow', '26 May'),
                    ]),
                    const SizedBox(width: 16),
                    _buildKanbanColumn('Interested (10)', AppColors.iconOrange, AppColors.iconBgOrange, [
                      _buildLeadCard('Kunal Patel', 'Ahmedabad', '25 May'),
                      _buildLeadCard('Riya Malhotra', 'Delhi', '26 May'),
                      _buildLeadCard('Siddharth Rao', 'Bangalore', '26 May'),
                    ]),
                    const SizedBox(width: 16),
                    _buildKanbanColumn('Demo (6)', AppColors.iconPurple, AppColors.iconBgPurple, [
                      _buildLeadCard('Vikram Joshi', 'Mumbai', '26 May'),
                      _buildLeadCard('Rahul Kapoor', 'Delhi', '27 May'),
                      _buildLeadCard('Simran Kaur', 'Chandigarh', '27 May'),
                    ]),
                    const SizedBox(width: 16),
                    _buildKanbanColumn('Negotiation (4)', const Color(0xFFE11D48), const Color(0xFFFCE7F3), [
                      _buildLeadCard('Deepak Yadav', 'Noida', '27 May'),
                      _buildLeadCard('Neha Kapoor', 'Gurgaon', '28 May'),
                      _buildLeadCard('Aryan Shah', 'Surat', '28 May'),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanColumn(String title, Color color, Color bgColor, List<Widget> cards) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(Iconsax.more, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ...cards,
                const SizedBox(height: 8),
                // Add Lead Button
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Iconsax.add, color: AppColors.iconBlue, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Add Lead',
                          style: TextStyle(
                            color: AppColors.iconBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(String name, String city, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                city,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
