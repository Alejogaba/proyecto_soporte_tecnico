class Utilidades {
  String capitalizarPalabras(String texto) {
  List<String> palabras = texto.split(' ');
  for (int i = 0; i < palabras.length; i++) {
    String palabra = palabras[i];
    if (palabra.isNotEmpty) {
      palabras[i] = palabra[0].toUpperCase() + palabra.substring(1).toLowerCase();
    }
  }
  return palabras.join(' ');
} 
}