abstract class DonationAnalyticsRepo {
  Future<int> getDonorsCount();
  Future<int> getNeedersCount();
  Future<int> getInProgressCount();
  Future<int> getSuccessfulCount();
}
