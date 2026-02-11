import 'package:intl/intl.dart';

class FormatUtils {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  
  static final NumberFormat _decimalFormat = NumberFormat.decimalPattern();
  
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  
  // Format currency
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }
  
  // Format number with commas
  static String formatNumber(int number) {
    return _decimalFormat.format(number);
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  // Format time
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }
  
  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
  
  // Format for API
  static String formatForApi(DateTime date) {
    return _apiDateFormat.format(date);
  }
  
  // Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }
  
  // Format points with star icon
  static String formatPoints(int points) {
    return '$points ★';
  }
  
  // Format distance
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
  
  // Format rating
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
  
  // Mask sensitive data
  static String maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '*@$domain';
    }
    
    final visiblePart = username.substring(0, 2);
    return '$visiblePart***@$domain';
  }
  
  // Format time ago
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  // Format PIN (group digits)
  static String formatPin(String pin) {
    if (pin.length <= 4) {
      return pin.split('').join(' ');
    } else {
      return '${pin.substring(0, 3)} ${pin.substring(3)}';
    }
  }
}