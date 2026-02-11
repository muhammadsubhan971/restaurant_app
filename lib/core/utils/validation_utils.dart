class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  // Password validation (min 6 characters)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  // Phone number validation (10 digits)
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'\D'), ''));
  }
  
  // Name validation (non-empty, reasonable length)
  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length <= 50;
  }
  
  // PIN validation (6 digits)
  static bool isValidPin(String pin) {
    final pinRegex = RegExp(r'^\d{6}$');
    return pinRegex.hasMatch(pin);
  }
  
  // Restaurant name validation
  static bool isValidRestaurantName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2 && name.trim().length <= 100;
  }
  
  // Menu item name validation
  static bool isValidMenuItemName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2 && name.trim().length <= 50;
  }
  
  // Price validation (positive number)
  static bool isValidPrice(double price) {
    return price > 0;
  }
  
  // Points validation (non-negative integer)
  static bool isValidPoints(int points) {
    return points >= 0;
  }
  
  // Points per dollar validation (reasonable range)
  static bool isValidPointsPerDollar(int points) {
    return points >= 1 && points <= 100;
  }
  
  // Description validation
  static bool isValidDescription(String description) {
    return description.trim().length <= 500;
  }
  
  // Address validation
  static bool isValidAddress(String address) {
    return address.trim().isNotEmpty && address.trim().length >= 5 && address.trim().length <= 200;
  }
  
  // ZIP code validation (5 digits)
  static bool isValidZipCode(String zipCode) {
    final zipRegex = RegExp(r'^\d{5}$');
    return zipRegex.hasMatch(zipCode);
  }
  
  // URL validation
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
  
  // Validate if string contains only letters and spaces
  static bool isAlphaSpace(String input) {
    final alphaSpaceRegex = RegExp(r'^[a-zA-Z\s]+$');
    return alphaSpaceRegex.hasMatch(input);
  }
  
  // Validate if string contains only alphanumeric characters
  static bool isAlphanumeric(String input) {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(input);
  }
  
  // Validate credit card number (basic Luhn algorithm)
  static bool isValidCreditCard(String cardNumber) {
    // Remove spaces and dashes
    final cleaned = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    if (cleaned.length < 13 || cleaned.length > 19) return false;
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) return false;
    
    // Luhn algorithm
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }
  
  // Validate expiration date (MM/YY format)
  static bool isValidExpirationDate(String expDate) {
    final expRegex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
    if (!expRegex.hasMatch(expDate)) return false;
    
    final parts = expDate.split(RegExp(r'\/'));
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    
    final now = DateTime.now();
    final exp = DateTime(year, month);
    
    return exp.isAfter(now);
  }
  
  // Validate CVV (3-4 digits)
  static bool isValidCvv(String cvv) {
    final cvvRegex = RegExp(r'^\d{3,4}$');
    return cvvRegex.hasMatch(cvv);
  }
}