String processProductionYear(int? productionYear) {
  if (productionYear == null) {
    return "Unknown Year";
  } else {
    return productionYear.toString();
  }
}
