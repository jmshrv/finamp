import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

// This file is part of the build system and cannot be imported by any files
// within the actual app or the launch will fail while trying to import dart:mirrors
// It should also not import any non-builder classes to avoid importing dart:ui

Builder getFinampSettingsGenerator(BuilderOptions options) => SharedPartBuilder(
      [
        _FinampSettingsGenerator(),
      ],
      'finamp_settings_builder',
    );

/// Generate setters and providers for all fields in FinampSettings.  The generated
/// code is part of finamp_settings_helper.dart.  Fields annotated with
/// @FinampSetterIgnore() are ignored.
class _FinampSettingsGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.findType("FinampSettingsHelper") == null) {
      return '';
    }
    ClassElement? settings;
    for (var import in library.element.definingCompilationUnit.libraryImports) {
      settings =
          LibraryReader(import.importedLibrary!).findType("FinampSettings");
      if (settings != null) break;
    }
    if (settings == null) {
      log.warning("Could not find FinampSettings");
      return '';
    }

    var settersCode = "";
    var selectorsCode = "";
    for (var property in settings.accessors) {
      if (!property.hasDeprecated &&
          TypeChecker.fromRuntime(SettingsHelperIgnore)
                  .firstAnnotationOfExact(property.nonSynthetic) ==
              null) {
        if (property.isSetter) {
          if (property.parameters.length != 1) {
            log.warning(
                "Unexpected param count for ${property.displayName}: ${property.parameters.length}");
          }
          var typeArg = _typeName(property.parameters.first.type);
          // setter name with first letter uppercase for adding prefixes to
          var paramName =
              "${property.displayName.substring(0, 1).toUpperCase()}${property.displayName.substring(1)}";

          settersCode += '''static void set$paramName($typeArg new$paramName){
          FinampSettings finampSettingsTemp = FinampSettingsHelper.finampSettings;
          finampSettingsTemp.${property.displayName}=new$paramName;
          Hive.box<FinampSettings>("FinampSettings").put("FinampSettings", finampSettingsTemp);
        }
        ''';
        }

        if (property.isGetter) {
          selectorsCode +=
              '''ProviderListenable<${_typeName(property.returnType)}> get ${property.displayName} => 
            finampSettingsProvider.select((value) => value.requireValue.${property.displayName});
        ''';
        }
      }
    }

    return '''
    // coverage:ignore-file
    // ignore_for_file: type=lint

    /// Generated setters for all finampSettings.  Must be directly accessed until
    /// static extension methods are added to dart
    extension FinampSetters on FinampSettingsHelper {
      $settersCode
    }
    
    /// Generated providers to easily watch only specific fields in finampSettings
    extension FinampSettingsProviderSelectors on StreamProvider<FinampSettings>{
      $selectorsCode
    }
    ''';
  }

  static String _typeName(DartType type) {
    var typeArg = type.element!.displayName;
    if (type is ParameterizedType && type.typeArguments.isNotEmpty) {
      typeArg =
          "$typeArg<${type.typeArguments.map((x) => _typeName(x)).join(",")}>";
    }
    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      typeArg = "$typeArg?";
    }
    return typeArg;
  }
}
