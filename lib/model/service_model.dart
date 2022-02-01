class ServiceModel{
  String name ='';
  String docId='';
  double price= 0;
  ServiceModel({ this.name, this.price});

  ServiceModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['price'] == null ? 0 : double.parse(json['price'].tostring());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic> ();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }

  }