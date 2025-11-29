/// مسارات Firebase Firestore بعد تعديلها لتناسب وجود جميع الـ Collections في الـ Root.
/// الآن: كل المسارات تشير مباشرة إلى الـ Root بدون أي artifacts.
library;

class FirebasePaths {
  /// ----------------------------------------------------
  /// 1. مسارات البيانات العامة (Public Data)
  /// ----------------------------------------------------

  /// مسار Collection عام موجود في الـ Root.
  /// مثال: users, posts, categories
  static String publicCollection(String collectionName) {
    return collectionName; // مباشرة في الـ Root
  }

  /// مسار Document داخل Collection عام في الـ Root.
  /// مثال: users/{userId}
  static String publicDoc(String collectionName, String docId) {
    return '$collectionName/$docId';
  }

  /// ----------------------------------------------------
  /// 2. مسارات البيانات الخاصة بالمستخدم (Private Data)
  /// ----------------------------------------------------

  /// مجموعة بيانات خاصة بمستخدم معيّن موجودة داخل Collection واحد في الـ Root.
  /// مثال: users/{userId}/favorites
  static String userPrivateCollection(String userId, String collectionName) {
    return 'users/$userId/$collectionName';
  }

  /// مسار Document داخل مجموعة خاصة بمستخدم معيّن.
  /// مثال: users/{userId}/favorites/{favoriteId}
  static String userPrivateDoc(
    String userId,
    String collectionName,
    String docId,
  ) {
    return 'users/$userId/$collectionName/$docId';
  }
}
