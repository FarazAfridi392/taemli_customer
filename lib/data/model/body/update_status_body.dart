class UpdateStatusBody {
  String token;
  int orderId;
  String status;
  String otp;
  String deliveryTime;
  String method = 'put';

  UpdateStatusBody({this.token, this.orderId, this.status, this.otp,this.deliveryTime});

  UpdateStatusBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    orderId = json['order_id'];
    status = json['status'];
    otp = json['otp'];
    status = json['_method'];
    deliveryTime = json['delivery_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['_method'] = this.method;
    data['delivery_time'] = this.deliveryTime;
    return data;
  }
}
