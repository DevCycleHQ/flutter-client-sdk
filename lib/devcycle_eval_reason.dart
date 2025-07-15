class DevCycleEvalReason {
  /// Evaluation reason
  String? reason;

  /// Details
  String? details;

  /// Target ID
  /// This is the id of the target that was evaluated.
  String? targetId;

  static DevCycleEvalReason fromCodec(Map<String, dynamic> map) {
    DevCycleEvalReason evalReason = DevCycleEvalReason();

    evalReason.reason = map['reason'];
    evalReason.details = map['details'];
    evalReason.targetId = map['target_id'];

    return evalReason;
  }

  static DevCycleEvalReason defaultReason(String details) {
    return DevCycleEvalReason()
      ..reason = "DEFAULT"
      ..details = details;
  }
}
