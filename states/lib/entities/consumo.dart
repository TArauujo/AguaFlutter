class DiaConsumo {
  String dia;
  int consumido;
  int meta;
  bool metaAtingida; // 👈 NOVO

  DiaConsumo({
    required this.dia,
    required this.meta,
    this.consumido = 0,
    this.metaAtingida = false, // 👈 padrão
  });
}
