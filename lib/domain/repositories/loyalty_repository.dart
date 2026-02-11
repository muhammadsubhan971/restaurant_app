import '../entities/loyalty.dart';

abstract class LoyaltyRepository {
  // Points Balance
  Future<PointsBalance?> getPointsBalance(String userId, String restaurantId);
  Future<List<PointsBalance>> getUserPointsBalances(String userId);
  Future<List<PointsBalance>> getRestaurantPointsBalances(String restaurantId);
  Future<bool> updatePointsBalance(PointsBalance balance);
  Future<PointsBalance> addPointsToBalance(String userId, String restaurantId, int points, {String? description});
  Future<PointsBalance> redeemPointsFromBalance(String userId, String restaurantId, int points, {String? description});
  
  // Loyalty Transactions
  Future<List<LoyaltyTransaction>> getTransactionsByUser(String userId);
  Future<List<LoyaltyTransaction>> getTransactionsByRestaurant(String restaurantId);
  Future<List<LoyaltyTransaction>> getTransactionsByUserAndRestaurant(String userId, String restaurantId);
  Future<LoyaltyTransaction?> getTransactionById(String transactionId);
  Future<bool> createTransaction(LoyaltyTransaction transaction);
  Future<List<LoyaltyTransaction>> getRecentTransactions(String userId, {int limit = 10});
  
  // PIN Management
  Future<String> generatePinCode(String userId, String restaurantId, int points);
  Future<bool> validatePinCode(String pinCode, String userId, String restaurantId);
  Future<bool> expirePinCode(String pinCode);
}