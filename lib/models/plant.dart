class Plant {
  int id;
  String mainCategory;
  String commonName;
  String latinName;
  String? family;
  String? style;
  String? watering;
  String? lightTolered;
  String? lightIdeal;
  String? growth;
  String? pruning;
  String? appeal;
  String? description;
  String? imgUrl;
  String? url;
  List<String>? insects;
  List<String>? origin;
  List<String>? colorLeaf;
  List<String>? colorBlooms;

  Map<String, dynamic>? heightAtPurchase;
  Map<String, dynamic>? heightPotential;
  Map<String, dynamic>? widthAtPurchase;
  Map<String, dynamic>? widthPotential;
  Map<String, dynamic>? potDiameter;
  Map<String, dynamic>? temperatureMin;
  Map<String, dynamic>? temperatureMax;
  String? bloomingSeason;
  int? wateringScheduleDays;

  Plant({
    required this.id,
    required this.mainCategory,
    required this.commonName,
    required this.latinName,
    this.family,
    this.style,
    this.watering,
    this.lightTolered,
    this.lightIdeal,
    this.growth,
    this.pruning,
    this.appeal,
    this.description,
    this.imgUrl,
    this.url,
    this.insects,
    this.origin,
    this.colorLeaf,
    this.colorBlooms,
    this.heightAtPurchase,
    this.heightPotential,
    this.widthAtPurchase,
    this.widthPotential,
    this.potDiameter,
    this.temperatureMin,
    this.temperatureMax,
    this.bloomingSeason,
    this.wateringScheduleDays,
  });

  factory Plant.fromJson(Map<String, dynamic> data) {
    return Plant(
      id: data['local_id'],
      mainCategory: data['Categories'] ?? '',
      commonName: data['Common name'] is List
          ? (data['Common name'] as List).first
          : data['Common name'] ?? '',
      latinName: data['Latin name'] ?? '',
      family: data['Family'],
      style: data['Style'],
      watering: data['Watering'],
      lightTolered: data['Light tolered'],
      lightIdeal: data['Light ideal'],
      growth: data['Growth'],
      pruning: data['Pruning'],
      appeal: data['Appeal'],
      description: data['Description'],
      imgUrl: data['thumbnail'],
      url: data['Url'],
      insects: data['Insects'] != null ? List<String>.from(data['Insects']) : null,
      origin: data['Origin'] != null ? List<String>.from(data['Origin']) : null,
      colorLeaf: data['Color of leaf'] != null ? List<String>.from(data['Color of leaf']) : null,
      colorBlooms: data['Color of blooms'] != null ? [data['Color of blooms']] : null,
      heightAtPurchase: data['Height at purchase'],
      heightPotential: data['Height potential'],
      widthAtPurchase: data['Width at purchase'],
      widthPotential: data['Width potential'],
      potDiameter: data['Pot diameter (cm)'],
      temperatureMin: data['Temperature min'],
      temperatureMax: data['Temperature max'],
      bloomingSeason: data['Blooming season'],
      wateringScheduleDays: data['watering_schedule_days']
    );
  }
}
