import 'dart:io';

void main() {
  somaAB();
  parOuImpar();
  somaOuMultiplicacao();
  ordemDecrescente();
  MultideTres();
  imparenre100200();
  tabuada();
  fatorial();
}

void somaAB() {
  print('Digite um valor para A:');
  int a = int.parse(stdin.readLineSync()!);
  print('Digite o valor de B:');
  int b = int.parse(stdin.readLineSync()!);
  print('Digite o valor de C:');
  int c = int.parse(stdin.readLineSync()!);

  if (a + b < c) {
    print('A + B é menor que C');
  } else {
    print('A + B nao é menor que C');
  }
}

void parOuImpar() {
  print('Digite um numero:');
  int n = int.parse(stdin.readLineSync()!);

  if (n % 2 == 0) {
    print('é par');
  } else {
    print('é impar');
  }
}

void somaOuMultiplicacao() {
  print('Digite o valor de A:');
  int a = int.parse(stdin.readLineSync()!);
  print('Digite o valor de B:');
  int b = int.parse(stdin.readLineSync()!);
  int c;

  if (a == b) {
    c = a + b;
  } else {
    c = a * b;
  }
  print('O resultado é ' + c.toString());
}

void ordemDecrescente() {
  print('Digite o primeiro valor:');
  int a = int.parse(stdin.readLineSync()!);
  print('Digite o segundo valor:');
  int b = int.parse(stdin.readLineSync()!);
  print('Digite o terceiro valor:');
  int c = int.parse(stdin.readLineSync()!);

  List<int> valores = [a, b, c];
  valores.sort((x, y) => y.compareTo(x)); // valores de y para x, descrescente
  print('Valores em ordem decrescente:' + valores.toString());
}

void MultideTres() {
  int soma = 0;
  for (int i = 1; i <= 500; i += 2) {
    if (i % 3 == 0) {
      soma += i;
    }
  }
  print('Soma dos impares: ' + soma.toString());
}

void imparenre100200() {
  print('Numeros impares:');
  for (int i = 101; i < 200; i += 2) {
    print(i);
  }
}

void tabuada() {
  print('Digite um valor entre 1 e 10: ');
  int n = int.parse(stdin.readLineSync()!);
  if (n < 1 || n > 10) {
    print('O valor deve ser entre 1 e 10');
    return;
  }
  for (int i = 0; i <= 10; i++) {
    print('$i x $n = ${i * n}'); // 0 + 5 = 0 * 5
  }
}

void fatorial() {
  print('Digite o valor de A:');
  int a = int.parse(stdin.readLineSync()!);
  int resultado = 1;
  String sequencia = '';
  for (int i = a; i >= 1; i--) {
    resultado *= i;
    if (i == 1) {
      sequencia += '$i'; // adiciona diretamente na string
    } else {
      sequencia += '$i x ';
    }
  }
  print('$a! = $sequencia = $resultado');
}
