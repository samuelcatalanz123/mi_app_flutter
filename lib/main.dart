import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MiApp());
}

// MiApp es el widget RAÍZ. Ahora tiene ESTADO: guarda el tema (claro/oscuro).
class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {
  ThemeMode _modo = ThemeMode.light;

  // Cambia entre claro y oscuro.
  void _cambiarTema() {
    setState(() {
      _modo = _modo == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App de Samuel',
      debugShowCheckedModeBanner: false,
      themeMode: _modo, // decide si se ve claro u oscuro
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Le pasamos al hijo una función para cambiar el tema (como una prop en React).
      home: Contador(
        onCambiarTema: _cambiarTema,
        esOscuro: _modo == ThemeMode.dark,
      ),
    );
  }
}

// Contador es un widget CON ESTADO (cambia → StatefulWidget).
class Contador extends StatefulWidget {
  // Estas son las PROPS que recibe (como argumentos): una función y un booleano.
  final VoidCallback onCambiarTema;
  final bool esOscuro;

  const Contador({
    super.key,
    required this.onCambiarTema,
    required this.esOscuro,
  });

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  static const int meta = 10;
  int _contador = 0;
  String _nombre = 'Samuel'; // ahora el nombre es un dato que puedes cambiar

  @override
  void initState() {
    super.initState();
    _cargar(); // al abrir la app, cargamos el número guardado
  }

  // Carga el contador guardado en el dispositivo.
  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _contador = prefs.getInt('contador') ?? 0);
  }

  // Guarda el contador en el dispositivo (¡persistencia!).
  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('contador', _contador);
  }

  void _sumar() {
    setState(() => _contador++);
    _guardar();
    // Si justo llegamos a la meta, mostramos un SnackBar (mensaje temporal).
    if (_contador == meta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Felicidades, llegaste a la meta! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  void _restar() {
    setState(() {
      if (_contador > 0) _contador--;
    });
    _guardar();
  }

  void _reiniciar() {
    setState(() => _contador = 0);
    _guardar();
  }

  // Mensaje según el contador.
  String _mensaje() {
    if (_contador == 0) return '¡Empieza a pulsar! 👇';
    if (_contador < meta) return '¡Sigue así! 💪';
    return '¡Meta alcanzada! 🎉';
  }

  // El icono CAMBIA según el progreso (devuelve un icono distinto).
  IconData _icono() {
    if (_contador == 0) return Icons.sentiment_neutral;
    if (_contador < meta) return Icons.sentiment_satisfied;
    return Icons.celebration;
  }

  @override
  Widget build(BuildContext context) {
    final nombre = _nombre.trim().isEmpty ? 'amigo' : _nombre;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎉 Mi App de Samuel'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Botón para cambiar entre tema claro 🌙 / oscuro ☀️.
          IconButton(
            icon: Icon(widget.esOscuro ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onCambiarTema,
          ),
          // Botón ℹ️ que NAVEGA a la pantalla "Acerca de".
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AcercaDe()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icono(), size: 64, color: Colors.deepPurple),
                const SizedBox(height: 12),
                Text(
                  '¡Hola, $nombre! 👋',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                // CAMPO DE TEXTO: al escribir, cambia el estado _nombre.
                SizedBox(
                  width: 240,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Escribe tu nombre',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (valor) => setState(() => _nombre = valor),
                  ),
                ),
                const SizedBox(height: 20),

                // ANIMACIÓN: el número "salta" (escala) cada vez que cambia.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$_contador',
                    // La "key" distinta hace que Flutter anime el cambio.
                    key: ValueKey<int>(_contador),
                    style: const TextStyle(
                      fontSize: 64,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(_mensaje(), style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                // Barra de progreso hacia la meta.
                SizedBox(
                  width: 220,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_contador / meta).clamp(0.0, 1.0),
                          minHeight: 12,
                          backgroundColor: Colors.deepPurple.shade100,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Meta: $meta',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _restar,
                      icon: const Icon(Icons.remove),
                      label: const Text('Restar'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _sumar,
                      icon: const Icon(Icons.add),
                      label: const Text('Sumar'),
                    ),
                  ],
                ),
                TextButton(onPressed: _reiniciar, child: const Text('Reiniciar')),
              ],
            ),
          ),
        ),
      ),
      // Pie de página (footer) — un toque profesional.
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Hecho con Flutter 💜 por Samuel',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}

// AcercaDe es una SEGUNDA PANTALLA (no cambia → StatelessWidget).
class AcercaDe extends StatelessWidget {
  const AcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flutter_dash, size: 90, color: Colors.deepPurple),
              SizedBox(height: 16),
              Text(
                'Mi App de Samuel',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Mi primera app hecha con Flutter 💜\npor Samuel, a los 15 años.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
