import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:equatable_lint_x/src/assists/make_class_use_equatable.dart';
import 'package:equatable_lint_x/src/fixes/always_call_super_props_when_overriding_equatable_props.dart';
import 'package:equatable_lint_x/src/fixes/missing_field_in_equatable_props.dart';
import 'package:equatable_lint_x/src/lints/always_call_super_props_when_overriding_equatable_props.dart';
import 'package:equatable_lint_x/src/lints/missing_field_in_equatable_props.dart';

/// Plugin for the Equatable Lint rules
final plugin = _EquatablePlugin();

class _EquatablePlugin extends Plugin {
  @override
  String get name => 'equatable_lint_x';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(MissingFieldInEquatableProps());
    registry.registerFixForRule(
      MissingFieldInEquatableProps.code,
      AddMissingFieldInEquatablePropsFix.new,
    );
    registry.registerFixForRule(
      MissingFieldInEquatableProps.code,
      AddAllMissingFieldInEquatablePropsFix.new,
    );

    registry.registerWarningRule(
      AlwaysCallSuperPropsWhenOverridingEquatableProps(),
    );
    registry.registerFixForRule(
      AlwaysCallSuperPropsWhenOverridingEquatableProps.code,
      CallSuperPropsWhenOverridingEquatableProps.new,
    );

    registry.registerAssist(MakeClassExtendEquatable.new);
    registry.registerAssist(MakeClassWithEquatableMixin.new);
  }
}
