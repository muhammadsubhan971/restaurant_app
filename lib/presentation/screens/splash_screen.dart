import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_themes.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/theme_provider.dart';
import '../screens/account_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add a small delay to show splash screen
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    // Initialize providers
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    await Future.wait([
      authProvider.initAuth(),
      themeProvider.initTheme(),
    ]);
    
    if (!mounted) return;
    
    // Navigate to appropriate screen
    _navigateToNextScreen(authProvider);
  }

  void _navigateToNextScreen(AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      // User is already authenticated, navigate to home screen based on role
      _navigateToHomeScreen(authProvider.userRole);
    } else {
      // User not authenticated, go to account selection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountSelectionScreen(),
        ),
      );
    }
  }

  void _navigateToHomeScreen(String? role) {
    String routeName;
    
    switch (role) {
      case 'customer':
        routeName = '/customer_home';
        break;
      case 'restaurant_owner':
        routeName = '/restaurant_home';
        break;
      case 'admin':
        routeName = '/admin_home';
        break;
      default:
        // If role is invalid, go to account selection
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountSelectionScreen(),
          ),
        );
        return;
    }
    
    // Navigate to the appropriate home screen
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.primaryColor.withOpacity(0.1),
              AppThemes.backgroundLight,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppThemes.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.stars,
                size: 60,
                color: AppThemes.primaryColor,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // App Name
            Text(
              'Local Rewards',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppThemes.primaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tagline
            Text(
              'Loyalty Rewards for Local Restaurants',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppThemes.textSecondaryLight,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppThemes.primaryColor),
            ),
            
            const SizedBox(height: 24),
            
            // Loading text
            Text(
              'Getting things ready...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppThemes.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}