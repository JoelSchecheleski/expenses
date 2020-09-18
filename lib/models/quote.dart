import 'package:equatable/equatable.dart';

class Quote {
  final id;
  final String quoteTex;
  final String quoteAuthor;

  /// Construtor da classe usando parâmetros posicionais
  const Quote({this.id, this.quoteTex, this.quoteAuthor});

  @override
  List<Object> get props => [id, quoteTex, quoteAuthor];

  static Quote fromJson(dynamic json) {
    return Quote(
      id: json['_id'],
      quoteTex: json['quoteText'],
      quoteAuthor: json['quoteAuthor'],
    );
  }

  @override
  String toSting() => 'Quote {id: $id}';
}