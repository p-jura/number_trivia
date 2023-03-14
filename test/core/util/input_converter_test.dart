import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group(
    'stringToUnsignedInt',
    () {
      test(
        'should return integer when string represents an unsign integer',
        () async {
          // arrange
          const str = '123';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, equals(const Right(123)));
        },
      );
      test(
        'should return failure when the string is not integer',
        () {
          // arrange
          const str = 'abc';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, equals(Left(InvalidInputFailure())));
        },
      );
      test(
        'should return failure when the string is negatice integer',
        () {
          // arrange
          const str = '-123';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, equals(Left(InvalidInputFailure())));
        },
      );
    },
  );
}
