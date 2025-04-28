import 'package:meta/meta_meta.dart';

/// Annotation for FinampSettings fields that should not have a setter and/or a
/// finampSettingsProvider selector created
@Target({TargetKind.setter, TargetKind.field})
class FinampSetterIgnore {
  final String message;
  const FinampSetterIgnore(this.message);
  @override
  String toString() =>
      "Excluded from automatic sub-provider/setter generation: $message";
}
