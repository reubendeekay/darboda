import 'package:darboda/screens/home/widgets/ride_type_card.dart';
import 'package:darboda/screens/search/search_place.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeSlidingPanel extends StatefulWidget {
  final bool isDelivery;
  final Function(bool isDel) onChanged;

  const HomeSlidingPanel(
      {super.key, required this.isDelivery, required this.onChanged});

  @override
  State<HomeSlidingPanel> createState() => _HomeSlidingPanelState();
}

class _HomeSlidingPanelState extends State<HomeSlidingPanel> {
  late int selectedType;
  @override
  void initState() {
    super.initState();
    selectedType = widget.isDelivery ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: SlidingUpPanel(
        color: Colors.white,
        boxShadow: null,
        backdropEnabled: false,
        minHeight: 105,
        maxHeight: 300,
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            controller: sc,
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const SearchPlaceScreen());
                  },
                  child: Hero(
                    tag: 'seach_place_field',
                    transitionOnUserGestures: true,
                    child: Material(
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            hintText: 'Where to?',
                            hintStyle: const TextStyle(fontSize: 14),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.motorcycle),
                            suffixIcon: const Icon(Iconsax.global_search)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Choose Type',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 0;
                          widget.onChanged(false);
                        });
                      },
                      child: RideTypeCard(
                        asset: 'bike',
                        title: 'Book Ride',
                        minutes: '30 min',
                        isSelected: selectedType == 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 1;
                          widget.onChanged(true);
                        });
                      },
                      child: RideTypeCard(
                        asset: 'box',
                        title: 'Delivery',
                        minutes: '18 min',
                        isSelected: selectedType == 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
      ),
    );
  }
}
