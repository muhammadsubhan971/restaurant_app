import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../core/utils/validation_utils.dart';

class PinQrScannerScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final bool isRedemption; // true for redeeming points, false for earning points
  
  const PinQrScannerScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    this.isRedemption = false,
  });

  @override
  State<PinQrScannerScreen> createState() => _PinQrScannerScreenState();
}

class _PinQrScannerScreenState extends State<PinQrScannerScreen> {
  bool _isScanning = false;
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void reassemble() {
    super.reassemble();
    // QR Scanner functionality removed for web compatibility
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isRedemption ? 'Redeem Points' : 'Earn Points'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.isRedemption 
                    ? Colors.orange.withOpacity(0.1)
                    : AppThemes.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      widget.isRedemption ? Icons.redeem : Icons.stars,
                      size: 48,
                      color: widget.isRedemption 
                        ? Colors.orange 
                        : AppThemes.primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.restaurantName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isRedemption
                        ? 'Enter PIN to redeem points'
                        : 'Enter PIN to earn points',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // PIN entry section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PIN input card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.pin,
                              size: 64,
                              color: AppThemes.primaryColor,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Enter 6-Digit PIN',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _pinController,
                              focusNode: _pinFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Enter PIN',
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                letterSpacing: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _validatePin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppThemes.primaryColor,
                                minimumSize: const Size(double.infinity, 50),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Text(
                                'Submit PIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ),
      ),
    );
  }

  Future<void> _validatePin() async {
    final pin = _pinController.text.trim();
    
    if (!ValidationUtils.isValidPin(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit PIN'),
          backgroundColor: AppThemes.errorColor,
        ),
      );
      return;
    }
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Validating PIN...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    try {
      // Simulate API call to validate PIN
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation - in real app, this would call your backend
      final isValid = await _mockPinValidation(pin);
      
      if (!mounted) return;
      
      Navigator.pop(context); // Close loading dialog
      
      if (isValid) {
        if (widget.isRedemption) {
          _showRedemptionSuccess();
        } else {
          _showEarningSuccess();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid PIN. Please try again.'),
            backgroundColor: AppThemes.errorColor,
          ),
        );
        _pinController.clear();
        _pinFocusNode.requestFocus();
      }
    } catch (e) {
      if (!mounted) return;
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validation failed. Please try again.'),
          backgroundColor: AppThemes.errorColor,
        ),
      );
    }
  }

  Future<bool> _mockPinValidation(String pin) async {
    // In a real app, this would validate against your server
    // For demo purposes, accept any 6-digit PIN starting with 1
    return pin.startsWith('1') && pin.length == 6;
  }

  void _showEarningSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Points Earned!'),
        content: const Text('You\'ve successfully earned 25 stars!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRedemptionSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Points Redeemed!'),
        content: const Text('Your 50 stars have been successfully redeemed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}