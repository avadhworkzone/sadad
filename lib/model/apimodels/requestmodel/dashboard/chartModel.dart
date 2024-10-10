///charts
class SalesData extends BaseModel {
  SalesData({this.year, this.sales, this.sales2});

  final String? year;
  final dynamic sales;
  final dynamic sales2;
}

class TransactionSourceData {
  TransactionSourceData(this.transaction, this.data1, this.data2);

  final String transaction;
  final dynamic data1;
  final dynamic data2;
}

class BaseModel {
  int position = 0;
}
