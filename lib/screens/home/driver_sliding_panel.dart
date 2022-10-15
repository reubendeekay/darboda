import 'package:darboda/helpers/distance_helper.dart';
import 'package:darboda/models/request_model.dart';
import 'package:darboda/providers/request_provider.dart';
import 'package:darboda/screens/chat/chat_room.dart';
import 'package:darboda/screens/home/widgets/ride_type_card.dart';
import 'package:darboda/screens/search/search_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class DriverSlidingPanel extends StatefulWidget {
  const DriverSlidingPanel({super.key, this.request});
  final RequestModel? request;

  @override
  State<DriverSlidingPanel> createState() => _DriverSlidingPanelState();
}

class _DriverSlidingPanelState extends State<DriverSlidingPanel> {
  String getTitle() {
    if (widget.request!.status == 'accepted') {
      return 'Your rider is on the way';
    }

    if (widget.request!.status == 'arrived') {
      return 'Your rider has arrived';
    }

    if (widget.request!.status == 'ongoing') {
      return 'Heading to your destination';
    }
    if (widget.request!.status == 'completed') {
      return 'Your trip is completed';
    }

    return 'Your rider is on the way';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: SlidingUpPanel(
        color: Colors.white,
        boxShadow: null,
        backdropEnabled: false,
        minHeight: 210,
        maxHeight: 390,
        header: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        panelBuilder: (ScrollController sc) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            controller: sc,
            shrinkWrap: true,
            children: widget.request == null
                ? []
                : [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      getTitle(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(widget.request!.rider!.vehicleModel!),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(widget.request!.rider!.vehicleNumber!),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                  widget.request!.rider!.profilePic!),
                            ),
                            const SizedBox(
                              height: 2.5,
                            ),
                            Text(
                              widget.request!.rider!.name!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(ChatRoom.routeName,
                                arguments: {
                                  'user': widget.request!.rider,
                                  'chatRoomId': widget.request!.id
                                });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle),
                                child: const Icon(Iconsax.message),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              const Text(
                                'Chat',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            bool? res =
                                await FlutterPhoneDirectCaller.callNumber(
                                    widget.request!.rider!.phoneNumber!);

                            if (res == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Oops could not make phone call'),
                              ));
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle),
                                child: const Icon(Iconsax.call),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              const Text(
                                'Call',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Trip details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.location,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.request!.destinationAddress!,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showBottomSheet(
                            context: context,
                            builder: (ctx) =>
                                cancelDialogWidget(widget.request!, context));
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.list),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Ride options')
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Transit Cost'),
                        Text(
                          'TZS ${moneyFormat(widget.request!.amount!)}',
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ]),
      ),
    );
  }

  Widget cancelDialogWidget(RequestModel request, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text(
                'Ride options',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();

                await Provider.of<RequestProvider>(context, listen: false)
                    .cancelRide(request);
              },
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[700],
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('Cancel Ride')
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ])),
    );
  }
}
