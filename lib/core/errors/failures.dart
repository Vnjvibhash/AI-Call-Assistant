abstract class Failure {
  final String message;
  final dynamic cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => message;
}

class TelecomFailure extends Failure {
  const TelecomFailure(super.message, [super.cause]);
}

class AiFailure extends Failure {
  const AiFailure(super.message, [super.cause]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.cause]);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.cause]);
}

class SpeechFailure extends Failure {
  const SpeechFailure(super.message, [super.cause]);
}
