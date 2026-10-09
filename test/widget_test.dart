import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/providers/task_provider.dart';
import 'package:taskflow/router.dart';
import 'package:taskflow/theme.dart';

void main() {
  testWidgets('TaskFlow boots to onboarding', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: TaskProvider(),
        child: MaterialApp.router(
          theme: buildTheme(),
          routerConfig: appRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TaskFlow'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
