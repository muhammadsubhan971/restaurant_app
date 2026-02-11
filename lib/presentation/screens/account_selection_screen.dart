import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_themes.dart';
import '../../presentation/providers/theme_provider.dart';
import '../../routes/app_routes.dart';

class AccountSelectionScreen extends StatelessWidget {
  const AccountSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Status bar spacer
            const SizedBox(height: 12),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppThemes.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.stars,
                        size: 40,
                        color: AppThemes.primaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title and subtitle
                    Text(
                      'Welcome to Local Rewards',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'Choose your account type to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Account type cards
                    _buildAccountCard(
                      context,
                      icon: Icons.person,
                      iconColor: Colors.white,
                      iconBackground: Colors.blue,
                      title: 'Customer Login',
                      subtitle: 'Access rewards, track stars, & perks',
                      onTap: () => _navigateToLogin(context, 'customer'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildAccountCard(
                      context,
                      icon: Icons.verified_user,
                      iconColor: Colors.white,
                      iconBackground: Colors.purple,
                      title: 'Admin Login',
                      subtitle: 'Manage platform settings & analytics',
                      onTap: () => _navigateToLogin(context, 'admin'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildAccountCard(
                      context,
                      icon: Icons.business_center,
                      iconColor: Colors.white,
                      iconBackground: Colors.orange,
                      title: 'Business Owner Login',
                      subtitle: 'Manage your restaurant insights',
                      onTap: () => _navigateToLogin(context, 'restaurant_owner'),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Info section
                    Text(
                      'Local Rewards brings premium loyalty programs to independent restaurants',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Benefits list
                    _buildBenefitItem(
                      context,
                      icon: Icons.star,
                      text: 'Earn stars with every purchase',
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildBenefitItem(
                      context,
                      icon: Icons.redeem,
                      text: 'Redeem for free rewards',
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildBenefitItem(
                      context,
                      icon: Icons.favorite,
                      text: 'Support local restaurants',
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom indicator
            Container(
              height: 8,
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: Container(
                  width: 128,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Dark mode toggle button
      floatingActionButton: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FloatingActionButton(
            onPressed: themeProvider.toggleTheme,
            backgroundColor: Theme.of(context).cardColor,
            child: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).iconTheme.color,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.arrow_forward,
              color: AppThemes.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.amber,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  void _navigateToLogin(BuildContext context, String role) {
    String routeName;
    
    switch (role) {
      case 'customer':
        routeName = AppRoutes.customerLogin;
        break;
      case 'admin':
        routeName = AppRoutes.adminLogin;
        break;
      case 'restaurant_owner':
        routeName = AppRoutes.restaurantLogin;
        break;
      default:
        return;
    }
    
    Navigator.pushNamed(context, routeName);
  }
}