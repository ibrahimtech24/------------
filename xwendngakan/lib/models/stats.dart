class Stats {
  final int total;
  final int gov;
  final int priv;
  final int inst5;
  final int inst2;
  final int school;
  final int kg;
  final int dc;
  final int cities;
  final int pending;

  Stats({
    this.total = 0,
    this.gov = 0,
    this.priv = 0,
    this.inst5 = 0,
    this.inst2 = 0,
    this.school = 0,
    this.kg = 0,
    this.dc = 0,
    this.cities = 0,
    this.pending = 0,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      total: json['total'] ?? 0,
      gov: json['gov'] ?? 0,
      priv: json['priv'] ?? 0,
      inst5: json['inst5'] ?? 0,
      inst2: json['inst2'] ?? 0,
      school: json['school'] ?? 0,
      kg: json['kg'] ?? 0,
      dc: json['dc'] ?? 0,
      cities: json['cities'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'gov': gov,
      'priv': priv,
      'inst5': inst5,
      'inst2': inst2,
      'school': school,
      'kg': kg,
      'dc': dc,
      'cities': cities,
      'pending': pending,
    };
  }

  // Helper getters for different categories
  int get universities => gov + priv; // Total universities
  int get colleges => inst5; // 4-5 year institutes
  int get institutes => inst2; // 2 year institutes
  int get schools => school;
  int get kindergartens => kg;
  int get dayCares => dc;
}
