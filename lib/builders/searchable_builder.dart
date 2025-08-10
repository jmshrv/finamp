import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finamp/builders/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder getSearchableGenerator(BuilderOptions options) =>
    SharedPartBuilder([_SearchableGenerator()], 'searchable_generator');

class _SearchableGenerator extends GeneratorForAnnotation<Searchable> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('Searchable annotation can only be applied to classes', element: element);
    }

    final className = element.name;

    // Check widget type (Consumer widgets, regular StatefulWidget, or StatelessWidget)
    final isConsumerStatefulWidget = _isConsumerStatefulWidget(element);
    final isConsumerWidget = _isConsumerWidget(element);
    final isRegularStatefulWidget = _isStatefulWidget(element);
    final isRegularStatelessWidget = _isStatelessWidget(element);

    if (!isConsumerStatefulWidget && !isConsumerWidget && !isRegularStatefulWidget && !isRegularStatelessWidget) {
      throw InvalidGenerationSourceError(
        'Searchable annotation can only be applied to ConsumerWidget, ConsumerStatefulWidget, StatefulWidget, or StatelessWidget classes',
        element: element,
      );
    }

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

    // Generate different extensions based on widget type
    if (isConsumerStatefulWidget || isRegularStatefulWidget) {
      return _generateStatefulWidgetExtension(className, localizationCalls);
    } else {
      return _generateStatelessWidgetExtension(className, localizationCalls);
    }
  }

  bool _isConsumerWidget(ClassElement element) {
    return _hasAncestorType(element, 'ConsumerWidget');
  }

  bool _isConsumerStatefulWidget(ClassElement element) {
    return _hasAncestorType(element, 'ConsumerStatefulWidget');
  }

  bool _isStatefulWidget(ClassElement element) {
    return _hasAncestorType(element, 'StatefulWidget');
  }

  bool _isStatelessWidget(ClassElement element) {
    return _hasAncestorType(element, 'StatelessWidget');
  }

  bool _hasAncestorType(ClassElement element, String typeName) {
    // Check direct supertype
    final supertype = element.supertype;
    if (supertype?.element.name == typeName) {
      return true;
    }

    // Check if it extends the target type through inheritance chain
    ClassElement? current = element;
    while (current != null) {
      if (current.supertype?.element.name == typeName) {
        return true;
      }
      // Cast InterfaceElement to ClassElement
      final supertypeElement = current.supertype?.element;
      if (supertypeElement is ClassElement) {
        current = supertypeElement;
      } else {
        current = null;
      }
    }

    return false;
  }

  String _generateStatelessWidgetExtension(String className, Set<String> localizationCalls) {
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

  String _generateStatefulWidgetExtension(String className, Set<String> localizationCalls) {
    return '''
extension ${className}Searchable on $className {
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
    const excludedMethods = {'of', 'maybeOf', 'toString', 'hashCode', 'runtimeType'};
    return excludedMethods.contains(methodName);
  }
}
