import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
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

    final visitor = LocalizationFinder();
    final ast = await buildStep.resolver.astNodeFor(element, resolve: true);
    ast!.visitChildren(visitor);
    if (visitor.stateElement != null) {
      final stateAst = await buildStep.resolver.astNodeFor(visitor.stateElement!, resolve: true);
      stateAst!.visitChildren(visitor);
    }
    final localizationCalls = visitor.localizations;

    if (localizationCalls.isEmpty) {
      log.warning('No AppLocalizations calls found in $className');
      return '';
    }

    log.info(
      'Generated searchable content for $className with ${localizationCalls.length} localizations: ${localizationCalls.join(", ")}',
    );

    return _generateExtension(className, localizationCalls);
  }

  String _generateExtension(String className, Set<String> localizationCalls) {
    return '''
extension ${className}Searchable on $className {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
${localizationCalls.map((call) => '      _safeToString(l.$call),').join('\n')}
    ];
    return searchableTexts.where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }

  String _safeToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
''';
  }
}

class LocalizationFinder extends RecursiveAstVisitor<void> {
  final Set<String> localizations = {};
  Element? stateElement;

  LocalizationFinder();

  bool _inCreateState = false;

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.realTarget.staticType?.element?.name == "AppLocalizations") {
      localizations.add(node.propertyName.name);
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.realTarget?.staticType?.element?.name == "AppLocalizations") {
      localizations.add(node.methodName.name);
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    assert(!_inCreateState);
    if (node.name.lexeme == "createState") _inCreateState = true;
    super.visitMethodDeclaration(node);
    _inCreateState = false;
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    if (_inCreateState) {
      assert(stateElement == null);
      stateElement = node.expression!.staticType!.element!;
    }
    super.visitReturnStatement(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    if (_inCreateState) {
      assert(stateElement == null);
      stateElement = node.expression.staticType!.element!;
    }
    super.visitExpressionFunctionBody(node);
  }
}
