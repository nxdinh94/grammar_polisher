import 'package:dio/dio.dart';
import 'package:grammar_polisher/data/models/check_grammar_result.dart';

import '../models/detect_gpt_result.dart';
import '../models/improve_writing_result.dart';

abstract interface class RemoteData {
  Future<ImproveWritingResult> improveWriting(String text);
  Future<CheckGrammarResult> checkGrammar(String text);
  Future<DetectGptResult> detectGpt(String text);
}

class RemoteDataImpl implements RemoteData {
  final Dio _dio;

  RemoteDataImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ImproveWritingResult> improveWriting(String text) async {
    final response = await _dio.post(
      '/imporve-writing/imporve-writing',
      data: {
        'lang': 'eng',
        'prompt': text,
      },
    );

    return ImproveWritingResult.fromJson(response.data['result']);
  }

  @override
  Future<CheckGrammarResult> checkGrammar(String text) async {
    final response = await _dio.post(
      '/lemma/check-grammar',
      data: {
        'text': text,
      },
    );

    final data = response.data['result']['grammar_check'];
    return CheckGrammarResult.fromJson({
      'error_dnsty': (data['error_dnsty'] as Map).values.toList(),
      'result': data['result'],
    });
  }

  @override
  Future<DetectGptResult> detectGpt(String text) async {
    final response = await _dio.post(
      '/lemma/detect-gpt',
      data: {
        'text': text,
      },
    );

    return DetectGptResult.fromJson(response.data['result']['feedback']['documents'][0]);
  }
}