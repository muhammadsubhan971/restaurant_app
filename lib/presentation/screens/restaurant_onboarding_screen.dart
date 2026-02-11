import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../core/utils/validation_utils.dart';

class RestaurantOnboardingScreen extends StatefulWidget {
  const RestaurantOnboardingScreen({super.key});

  @override
  State<RestaurantOnboardingScreen> createState() => _RestaurantOnboardingScreenState();
}

class _RestaurantOnboardingScreenState extends State<RestaurantOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _websiteController = TextEditingController();
  final _cuisineTypeController = TextEditingController();
  final _pointsPerDollarController = TextEditingController(text: '10');
  
  String _selectedCategory = 'Other';
  final List<String> _categories = [
    'Other', 'American', 'Italian', 'Mexican', 'Chinese', 'Japanese', 
    'Indian', 'French', 'Mediterranean', 'Coffee Shop', 'Fast Food'
  ];
  
  String _selectedHoursMondayOpen = '09:00';
  String _selectedHoursMondayClose = '18:00';
  String _selectedHoursTuesdayOpen = '09:00';
  String _selectedHoursTuesdayClose = '18:00';
  String _selectedHoursWednesdayOpen = '09:00';
  String _selectedHoursWednesdayClose = '18:00';
  String _selectedHoursThursdayOpen = '09:00';
  String _selectedHoursThursdayClose = '18:00';
  String _selectedHoursFridayOpen = '09:00';
  String _selectedHoursFridayClose = '20:00';
  String _selectedHoursSaturdayOpen = '10:00';
  String _selectedHoursSaturdayClose = '20:00';
  String _selectedHoursSundayOpen = '10:00';
  String _selectedHoursSundayClose = '17:00';
  
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneNumberController.dispose();
    _websiteController.dispose();
    _cuisineTypeController.dispose();
    _pointsPerDollarController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restaurant application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to admin panel
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Onboarding'),
        backgroundColor: AppThemes.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restaurant Application',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill out the details below to apply for the platform',
                style: TextStyle(
                  color: AppThemes.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              
              // Basic Information
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name *',
                  border: OutlineInputBorder(),
                  hintText: 'Enter restaurant name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter restaurant name';
                  }
                  if (!ValidationUtils.isValidRestaurantName(value)) {
                    return 'Invalid restaurant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                  hintText: 'Describe your restaurant',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  if (value.length < 20) {
                    return 'Description should be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Location Information
              const Text(
                'Location Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                  hintText: 'Street address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City *',
                        border: OutlineInputBorder(),
                        hintText: 'City',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State *',
                        border: OutlineInputBorder(),
                        hintText: 'State',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code *',
                        border: OutlineInputBorder(),
                        hintText: 'ZIP Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ZIP code';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Contact Information
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  border: OutlineInputBorder(),
                  hintText: '(555) 123-4567',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (!ValidationUtils.isValidPhoneNumber(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'https://www.example.com',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // Loyalty Program Settings
              const Text(
                'Loyalty Program Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pointsPerDollarController,
                      decoration: const InputDecoration(
                        labelText: 'Points per Dollar Spent *',
                        border: OutlineInputBorder(),
                        hintText: '10',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter points per dollar';
                        }
                        final points = int.tryParse(value);
                        if (points == null || points <= 0) {
                          return 'Please enter a valid number';
                        }
                        if (points > 100) {
                          return 'Points per dollar cannot exceed 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('points per dollar'),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Operating Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildOperatingHoursRow('Monday', _selectedHoursMondayOpen, _selectedHoursMondayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursMondayOpen = open;
                      _selectedHoursMondayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Tuesday', _selectedHoursTuesdayOpen, _selectedHoursTuesdayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursTuesdayOpen = open;
                      _selectedHoursTuesdayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Wednesday', _selectedHoursWednesdayOpen, _selectedHoursWednesdayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursWednesdayOpen = open;
                      _selectedHoursWednesdayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Thursday', _selectedHoursThursdayOpen, _selectedHoursThursdayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursThursdayOpen = open;
                      _selectedHoursThursdayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Friday', _selectedHoursFridayOpen, _selectedHoursFridayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursFridayOpen = open;
                      _selectedHoursFridayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Saturday', _selectedHoursSaturdayOpen, _selectedHoursSaturdayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursSaturdayOpen = open;
                      _selectedHoursSaturdayClose = close;
                    });
                  }),
              _buildOperatingHoursRow('Sunday', _selectedHoursSundayOpen, _selectedHoursSundayClose, 
                  (open, close) {
                    setState(() {
                      _selectedHoursSundayOpen = open;
                      _selectedHoursSundayClose = close;
                    });
                  }),
              
              const SizedBox(height: 24),
              
              // Terms and Conditions
              CheckboxListTile(
                title: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: AppThemes.textPrimaryLight,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: AppThemes.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppThemes.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              
              const SizedBox(height: 16),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _acceptTerms && !_isLoading ? _submitApplication : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Application',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperatingHoursRow(String day, String open, String close, Function(String, String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(day),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: open,
              decoration: const InputDecoration(
                labelText: 'Open',
                border: OutlineInputBorder(),
              ),
              items: _buildTimeOptions().map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value, close);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          const Text('to'),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: close,
              decoration: const InputDecoration(
                labelText: 'Close',
                border: OutlineInputBorder(),
              ),
              items: _buildTimeOptions().map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(open, value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _buildTimeOptions() {
    final times = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final hourStr = hour.toString().padLeft(2, '0');
        final minuteStr = minute.toString().padLeft(2, '0');
        times.add('$hourStr:$minuteStr');
      }
    }
    return times;
  }
}