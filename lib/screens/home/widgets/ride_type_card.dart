import 'package:flutter/material.dart';

class RideTypeCard extends StatelessWidget {
  final String title;
  final String minutes;
  final String asset;
  final bool isSelected;

  const RideTypeCard(
      {super.key,
      required this.title,
      required this.minutes,
      required this.isSelected,
      required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            minutes,
            style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
          ),
          Row(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/$asset.png',
                height: 80,
                width: 110,
                fit: BoxFit.fitHeight,
              ),
            ],
          )
        ],
      ),
    );
  }
}
