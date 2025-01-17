import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/model/body/record_location_body.dart';
import 'package:efood_multivendor_driver/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_driver/data/model/response/ignore_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/data/repository/order_repo.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  List<OrderModel> _allOrderList;
  List<OrderModel> _currentOrderList;
  List<OrderModel> _deliveredOrderList;
  List<OrderModel> _completedOrderList;
  List<OrderModel> _latestOrderList;
  List<OrderDetailsModel> _orderDetailsModel;
  List<IgnoreModel> _ignoredRequests = [];
  List<int> _isCheckedValues = [];

  bool _isLoading = false;
  bool _isStatusUpdatedLoading = false;
  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  Placemark _placeMark = Placemark(
      name: 'Unknown',
      subAdministrativeArea: 'Location',
      isoCountryCode: 'Found');
  String _otp = '';
  bool _paginate = false;
  int _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  OrderModel _orderModel;

  List<OrderModel> get allOrderList => _allOrderList;
  List<OrderModel> get currentOrderList => _currentOrderList;
  List<OrderModel> get deliveredOrderList => _deliveredOrderList;
  List<OrderModel> get completedOrderList => _completedOrderList;
  List<OrderModel> get latestOrderList => _latestOrderList;
  List<OrderDetailsModel> get orderDetailsModel => _orderDetailsModel;
  bool get isLoading => _isLoading;
  bool get isStatusUpdatedLoading => _isStatusUpdatedLoading;
  Position get position => _position;
  Placemark get placeMark => _placeMark;
  String get address =>
      '${_placeMark.name} ${_placeMark.subAdministrativeArea} ${_placeMark.isoCountryCode}';
  String get otp => _otp;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;
  OrderModel get orderModel => _orderModel;
  List<int> get isCheckedValues => _isCheckedValues;

  Future<void> getAllOrders() async {
    Response response = await orderRepo.getAllOrders();
    if (response.statusCode == 200) {
      _allOrderList = [];
      response.body
          .forEach((order) => _allOrderList.add(OrderModel.fromJson(order)));
      _deliveredOrderList = [];
      _allOrderList.forEach((order) {
        if (order.orderStatus == 'delivered') {
          _deliveredOrderList.add(order);
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCompletedOrders(int offset) async {
    if (offset == 1) {
      _offsetList = [];
      _offset = 1;
      _completedOrderList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await orderRepo.getCompletedOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _completedOrderList = [];
        }
        _completedOrderList
            .addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<void> getCurrentOrders() async {
    _isLoading = false;
    Response response = await orderRepo.getCurrentOrders();
    if (response.statusCode == 200) {
      _currentOrderList = [];
      response.body.forEach(
          (order) => _currentOrderList.add(OrderModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getOrderWithId(int orderId) async {
    _isLoading = false;
    Response response = await orderRepo.getOrderWithId(orderId);
    if (response.statusCode == 200) {
      _orderModel = OrderModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getLatestOrders() async {
    Response response = await orderRepo.getLatestOrders();
    if (response.statusCode == 200) {
      _latestOrderList = [];
      List<int> _ignoredIdList = [];
      _ignoredRequests.forEach((ignore) {
        _ignoredIdList.add(ignore.id);
      });
      response.body.forEach((order) {
        if (!_ignoredIdList.contains(OrderModel.fromJson(order).id)) {
          _latestOrderList.add(OrderModel.fromJson(order));
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> recordLocation(RecordLocationBody recordLocationBody) async {
    Response response = await orderRepo.recordLocation(recordLocationBody);
    if (response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<bool> updateOrderStatus(
    int id,
    int index,
    String status, {
    bool back = false,
    String deliveryTime,
  }) async {
    _isLoading = true;
    update();
    UpdateStatusBody _updateStatusBody = UpdateStatusBody(
      orderId: id ?? _currentOrderList[index].id,
      status: status,
      otp: status == 'delivered' ? _otp : null,
      deliveryTime: deliveryTime ?? null,
    );
    Response response = await orderRepo.updateOrderStatus(_updateStatusBody);
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      if (back) {
        Get.back();
      }
      // check if id exists in current order list
      if (_currentOrderList
          .any((order) => order.id == _updateStatusBody.orderId)) {
        _currentOrderList
            .firstWhere((order) => order.id == _updateStatusBody.orderId)
            .orderStatus = status;
      }
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();

    return _isSuccess;
  }

  Future<void> updatePaymentStatus(int index, String status) async {
    // _isLoading = true;
    // update();
    UpdateStatusBody _updateStatusBody =
        UpdateStatusBody(orderId: _currentOrderList[index].id, status: status);
    Response response = await orderRepo.updatePaymentStatus(_updateStatusBody);
    if (response.statusCode == 200) {
      _currentOrderList[index].paymentStatus = status;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    // _isLoading = false;
    update();
  }

  Future<void> getOrderDetails(int orderID) async {
    _isLoading = false;
    _orderDetailsModel = null;
    Response response = await orderRepo.getOrderDetails(orderID);
    if (response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body.forEach((orderDetails) =>
          _orderDetailsModel.add(OrderDetailsModel.fromJson(orderDetails)));
    } else {
      ApiChecker.checkApi(response);
    }
    initCheckValues();
    update();
  }

  Future<bool> acceptOrder(
    int orderID,
    int index,
    String arrivalTime,
    OrderModel orderModel,
  ) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.acceptOrder(
      orderID,
      arrivalTime
    );
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      _latestOrderList.removeAt(index);
      _currentOrderList.add(orderModel);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<bool> isChecked(int orderId, int foodItemId, int isChecked) async {
    // _isLoading = true;
    Response response =
        await orderRepo.updateIsChecked(orderId, foodItemId, isChecked);

    bool _isSuccess;
    print(response.statusCode);
    if (response.statusCode == 200) {
      _isSuccess = true;
      update();
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    // _isLoading = false;
    update();
    return _isSuccess;
  }

  void getIgnoreList() {
    _ignoredRequests = [];
    _ignoredRequests.addAll(orderRepo.getIgnoreList());
  }

  void ignoreOrder(int index) {
    _ignoredRequests
        .add(IgnoreModel(id: _latestOrderList[index].id, time: DateTime.now()));
    _latestOrderList.removeAt(index);
    orderRepo.setIgnoreList(_ignoredRequests);
    update();
  }

  void removeFromIgnoreList() {
    List<IgnoreModel> _tempList = [];
    _tempList.addAll(_ignoredRequests);
    for (int index = 0; index < _tempList.length; index++) {
      if (Get.find<SplashController>()
              .currentTime
              .difference(_tempList[index].time)
              .inMinutes >
          10) {
        _tempList.removeAt(index);
      }
    }
    _ignoredRequests = [];
    _ignoredRequests.addAll(_tempList);
    orderRepo.setIgnoreList(_ignoredRequests);
  }

  Future<void> getCurrentLocation() async {
    Position _currentPosition = await Geolocator.getCurrentPosition();
    if (!GetPlatform.isWeb) {
      try {
        List<Placemark> _placeMarks = await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);
        _placeMark = _placeMarks.first;
      } catch (e) {}
    }
    _position = _currentPosition;
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if (otp != '') {
      update();
    }
  }

  addCheck(int orderId, int foodId, int ischecked) {
    if (_isCheckedValues.contains(foodId)) {
      _isCheckedValues.remove(foodId);
    } else {
      _isCheckedValues.add(foodId);
    }
    isChecked(orderId, foodId, ischecked);
    update();
  }

  void initCheckValues() {
    _isCheckedValues.clear();
    if (orderDetailsModel != null) {
      for (OrderDetailsModel foodItem in orderDetailsModel) {
        print(foodItem.isChecked);
        if (foodItem.isChecked == 1) {
          _isCheckedValues.add(foodItem.foodId);
        }
      }
    }
  }
}
