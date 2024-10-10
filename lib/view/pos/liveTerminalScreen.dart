// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/liveTerminalMapResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

const kGoogleApiKey = "AIzaSyC4F19Dw04Sy5iY2670bJLkLCGlW9YkK_U";

class CustomMapScreen extends StatefulWidget {
  final String lat;
  final String long;
  const CustomMapScreen({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<CustomMapScreen> createState() => _CustomMapScreenState();
}

class _CustomMapScreenState extends State<CustomMapScreen> {
  LatLng? sourceLatLong;
  TerminalViewModel terminalViewModel = Get.find();
  List<LiveTerminalMapResponseModel>? mapRes;
  CameraPosition? _initialCameraPosition;
  String terminalName = '';
  GoogleMapController? _googleMapController;
  Marker? _origin;
  final Set<Marker> _multiple_Origin = new Set();
  BitmapDescriptor? pinLocationIconSource, pinLocationIconDestination;
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    print("HELOOOOOOO!@#%^");
    connectivityViewModel.startMonitoring();
    // TODO: implement initState
    super.initState();
    location();
    initData();
    setCustomMapPin();
  }

  @override
  void dispose() {
    // _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        // sourceLatLong = LatLng(double.parse(lat), double.parse(long));
        return Scaffold(
          body: GetBuilder<TerminalViewModel>(
            builder: (controller) {
              if (controller.liveTerminalMapApiResponse.status ==
                      Status.INITIAL ||
                  controller.liveTerminalMapApiResponse.status ==
                      Status.LOADING) {
                return Center(child: Loader());
              }

              if (controller.liveTerminalMapApiResponse.status ==
                  Status.ERROR) {
                //return Text('Something wrong');
                return SessionExpire();
              }
              mapRes = controller.liveTerminalMapApiResponse.data;
              if (mapRes!.isEmpty || mapRes == null) {
                location();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            myLocationButtonEnabled: false,
                            // myLocationEnabled: false,
                            zoomControlsEnabled: false,

                            initialCameraPosition: _initialCameraPosition!,

                            onMapCreated: (controller) {
                              ///current lan-long
                              for (int i = 0; i < mapRes!.length; i++) {
                                _addMarker(
                                    sourceLatLong = LatLng(
                                        double.parse(
                                            mapRes![i].latitude.toString()),
                                        double.parse(
                                            mapRes![i].longitude.toString())),
                                    i.toString());
                              }

                              /// destination lat-long
                              _googleMapController = controller;
                            },
                            onTap: (latLong) {
                              //_addMarker(latLong);
                            },
                            markers: _multiple_Origin,
                            // onLongPress: _addMarker,
                          ),
                          Positioned(
                            top: 50,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorsUtils.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Icon(Icons.arrow_back_ios_outlined),
                                    ),
                                  ),
                                ),
                                customMediumLargeBoldText(
                                    title: 'Live Terminal'.tr),
                                width20()
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 50,
                              child: SizedBox(
                                width: Get.width,
                                height: Get.width * 0.35,
                                child: mapRes!.isEmpty || mapRes == null
                                    ? SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: mapRes!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                _addMarker(
                                                    sourceLatLong = LatLng(
                                                        double.parse(
                                                            mapRes![index]
                                                                .latitude
                                                                .toString()),
                                                        double.parse(
                                                            mapRes![index]
                                                                .longitude
                                                                .toString())),
                                                    index.toString());
                                                terminalName =
                                                    '${mapRes![index].name ?? "NA"}';
                                                _initialCameraPosition =
                                                    CameraPosition(
                                                  target: LatLng(
                                                      double.parse(
                                                          mapRes![index]
                                                              .latitude
                                                              .toString()),
                                                      double.parse(
                                                          mapRes![index]
                                                              .longitude
                                                              .toString())),
                                                  zoom: 13,
                                                );
                                                _googleMapController!
                                                    .animateCamera(CameraUpdate
                                                        .newCameraPosition(
                                                            _initialCameraPosition!));
                                                setState(() {});
                                                print('loc');
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorsUtils.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            color: ColorsUtils
                                                                .border,
                                                          ),
                                                          child: Image.asset(
                                                              Images.device),
                                                        ),
                                                        width15(),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            customMediumBoldText(
                                                                title:
                                                                    '${mapRes![index].name ?? "NA"}'),
                                                            customSmallSemiText(
                                                                title:
                                                                    '${mapRes![index].zone ?? "NA"}'),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      ColorsUtils
                                                                          .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        3),
                                                                child: customSmallSemiText(
                                                                    title:
                                                                        '${mapRes![index].isOnline == 0 ? 'Offline' : 'Online'}',
                                                                    color: ColorsUtils
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        width20(),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          );
                                        },
                                      ),
                              )),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (mapRes!.isNotEmpty || mapRes != null || mapRes != []) {
                _initialCameraPosition = CameraPosition(
                  target: LatLng(double.parse(mapRes![0].latitude.toString()),
                      double.parse(mapRes![0].longitude.toString())),
                  zoom: 13,
                );
                sourceLatLong = LatLng(
                    double.parse(mapRes![0].latitude.toString()),
                    double.parse(mapRes![0].longitude.toString()));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            myLocationButtonEnabled: false,
                            // myLocationEnabled: false,
                            zoomControlsEnabled: false,

                            initialCameraPosition: _initialCameraPosition!,

                            onMapCreated: (controller) {
                              ///current lan-long
                              for (int i = 0; i < mapRes!.length; i++) {
                                _addMarker(
                                    sourceLatLong = LatLng(
                                        double.parse(
                                            mapRes![i].latitude.toString()),
                                        double.parse(
                                            mapRes![i].longitude.toString())),
                                    i.toString());
                              }

                              /// destination lat-long
                              _googleMapController = controller;
                            },
                            onTap: (latLong) {
                              //_addMarker(latLong);
                            },
                            markers: _multiple_Origin,
                            // onLongPress: _addMarker,
                          ),
                          Positioned(
                            top: 50,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorsUtils.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Icon(Icons.arrow_back_ios_outlined),
                                    ),
                                  ),
                                ),
                                customMediumLargeBoldText(
                                    title: 'Live Terminal'.tr),
                                width20()
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 50,
                              child: SizedBox(
                                width: Get.width,
                                height: Get.width * 0.35,
                                child: mapRes!.isEmpty || mapRes == null
                                    ? SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: mapRes!.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return mapRes![index]
                                                          .latitude
                                                          .toString() ==
                                                      '0' &&
                                                  mapRes![index]
                                                          .longitude
                                                          .toString() ==
                                                      '0'
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // _addMarker(sourceLatLong =
                                                      //     LatLng(
                                                      //         double.parse(
                                                      //             mapRes![index]
                                                      //                 .latitude
                                                      //                 .toString()),
                                                      //         double.parse(
                                                      //             mapRes![index]
                                                      //                 .longitude
                                                      //                 .toString())));

                                                      terminalName =
                                                          '${mapRes![index].name ?? "NA"}';
                                                      _addMarker(
                                                          sourceLatLong = LatLng(
                                                              double.parse(
                                                                  mapRes![index]
                                                                      .latitude
                                                                      .toString()),
                                                              double.parse(mapRes![
                                                                      index]
                                                                  .longitude
                                                                  .toString())),
                                                          index.toString());
                                                      setState(() {});

                                                      _initialCameraPosition =
                                                          CameraPosition(
                                                        target: LatLng(
                                                            double.parse(
                                                                mapRes![index]
                                                                    .latitude
                                                                    .toString()),
                                                            double.parse(mapRes![
                                                                    index]
                                                                .longitude
                                                                .toString())),
                                                        zoom: 13,
                                                      );
                                                      _googleMapController!
                                                          .animateCamera(CameraUpdate
                                                              .newCameraPosition(
                                                                  _initialCameraPosition!));
                                                      setState(() {});
                                                      print('loc');
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              ColorsUtils.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  color:
                                                                      ColorsUtils
                                                                          .border,
                                                                ),
                                                                child: Image
                                                                    .asset(Images
                                                                        .device),
                                                              ),
                                                              width15(),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  customMediumBoldText(
                                                                      title:
                                                                          '${mapRes![index].name ?? "NA"}'),
                                                                  customSmallSemiText(
                                                                      title:
                                                                          '${mapRes![index].zone ?? "NA"}'),
                                                                  height20(),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: ColorsUtils
                                                                            .green,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              3),
                                                                      child: customSmallSemiText(
                                                                          title:
                                                                              '${mapRes![index].isOnline == 0 ? 'Offline' : 'Online'}',
                                                                          color:
                                                                              ColorsUtils.white),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              width20()
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                );
                                        },
                                      ),
                              )),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return SizedBox();
            },
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                location();
                setState(() {});
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              location();
              setState(() {});
              initData();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }

  void setCustomMapPin() async {
    pinLocationIconDestination = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1), 'assets/icons/map.png');
  }

  void _addMarker(LatLng pos, String counter) async {
    print('pos$pos');
    if ((pos != null)) {
      sourceLatLong = pos;

      setState(() {
        _multiple_Origin.add(Marker(
          markerId: MarkerId(counter),
          infoWindow: InfoWindow(title: '$terminalName'),
          // icon: pinLocationIconDestination!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        ));
      });
    }
  }

  initData() async {
    await terminalViewModel.terminalMap();
    if (mapRes != null) {
      print('name===${mapRes![0].name}');
      terminalName = mapRes![0].name;
      setState(() {});
    }
  }

  location() async {
    sourceLatLong = LatLng(double.parse(widget.lat), double.parse(widget.long));
    _initialCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.lat), double.parse(widget.long)),
      zoom: 13,
    );
    print(sourceLatLong);
    print(_initialCameraPosition);
  }
}
