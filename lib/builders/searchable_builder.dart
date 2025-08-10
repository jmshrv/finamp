import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finamp/builders/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder getSearchableGenerator(BuilderOptions options) =>
    SharedPartBuilder([_SearchableGenerator()], 'searchable_generator');

class _SearchableGenerator extends GeneratorForAnnotation<Searchable> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Searchable annotation can only be applied to classes',
        element: element,
      );
    }

    final className = element.name;

    // Get the source code to analyze
    final assetId = await buildStep.resolver.assetIdForElement(element);
    final library = await buildStep.resolver.libraryFor(assetId);
    final sourceCode = library.source.contents.data;

    // Extract AppLocalizations calls using regex
    final localizationCalls = _extractAppLocalizationCalls(sourceCode);

    if (localizationCalls.isEmpty) {
      log.warning('No AppLocalizations calls found in $className');
      return '';
    }

    log.info(
      'Generated searchable content for $className with ${localizationCalls.length} localizations: ${localizationCalls.join(", ")}',
    );

    return '''
extension ${className}Searchable on $className {
  @override
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
${localizationCalls.map((call) => '      l.$call,').join('\n')}
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
''';
  }

  Set<String> _extractAppLocalizationCalls(String sourceCode) {
    // Match various patterns of AppLocalizations usage
    final patterns = [
      RegExp(r'AppLocalizations\.of\(context\)!\.(\w+)'),
      RegExp(r'AppLocalizations\.of\(context\)\.(\w+)'),
    ];

    final calls = <String>{};

    for (final pattern in patterns) {
      final matches = pattern.allMatches(sourceCode);
      for (final match in matches) {
        final methodName = match.group(1)!;
        // Skip common non-localization methods
        if (!_isExcludedMethod(methodName)) {
          calls.add(methodName);
        }
      }
    }

    return calls;
  }

  bool _isExcludedMethod(String methodName) {
    const excludedMethods = {
      'of',
      'maybeOf',
      'toString',
      'hashCode',
      'runtimeType',
    };
    return excludedMethods.contains(methodName);
  }
}
