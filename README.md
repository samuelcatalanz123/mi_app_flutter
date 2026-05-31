# Mi App de Samuel — Flutter 📱

Mi primera aplicación hecha con **Flutter** (lenguaje **Dart**). Es una app de
contador con muchas funciones, hecha para aprender los conceptos clave de Flutter.

> Hecha por Samuel, a los 15 años 💜

## Qué hace

- ➕➖ Sumar / restar un contador (no baja de 0) y reiniciarlo.
- 💬 Un mensaje y un emoji que **cambian** según el número.
- 📊 Una **barra de progreso** hacia una meta (10).
- ⌨️ Un **campo de texto** para escribir tu nombre (saludo en vivo).
- 🎉 Un **SnackBar** (aviso) al llegar a la meta.
- 💾 **Persistencia**: recuerda el número aunque cierres la app (`shared_preferences`).
- 🧭 **Navegación** a una segunda pantalla ("Acerca de").
- 🌙 **Modo oscuro** (cambia entre tema claro y oscuro).
- 🎬 **Animación** del número al cambiar.

## Conceptos de Flutter que demuestra

Widgets (StatelessWidget / StatefulWidget) · estado con `setState` · eventos ·
condicionales · diseño (Card, Row, Column, Icon, Padding) · `TextField` ·
`LinearProgressIndicator` · `SnackBar` · paquetes (`shared_preferences`) ·
`async`/`await` · navegación (`Navigator.push`) · temas (claro/oscuro) y
"lifting state up" · animaciones (`AnimatedSwitcher`).

## Cómo ejecutar

Necesitas tener [Flutter](https://flutter.dev) instalado.

```bash
flutter pub get
flutter run            # en un emulador o dispositivo
# o en el navegador:
flutter run -d chrome
```

El código está en `lib/main.dart`.

## Stack

Flutter · Dart · shared_preferences.
