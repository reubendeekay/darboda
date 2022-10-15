import 'package:darboda/constants.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/screens/home/confirm_map_screen.dart';
import 'package:darboda/screens/home/choose_map_location.dart';
import 'package:darboda/screens/home/searching_map.dart';
import 'package:darboda/screens/search/amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_pick_place/models/address_model.dart';
import 'package:google_place/google_place.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  String searchTerm = '';
  String originalSearchTerm = '';

  @override
  Widget build(BuildContext context) {
    final userLocation = Provider.of<LocationProvider>(context).userLocation!;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close)),
        backgroundColor: Colors.white,
        title: const Text('Select Route'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 130,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Stack(
                      children: [
                        Container(
                          height: 58,
                          width: 4,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [kPrimaryColor, Colors.green],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          margin: const EdgeInsets.only(left: 10, top: 15),
                        ),
                        Column(
                          children: const [
                            Icon(
                              Icons.play_circle_fill_outlined,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              height: 43,
                              width: 2,
                            ),
                            Icon(
                              Icons.stop_circle,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: userLocation.address,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(),
                            hintText: 'Pickup Location',
                            hintStyle: const TextStyle(fontSize: 14),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Hero(
                          tag: 'seach_place_field',
                          transitionOnUserGestures: true,
                          child: Material(
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  searchTerm = val;
                                });
                              },
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Destination',
                                focusedBorder: const OutlineInputBorder(),
                                hintStyle: const TextStyle(fontSize: 14),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.grey[100],
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.add,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (searchTerm.isEmpty) const Spacer(),
            if (searchTerm.isNotEmpty || originalSearchTerm.isNotEmpty)
              Expanded(
                child: searchTerm.isNotEmpty || originalSearchTerm.isNotEmpty
                    ? FutureBuilder(
                        future: Provider.of<LocationProvider>(context,
                                listen: false)
                            .searchPlace(searchTerm),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              ...snapshot.data!
                                  .map((e) => Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.green[200],
                                              child: const Icon(
                                                Iconsax.location,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                            ),
                                            onTap: () async {
                                              var googlePlace = GooglePlace(
                                                  "AIzaSyCzgo2cyjncjSLKElT7OIC0lj9hDdj1Fj4");

                                              var place = await googlePlace
                                                  .details
                                                  .get(e['placeId']);

                                              final selectedLocation = LatLng(
                                                  place!.result!.geometry!
                                                      .location!.lat!,
                                                  place.result!.geometry!
                                                      .location!.lng!);

                                              Get.to(
                                                () => ConfirmMapScreen(
                                                  location: selectedLocation,
                                                  address: e['place'],
                                                ),
                                              );
                                            },
                                            title: Text(e['name']),
                                            subtitle: Text(e['place']),
                                            dense: true,
                                          ),
                                          const Divider(),
                                        ],
                                      ))
                                  .toList(),
                            ],
                          );
                        }))
                    : SizedBox(
                        width: 5,
                      ),
              ),
            GestureDetector(
              onTap: () {
                Get.to(() => const ChooseMapLocation());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: Row(
                  children: const [
                    Icon(
                      Icons.map_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Choose a place on the map'),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 15,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
