// Pruebas básicas de widgets para FrutiApp Web.
//
// Verifica que la pantalla de login se construya correctamente y que
// la validación de formulario funcione como se espera.

import 'package:flutter_test/flutter_test.dart';

import 'package:frutiapp_web/main.dart';

void main() {
  testWidgets('FrutiApp muestra la pantalla de login', (WidgetTester tester) async {
    await tester.pumpWidget(const FrutiApp());

    // El título y el botón principal deben estar presentes.
    expect(find.text('FrutiApp'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });

  testWidgets('Muestra errores de validación con datos inválidos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FrutiApp());

    // Se presiona "Ingresar" sin llenar el formulario.
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Ingrese el correo'), findsOneWidget);
    expect(
      find.text('La contraseña debe tener al menos 6 caracteres'),
      findsOneWidget,
    );
  });
}
