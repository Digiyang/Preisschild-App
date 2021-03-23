class LocationDao {
  int id;
  String street;
  String houseNumber;
  int postalCode;
  String city;
  String country;
  String phone;
  String website;
  String mapCoordinates;

  LocationDao(int id,
              String street, String houseNumber,
              int postalCode, String city,
              String country, String phone,
              String website, String mapCoordinates) {

    this.id = id;
    this.street = street;
    this.houseNumber = houseNumber;
    this.postalCode = postalCode;
    this.city = city;
    this.country = country;
    this.phone = phone;
    this.website = website;
    this.mapCoordinates = mapCoordinates;
  }

  int get locationId {
    return id;
  }

  String get streetName {
    return street;
  }

  String get houseNo {
    return houseNumber;
  }

  int get postCode {
    return postalCode;
  }

  String get cityName {
    return city;
  }

  String get countryName {
    return country;
  }

  String get phoneNumber {
    return phone;
  }

  String get websiteUrl {
    return website;
  }

  String get mapCoordinateValues {
    return mapCoordinates;
  }

  double get mapLongitude {
    return double.parse(mapCoordinates.split(",")[0].trim());
  }

  double get mapLatitude {
    return double.parse(mapCoordinates.split(",")[1].trim());
  }

  static List<LocationDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<LocationDao> location_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        location_details.add(LocationDao(int.parse(values[1].trim()),
                                          values[2].trim(), values[3].trim(),
                                          int.parse(values[4].trim()), values[5].trim(),
                                          values[6].trim(), values[7].trim(),
                                          values[8].trim(), values[9].trim()));
      }
    }

    return location_details;
  }
}