class BrokerModel {
  BrokerModel({
    required this.cnpj,
    required this.tipo,
    required this.nomeSocial,
    required this.nomeComercial,
    required this.status,
    required this.email,
    required this.telefone,
    required this.cep,
    required this.pais,
    required this.uf,
    required this.municipio,
    required this.bairro,
    required this.complemento,
    required this.logradouro,
    required this.dataPatrimonioLiquido,
    required this.valorPatrimonioLiquido,
    required this.codigoCvm,
    required this.dataInicioSituacao,
    required this.dataRegistro,
  });

  final String? cnpj;
  final String? tipo;
  final String nomeSocial;
  final String nomeComercial;
  final String? status;
  final String? email;
  final String? telefone;
  final String? cep;
  final String? pais;
  final String? uf;
  final String municipio;
  final String? bairro;
  final String? complemento;
  final String? logradouro;
  final DateTime? dataPatrimonioLiquido;
  final double valorPatrimonioLiquido;
  final String? codigoCvm;
  final DateTime? dataInicioSituacao;
  final DateTime? dataRegistro;

  factory BrokerModel.fromJson(Map<String, dynamic> json){
    return BrokerModel(
      cnpj: json["cnpj"],
      tipo: json["type"],
      nomeSocial: json["nome_social"],
      nomeComercial: json["nome_comercial"] ?? '',
      status: json["status"],
      email: json["email"],
      telefone: json["telefone"],
      cep: json["cep"],
      pais: json["pais"],
      uf: json["uf"],
      municipio: json["municipio"] ?? '',
      bairro: json["bairro"],
      complemento: json["complemento"],
      logradouro: json["logradouro"],
      dataPatrimonioLiquido: DateTime.tryParse(json["data_patrimonio_liquido"] ?? ""),
      valorPatrimonioLiquido: double.tryParse(json["valor_patrimonio_liquido"] ?? "") ?? 0.00,
      codigoCvm: json["codigo_cvm"],
      dataInicioSituacao: DateTime.tryParse(json["data_inicio_situacao"] ?? ""),
      dataRegistro: DateTime.tryParse(json["data_registro"] ?? ""),
    );
  }

}