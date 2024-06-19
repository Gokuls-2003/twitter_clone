class AppWriteConstants {
  static const String databaseId = '666bff14002569eea06e';
  static const String projectId = '666be8b0001bd89655a8';
  static const String endPoint = 'http://192.168.218.37:80/v1';
  static const String userscollection = '667106af00167bbb81fb';
  static const String tweetscollection = '6672a86000253065619d';
  static const String imagesBucket = '6672bca300168cf1aff4';

  static String imageUrl(String imageId) => 
    '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
