import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardShop extends StatefulWidget {
  final Materials material;
  final Function(Materials) changeQuantity;

  final bool showQuantity;

  const CardShop({
    super.key,
    required this.material,
    required this.changeQuantity,
    required this.showQuantity,
  });

  @override
  State<CardShop> createState() => _CardShopState();
}

class _CardShopState extends State<CardShop> {
  int quantity = 0;

  void verification() {
    if (quantity >= 0) {
      widget.changeQuantity(widget.material);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int salePrice = int.parse(widget.material.salePrice);

    double percentage = 0;
    double discount = 0;
    if (widget.material.discount != "") {
      percentage = double.parse(widget.material.discount);
      discount = salePrice - (salePrice * percentage);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        width: screenWidth * 0.53,
        height: screenHeight * 0.14,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 5),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.19,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: widget.material.url_photo.isNotEmpty
                  ? Image.network(
                      widget.material.url_photo,
                      fit: BoxFit.cover,
                      height: 110,
                    )
                  : const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: widget.showQuantity
                      ? screenWidth * 0.4
                      : screenWidth * 0.27,
                  child: Text(
                    widget.material.name,
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (percentage > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!widget.showQuantity)
                        Text(
                          'Antes: ${widget.material.salePrice} ${widget.material.size}',
                          style: GoogleFonts.varelaRound(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w300),
                        ),
                      if (widget.showQuantity)
                        Text(
                          'cantidad: ${widget.material.quantity}',
                          style: GoogleFonts.varelaRound(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      Text(
                        '\$${discount.round()}',
                        style: GoogleFonts.varelaRound(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                if (percentage <= 0)
                  Text(
                    '\$${widget.material.salePrice} ${widget.material.size}',
                    style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w300),
                  ),
              ],
            ),
            if (!widget.showQuantity)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 0) {
                            quantity--;
                          }
                          widget.material.quantity = quantity.toString();
                        });
                        verification();
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Palette.accentBackground,
                        size: 15,
                      ),
                    ),
                    Text(
                      '$quantity',
                      style: GoogleFonts.varelaRound(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                          widget.material.quantity = quantity.toString();
                        });
                        verification();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Palette.accentBackground,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
