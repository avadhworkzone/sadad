import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/order/orderDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/orderReportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/productCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/showStoreResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/userMetaProfileResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/payment/product/productListRepo.dart';
import 'package:sadad_merchat_app/model/repo/payment/store/productCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/payment/store/showStoreRepo.dart';
import 'package:sadad_merchat_app/model/repo/payment/store/userMetaProfileRepo.dart';
import '../../../model/apimodels/requestmodel/dashboard/product/createProductRequestModel.dart';
import '../../../model/apimodels/requestmodel/dashboard/product/editProductRequestModel.dart';
import '../../../model/apimodels/responseModel/productScreen/product/createProductResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/product/editProductResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/product/myproductListResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderCountResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/product/productDetailResponseModel.dart';
import '../../../model/repo/payment/product/createProductRepo.dart';
import '../../../model/repo/payment/product/editProductRepo.dart';
import '../../../model/repo/payment/order/orderCountRepo.dart';
import '../../../model/repo/payment/order/orderDetailRepo.dart';
import '../../../model/repo/payment/order/orderListRepo.dart';
import '../../../model/repo/payment/product/productDetailRepo.dart';
import '../../../model/repo/payment/product/showEstoreRepo.dart';

class MyProductListViewModel extends GetxController {
  ApiResponse myProductListApiResponse = ApiResponse.initial('Initial');
  ApiResponse myProductListDataApiResponse = ApiResponse.initial('Initial');
  ApiResponse productDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse orderCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse orderListApiResponse = ApiResponse.initial('Initial');
  ApiResponse orderReportListApiResponse = ApiResponse.initial('Initial');
  ApiResponse showEStoreApiResponse = ApiResponse.initial('Initial');
  ApiResponse orderDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse createProductApiResponse = ApiResponse.initial('Initial');
  ApiResponse editProductApiResponse = ApiResponse.initial('Initial');
  ApiResponse userMetaProfileApiResponse = ApiResponse.initial('Initial');
  ApiResponse showStoreApiResponse = ApiResponse.initial('Initial');
  ApiResponse productCountApiResponse = ApiResponse.initial('Initial');

  RxString storeProduct = 'All'.obs;

  int startPosition = 0;

  int activeOrder = 0;
  String countOrderReport = '0';
  bool isShowEStore = false;
  List<bool> switchList = [];
  bool isPaginationLoading = false;
  List<MyProductListResponseModel> response = [];
  List<OrderListResponseModel> oLResponse = [];
  List<OrdData> oReportResponse = [];

  void setOrderInit() {
    myProductListApiResponse = ApiResponse.initial('Initial');
    myProductListDataApiResponse = ApiResponse.initial('Initial');
    productDetailApiResponse = ApiResponse.initial('Initial');
    orderCountApiResponse = ApiResponse.initial('Initial');
    orderListApiResponse = ApiResponse.initial('Initial');
    showEStoreApiResponse = ApiResponse.initial('Initial');
    orderDetailApiResponse = ApiResponse.initial('Initial');
    createProductApiResponse = ApiResponse.initial('Initial');
    editProductApiResponse = ApiResponse.initial('Initial');
    userMetaProfileApiResponse = ApiResponse.initial('Initial');
    showStoreApiResponse = ApiResponse.initial('Initial');
    productCountApiResponse = ApiResponse.initial('Initial');
    orderReportListApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;

    isPaginationLoading = false;
    oLResponse.clear();
    oReportResponse.clear();
  }

  switchClear() {
    print('before List is ${switchList}');

    switchList.clear();
    print('after List is ${switchList}');
    update();
  }

  void setProductInit() {
    startPosition = 0;
    response.clear();
    myProductListApiResponse = ApiResponse.initial('Initial');
    myProductListDataApiResponse = ApiResponse.initial('Initial');
    productDetailApiResponse = ApiResponse.initial('Initial');
    orderCountApiResponse = ApiResponse.initial('Initial');
    orderListApiResponse = ApiResponse.initial('Initial');
    showEStoreApiResponse = ApiResponse.initial('Initial');
    orderDetailApiResponse = ApiResponse.initial('Initial');
    createProductApiResponse = ApiResponse.initial('Initial');
    editProductApiResponse = ApiResponse.initial('Initial');
    userMetaProfileApiResponse = ApiResponse.initial('Initial');
    showStoreApiResponse = ApiResponse.initial('Initial');
    productCountApiResponse = ApiResponse.initial('Initial');

    isPaginationLoading = false;
  }

  void clearResponseLost() {
    response.clear();
    oReportResponse.clear();
    oLResponse.clear();
    startPosition = 0;
    update();
  }

  void clearProductListResponse() {
    startPosition = 0;
    response.clear();
    update();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  void deleteProductItem(String id) {
    print('response${response.map((e) => e.id)}');
    final index = response.indexWhere((element) => element.id.toString() == id);
    print('index is $index');
    print('id is $id');
    if (index > -1) {
      response.removeAt(index);
    }
    update();
  }

  /// productAllList...

  Future<void> myProductList(String id,
      {bool isLoading = false, String? filter}) async {
    if (myProductListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      myProductListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<MyProductListResponseModel> res = await MyProductListRepo()
          .myProductListRepo(id, end: 10, start: startPosition, filter: filter);
      print('res product ${response.length}');
      response.addAll(res);
      myProductListApiResponse = ApiResponse.complete(response);
      List<MyProductListResponseModel>? myProductListResponse;
      for (int i = startPosition; i < response.length; i++) {
        switchList.add(response[i].showproduct!);
      }
      activeOrder = switchList.where((element) => element == true).length;
      // switchList =
      //     List.generate(myProductListApiResponse.data.length, (index) => false);
      myProductListResponse = myProductListApiResponse.data;
      // myProductListResponse!.asMap().forEach((index, element) {
      //   print('element.showProduct  ${element.showproduct}');
      //   // if (element.showproduct == true) {
      //   //   switchList[index] = true;
      //   //   activeOrder = switchList.where((element) => element == true).length;
      //   // }
      // }
      // );
      print('switch list$switchList');
      startPosition += 10;

      setIsPaginationLoading(false);

      print("myProductListApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('myProductListApiResponse.....$e');
      myProductListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> myProductListData(String id,
      {bool isLoading = false,
      String? filter,
      bool? isFromSearch = false}) async {
    if (myProductListDataApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      myProductListDataApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<MyProductListResponseModel> res = await MyProductListRepo()
          .myProductListRepo(id, end: 10, start: startPosition, filter: filter);
      print('res product length after${response.length}');
      print('res product111 length after${res.length}');
      print('isFromSearch${isFromSearch}');
      if (isFromSearch == true) {
        response.clear();
        startPosition = 0;
      }
      print('res product111 length after1111${res.length}');
      response.addAll(res);
      print('res product List${response}');
      print('res product length before${response.length}');
      myProductListDataApiResponse = ApiResponse.complete(response);
      startPosition += 10;
      print('startPosition$startPosition');
      setIsPaginationLoading(false);
      print("myProductListDataApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('myProductListDataApiResponse.....$e');
      myProductListDataApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// productDetails...

  Future<void> productDetail(String id) async {
    productDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ProductDetailResponseModel res =
          await ProductDetailRepo().productDetailRepo(id);
      productDetailApiResponse = ApiResponse.complete(res);
      isShowEStore =
          productDetailApiResponse.data.isdisplayinpanel == 0 ? false : true;

      print("productDetailApiResponse RES:$res");
    } catch (e) {
      print('productDetailApiResponse.....$e');
      productDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///createProduct

  Future<void> createProduct(CreateProductRequestModel model) async {
    createProductApiResponse = ApiResponse.loading('Loading');

    try {
      CreateProductResponseModel createProductRes =
          await CreateProductRepo().createProduct(model);
      print('res is $createProductRes');
      createProductApiResponse = ApiResponse.complete(createProductRes);
      print("createProductApiResponse RES:$createProductRes");
    } catch (e) {
      print('createProductApiResponse.....$e');
      createProductApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///Edit Product

  Future<void> editProduct(String id, EditProductRequestModel model) async {
    editProductApiResponse = ApiResponse.loading('Loading');

    try {
      EditProductResponseModel editProductRes =
          await EditProductRepo().editProduct(id, model);
      print('res is $editProductRes');
      editProductApiResponse = ApiResponse.complete(editProductRes);
      print("editProductApiResponse RES:$editProductRes");
    } catch (e) {
      print('editProductApiResponse.....$e');
      editProductApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// show e store...

  Future<void> showEStore(String id, ShowStoreRequestModel model) async {
    showEStoreApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ShowStoreResponseModel response =
          await ShowEStoreRepo().showEStoreRepo(id, model);
      showEStoreApiResponse = ApiResponse.complete(response);
      print("showEStoreApiResponse RES:$response");
    } catch (e) {
      print('showEStoreApiResponse.....$e');
      showEStoreApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /////////////////////////////////////////////////////////////

  /// orderCount...

  Future<void> orderCount(String id, String date) async {
    orderCountApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      OrderCountResponseModel res = await OrderRepo().orderCountRepo(id, date);
      orderCountApiResponse = ApiResponse.complete(res);
      print("orderCountApiResponse RES:$res");
    } catch (e) {
      print('orderCountApiResponse.....$e');
      orderCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// orderList...
  Future<void> orderList(String id, String date,
      {bool isFromSearch = false}) async {
    if (orderListApiResponse.status != Status.COMPLETE) {
      orderListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);
    try {
      List<OrderListResponseModel> oLRes = await OrderListRepo()
          .orderListRepo(id, date, end: 10, start: startPosition);
      print('res pos ${oLResponse.length}');
      if (isFromSearch == true) {
        oLResponse.clear();
        startPosition = 0;
      }
      oLResponse.addAll(oLRes);
      orderListApiResponse = ApiResponse.complete(oLResponse);
      startPosition += 10;

      setIsPaginationLoading(false);
      print("orderListApiResponse RES:$oLResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('orderListApiResponse.....$e');
      orderListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// orderReportList...
  Future<void> orderReportList(String id, String date,
      {bool fromSearch = false}) async {
    if (orderReportListApiResponse.status != Status.COMPLETE) {
      orderReportListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);
    try {
      OrderReportResponseModel res = await OrderListRepo()
          .orderReportListRepo(id, date, end: 10, start: startPosition);
      print('res pos ${oReportResponse.length}');
      countOrderReport = res.count.toString();
      if (fromSearch == true) {
        oReportResponse.clear();
        startPosition = 0;
      }
      oReportResponse.addAll(res.ordData!);
      orderReportListApiResponse = ApiResponse.complete(oReportResponse);
      startPosition += 10;
      setIsPaginationLoading(false);
      print("orderListApiResponse RES:$oLResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('orderListApiResponse.....$e');
      orderReportListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///orderDetails...

  Future<void> orderDetail(String id) async {
    orderDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      OrderDetailResponseModel odRes =
          await OrderDetailRepo().orderDetailRepo(id);
      orderDetailApiResponse = ApiResponse.complete(odRes);
      print("orderDetailApiResponse RES:$odRes");
    } catch (e) {
      print('orderDetailApiResponse.....$e');
      orderDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///userMetaProfile
  Future<void> userMetaProfile(String id) async {
    userMetaProfileApiResponse = ApiResponse.loading('Loading');
    try {
      List<UserMetaProfileResponse> response =
          await UserMetaProfileRepo().userMetaProfileRepo(id);
      userMetaProfileApiResponse = ApiResponse.complete(response);
      print("userMetaProfileApiResponse RES:$response");
    } catch (e) {
      print('userMetaProfileApiResponse.....$e');
      userMetaProfileApiResponse = ApiResponse.error('error');
    }
    update();
  }
  //showStore

  Future<void> showStore(
      String id, DisplayPanelProductRequestModel model) async {
    showStoreApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ShowStoreResponseModel response =
          await ShowStoreRepo().showStoreRepo(id, model);
      showStoreApiResponse = ApiResponse.complete(response);
      print("showStoreApiResponse RES:$response");
    } catch (e) {
      print('showStoreApiResponse.....$e');
      showStoreApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///product count
  Future<void> productCount(
    String id,
    String filter,
    String dateFilter,
  ) async {
    productCountApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      ProductCountResponseModel response =
          await ProductCountRepo().productCountRepo(id, filter, dateFilter);
      productCountApiResponse = ApiResponse.complete(response);
      print("productCountApiResponse RES:$response");
    } catch (e) {
      print('productCountApiResponse.....$e');
      productCountApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
