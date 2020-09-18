// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
//import 'package:expenses/api/bloc/quote_bloc.dart';
//import 'package:expenses/api/quote_api_client.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
//
//import 'package:expenses/main.dart';
//
//void main() {
//  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//    // Build our app and trigger a frame.
//    await tester.pumpWidget(ExpensesApp());
//
//    // Verify that our counter starts at 0.
//    expect(find.text('0'), findsOneWidget);
//    expect(find.text('1'), findsNothing);
//
//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
//
//    // Verifica se está retornando dados da api
////    QuoteApiClient().fetchQuote();
//
//    test('should assert if null', () {
//      expect(
//            () => QuoteBloc(repository: null),
//        throwsA(isAssertionError),
//      );
//    });
//
//  });
//}


import 'package:bloc_test/bloc_test.dart';
import 'package:expenses/api/bloc/quote_bloc.dart';
import 'package:expenses/api/bloc/quote_event.dart';
import 'package:expenses/api/bloc/quote_state.dart';
import 'package:expenses/api/repositorys/quote_repository.dart';
import 'package:expenses/models/quote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  testWidgets('Testa todos os elementos de consultas', (WidgetTester tester) async {
    QuoteBloc quoteBloc;
    MockQuoteRepository quoteRepository;

    setUp(() {
      quoteRepository = MockQuoteRepository();
      quoteBloc = QuoteBloc(repository: quoteRepository);
    });

    tearDown(() {
      quoteBloc?.close();
    });

    test('Está nulo: ', () {
      expect(
            () => QuoteBloc(repository: null),
        throwsA(isAssertionError),
      );
    });

    test('Estado inicial está correto: ', () {
      expect(quoteBloc.initialState, QuoteEmpty());
    });

    test('Fecha se não emitir nenhum estado: ', () {
      expectLater(
        quoteBloc,
        emitsInOrder([QuoteEmpty(), emitsDone]),
      );
      quoteBloc.close();
    });

    group('Bloc teste', () {
      final Quote mockQuote =
      Quote(id: 123, quoteAuthor: "abc", quoteTex: "def");

      blocTest(
        'emits [QuoteEmpty, QuoteLoading, QuoteLoaded] when FetchQuote is added and fetchQuote succeeds',
        build: () {
          when(quoteRepository.fetchQuote()).thenAnswer(
                (_) => Future.value(mockQuote),
          );
          return quoteBloc;
        },
        act: (bloc) => bloc.add(FetchQuote()),
        expect: [QuoteEmpty(), QuoteLoading(), QuoteLoaded(quote: mockQuote)],
      );

      blocTest(
        'emits [QuoteEmpty, QuoteLoading, QuoteError] when FetchQuote is added and fetchQuote fails',
        build: () {
          when(quoteRepository.fetchQuote())
              .thenThrow(Exception('Erro ao obter cotações'));
          return quoteBloc;
        },
        act: (bloc) => bloc.add(FetchQuote()),
        expect: [QuoteEmpty(), QuoteLoading(), QuoteError()],
      );
    });


  });
}