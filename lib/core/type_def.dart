import 'package:fpdart/fpdart.dart';


import 'common/widgets/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

