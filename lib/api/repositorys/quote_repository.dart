import 'dart:async';

import 'package:expenses/api/quote_api_client.dart';
import 'package:expenses/models/quote.dart';
import 'package:meta/meta.dart';

class QuoteRepository {
  final QuoteApiClient quoteApiClient;

  QuoteRepository({@required this.quoteApiClient})
      : assert(quoteApiClient != null);

  Future<Quote> fetchQuote() async {
    return await quoteApiClient.fetchQuote();
  }
}