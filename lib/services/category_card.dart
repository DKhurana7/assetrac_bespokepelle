import 'package:flutter/material.dart';


class CategoryCard extends StatelessWidget {
  final String cardName;
  final IconData cardIcon;
  final Widget press;
  const CategoryCard({
    Key? key,
    required this.cardName,
    required this.cardIcon, required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 17), blurRadius: 17, spreadRadius: -23)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => press)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                Icon(cardIcon, color: const Color(0XFF0A233E), size: 75),
                const SizedBox(height: 10,),
                Text(
                  cardName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

