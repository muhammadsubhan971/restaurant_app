import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart' as app_user;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  String? get userRole => _currentUser?.role;

  // Initialize auth state
  Future<void> initAuth() async {
    _setLoading(true);
    
    try {
      // Check if user is already signed in
      User? firebaseUser = _auth.currentUser;
      
      if (firebaseUser != null) {
        // Fetch user data from Firestore
        await _fetchUserData(firebaseUser.uid);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Login method (wrapper for signInWithEmailAndPassword)
  Future<bool> login(String email, String password, String role) async {
    return await signInWithEmailAndPassword(email, password, role);
  }

  // Register method (wrapper for registerWithEmailAndPassword)
  Future<bool> register(String email, String password, String name, String role) async {
    return await registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      role: role,
    );
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password, String role) async {
    _setLoading(true);
    _clearError();

    try {
      // Sign in with Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Fetch user data from Firestore
        await _fetchUserData(credential.user!.uid);
        
        // Verify role matches
        if (_currentUser?.role != role) {
          await signOut();
          _setErrorMessage('Invalid role selected');
          return false;
        }
        
        // Save role to preferences
        await _saveUserRole(role);
        return true;
      }
      
      _setErrorMessage('Sign in failed');
      return false;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Create user with Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final newUser = app_user.User(
          id: credential.user!.uid,
          email: email.trim(),
          name: name.trim(),
          role: role,
          phoneNumber: phoneNumber?.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(credential.user!.uid)
            .set(newUser.toFirestore());

        // Set current user
        _currentUser = newUser;
        
        // Save role to preferences
        await _saveUserRole(role);
        
        notifyListeners();
        return true;
      }
      
      _setErrorMessage('Registration failed');
      return false;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _auth.signOut();
      await _clearUserData();
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Logout method (alias for signOut)
  Future<void> logout() async {
    await signOut();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        _currentUser = app_user.User.fromFirestore(doc);
        notifyListeners();
      } else {
        // User document doesn't exist, sign out
        await signOut();
        _setErrorMessage('User data not found');
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    }
  }

  // Save user role to preferences
  Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userRoleKey, role);
  }

  // Get saved user role
  Future<String?> _getSavedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userRoleKey);
  }

  // Clear user data
  Future<void> _clearUserData() async {
    _currentUser = null;
    _errorMessage = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userRoleKey);
    await prefs.remove(AppConstants.currentUserKey);
    
    notifyListeners();
  }

  // Handle Firebase Auth errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _setErrorMessage('No user found with this email');
        break;
      case 'wrong-password':
        _setErrorMessage('Incorrect password');
        break;
      case 'invalid-email':
        _setErrorMessage('Invalid email address');
        break;
      case 'email-already-in-use':
        _setErrorMessage('Email already in use');
        break;
      case 'weak-password':
        _setErrorMessage('Password is too weak');
        break;
      case 'too-many-requests':
        _setErrorMessage('Too many requests. Please try again later');
        break;
      default:
        _setErrorMessage(e.message ?? 'Authentication failed');
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final updatedUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(_currentUser!.id)
          .update(updatedUser.toFirestore());

      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}