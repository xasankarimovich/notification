// class MotivationModel {
//   // String id;
//   String quote;
//   String title;

//   MotivationModel({
//     // required this.id,
//     required this.quote,
//     required this.title,
//   });

//   factory MotivationModel.fromJson(Map<String, dynamic> data) {
//     return MotivationModel(
//       quote: data['quote'],
//       title: data['title'],
//     );
//   }
// }

class MotivationModel {
  final String quote;
  final String author;

  MotivationModel({required this.quote, required this.author});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
      quote: json['quote'] ?? 'No quote available',
      author: json['author'] ?? 'Unknown author',
    );
  }
}