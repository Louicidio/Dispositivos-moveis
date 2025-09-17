enum Naipe {
    OURO,
    PAUS,
    COPAS,
    ESPADAS
}

enum Valor {
    AS, REI, DAMA, VALETE, DEZ, NOVE, OITO, SETE, SEIS, CINCO, QUATRO, TRES, DOIS
}

class Card {
    Naipe naipe;
    Valor valor;

    Card({required this.naipe, required this.valor});

    String toString() {
        return 'Carta: $valor de $naipe';
    }
}

class Baralho {
    List<Card> cartas = [];

    Baralho() {
        for (var n in Naipe.values) {
            for (var v in Valor.values) {
                cartas.add(Card(naipe: n, valor: v));
            }
        }
    }

    void embaralhar() {
        cartas.shuffle();
    }

    Card? comprar() {
        if (cartas.isEmpty) return null;
        return cartas.removeAt(0);
    }

    int cartasRestantes() {
        return cartas.length;
    }
}

main() {
    Baralho baralho = Baralho();
    baralho.embaralhar();

    Card? cartaComprada = baralho.comprar();
    if (cartaComprada != null) {
        print('Você comprou: $cartaComprada');
    } else {
        print('Não há cartas no baralho.');
    }

    print('Cartas restantes no baralho: ${baralho.cartasRestantes()}');
}
