void main() {
  // 1
  print('1:');
  List<String> frutas = ['maca', 'banana', 'uva', 'manga', 'pera', 'abacaxi']; 
  print('Lista de frutas: $frutas\n');
  // 2
  print('2: ${frutas[2]}\n'); 
  // 3
  print('3:'); 
  frutas.add('laranja');
  
  if (frutas.contains('maca')) {
    frutas.remove('maca');
    print('$frutas');
  }
  print('');
  // 4
  print('4:'); 
  for (int i = 0; i < frutas.length; i++) {
    print('${i + 1}. ${frutas[i].toUpperCase()}');
  }
  print('');
  
  // 5
  print('5:');
  frutas.forEach((fruta) {
    print('${frutas.indexOf(fruta) + 1}. ${fruta.toLowerCase()}');
  });
  print('');
  
  // 6
  print('6:');
  List<String> frutasComA = frutas.where((fruta) => fruta.toLowerCase().startsWith('a')).toList();
  print('$frutasComA\n');

  // 7
  print('7:');
  Map<String, double> precosFrutas = {
    'banana': 3.50,
    'uva': 5.00,
    'manga': 4.50,
    'pêra': 5.99,
    'laranja': 2.99,
  };
  print('$precosFrutas\n');

  // 8
  print('8:');
  for (String fruta in precosFrutas.keys) {
    print('$fruta: ${precosFrutas[fruta]?.toStringAsFixed(2)} reais');
  }
  print('');
  
  // 9
  print('9:');
  var filtrarPares = (List<int> numeros) { 
    return numeros.where((numero) => numero % 2 == 0).toList();
  };
  
  List<int> numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> numerosPares = filtrarPares(numeros);
  print('Lista com numeros pares: $numerosPares');
  print('');

  var pessoas = [
    {'nome': 'Ana', 'idade': 20},
    {'nome': 'Bruno', 'idade': 17},
    {'nome': 'Luis', 'idade': 21},
  ];

 // desafio
  print('Maiores de idade:');
  pessoas.where((p) => (p['idade'] as int) >= 18).forEach((p) {
    print('${p['nome']} ${p['idade']}');
  });
}