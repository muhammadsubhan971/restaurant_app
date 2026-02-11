import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';

class LoyaltyRuleConfigurationScreen extends StatefulWidget {
  const LoyaltyRuleConfigurationScreen({super.key});

  @override
  State<LoyaltyRuleConfigurationScreen> createState() => _LoyaltyRuleConfigurationScreenState();
}

class _LoyaltyRuleConfigurationScreenState extends State<LoyaltyRuleConfigurationScreen> {
  // Current loyalty settings
  int _pointsPerDollar = 10;
  int _minPointsForRedemption = 50;
  int _maxPointsPerTransaction = 1000;
  bool _enableBonusPoints = false;
  int _bonusMultiplier = 2;
  String _bonusPeriod = 'weekend';
  bool _enableTieredRewards = false;
  List<Map<String, dynamic>> _tiers = [
    {'name': 'Bronze', 'points': 0, 'discount': 0.05},
    {'name': 'Silver', 'points': 500, 'discount': 0.10},
    {'name': 'Gold', 'points': 1000, 'discount': 0.15},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loyalty Program Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Customize how customers earn and redeem points',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Points per dollar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Points Per Dollar Spent',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'How many points customers earn per dollar spent',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _pointsPerDollar.toDouble(),
                              min: 1,
                              max: 50,
                              divisions: 49,
                              label: '${_pointsPerDollar} points',
                              onChanged: (value) {
                                setState(() {
                                  _pointsPerDollar = value.toInt();
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppThemes.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_pointsPerDollar} pts/\$',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppThemes.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Minimum points for redemption
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minimum Points for Redemption',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Minimum points required to redeem rewards',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _minPointsForRedemption.toDouble(),
                              min: 10,
                              max: 500,
                              divisions: 49,
                              label: '${_minPointsForRedemption} points',
                              onChanged: (value) {
                                setState(() {
                                  _minPointsForRedemption = value.toInt();
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppThemes.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_minPointsForRedemption} pts',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppThemes.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Maximum points per transaction
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Maximum Points Per Transaction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Maximum points a customer can earn in a single transaction',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _maxPointsPerTransaction.toDouble(),
                              min: 100,
                              max: 2000,
                              divisions: 19,
                              label: '${_maxPointsPerTransaction} points',
                              onChanged: (value) {
                                setState(() {
                                  _maxPointsPerTransaction = value.toInt();
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppThemes.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_maxPointsPerTransaction} pts',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppThemes.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Bonus points toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Enable Bonus Points',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Offer bonus points during special periods',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _enableBonusPoints,
                            onChanged: (value) {
                              setState(() {
                                _enableBonusPoints = value;
                              });
                            },
                          ),
                        ],
                      ),
                      
                      if (_enableBonusPoints)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bonus Multiplier',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: _bonusMultiplier.toDouble(),
                                      min: 1.5,
                                      max: 5,
                                      divisions: 7,
                                      label: '${_bonusMultiplier}x',
                                      onChanged: (value) {
                                        setState(() {
                                          _bonusMultiplier = value.toInt();
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppThemes.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${_bonusMultiplier}x',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppThemes.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              const Text(
                                'Bonus Period',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _bonusPeriod,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'weekend',
                                    child: Text('Weekends'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'holidays',
                                    child: Text('Holidays'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'events',
                                    child: Text('Special Events'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _bonusPeriod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tiered rewards toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Enable Tiered Rewards',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Create customer tiers with increasing benefits',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _enableTieredRewards,
                            onChanged: (value) {
                              setState(() {
                                _enableTieredRewards = value;
                              });
                            },
                          ),
                        ],
                      ),
                      
                      if (_enableTieredRewards)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: _tiers.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> tier = entry.value;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${tier['name']} Tier',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: tier['points'].toString(),
                                              decoration: const InputDecoration(
                                                labelText: 'Points Required',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _tiers[index]['points'] = int.tryParse(value) ?? 0;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: (tier['discount'] * 100).toString(),
                                              decoration: const InputDecoration(
                                                labelText: 'Discount (%)',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _tiers[index]['discount'] = double.tryParse(value) ?? 0 / 100;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Save button
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    // In a real app, this would save to Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loyalty settings saved successfully!'),
        backgroundColor: AppThemes.successColor,
      ),
    );
  }
}