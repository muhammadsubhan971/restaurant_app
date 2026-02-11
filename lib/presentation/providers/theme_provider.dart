import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isLoading = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Initialize theme
  Future<void> initTheme() async {
    _setLoading(true);
    try {
      await _loadThemePreference();
    } finally {
      _setLoading(false);
    }
  }

  // Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _setLoading(true);
    try {
      _isDarkMode = !_isDarkMode;
      await _saveThemePreference();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Set dark mode
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    
    _setLoading(true);
    try {
      _isDarkMode = isDark;
      await _saveThemePreference();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Save theme preference to shared preferences
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}