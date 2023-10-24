class CarTypeStruct {
  final String imageName;
  final String title;
  var selected = false;
  final List<CarSubtypeStruct> types = [];

  CarTypeStruct(this.imageName, this.title, {this.selected = false});

  void selectSubtype(CarSubtypeStruct? s) {
    if (s == null) {
      return;
    }
    for (final e in types) {
      if (e == s) {
        e.selected = true;
      }
    }
  }
}

class CarSubtypeStruct {
  final int id;
  final String imageName;
  final String image;
  final String title;
  final String subTitle;
  final double price;
  var selected = false;

  CarSubtypeStruct(this.id, this.imageName, this.image, this.title, this.subTitle, this.price,
      {this.selected = false});
}

class ResourceCarTypes {
  static final List<CarTypeStruct> res = [];

  static void deselect() {
    for (var e in res) {
      e.selected = false;
    }
  }

  static void deselectSubType(CarTypeStruct? s) {
    if (s == null) {
      return;
    }
    for (var e in s.types) {
      e.selected = false;
    }
  }

  static CarTypeStruct? selected() {
    for (final e in res) {
      if (e.selected) {
        return e;
      }
    }
    return null;
  }

  static CarSubtypeStruct? selectedSubtype() {
    final cts = selected();
    if (cts == null) {
      return null;
    }
    for (final e in cts!.types) {
      if (e.selected) {
        return e;
      }
    }
  }
}
