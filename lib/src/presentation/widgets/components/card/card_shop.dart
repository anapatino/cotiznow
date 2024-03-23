import 'package:cotiznow/lib.dart';
import 'package:cotiznow/src/domain/domain.dart';

class CardShop extends StatefulWidget {
  final Materials material;
  final Function(Materials) increaseQuantity;
  final Function(Materials) decreaseQuantity;

  final bool showQuantity;

  const CardShop({
    Key? key,
    required this.material,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.showQuantity,
  }) : super(key: key);

  @override
  State<CardShop> createState() => _CardShopState();
}

class _CardShopState extends State<CardShop> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = int.parse(widget.material.quantity);
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
              child: widget.material.urlPhoto.isNotEmpty
                  ? Image.network(
                      widget.material.urlPhoto,
                      fit: BoxFit.cover,
                      height: double.infinity,
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
                    '${widget.material.name}-${widget.material.unit} ${widget.material.size}',
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
                      Text(
                        '\$${discount.round()}',
                        style: GoogleFonts.varelaRound(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                if (widget.showQuantity)
                  Text(
                    'cantidad: ${widget.material.quantity}',
                    style: GoogleFonts.varelaRound(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (percentage <= 0)
                  Text(
                    '\$${widget.material.salePrice}',
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
                      color: Palette.accentBackground,
                      onPressed: () {
                        setState(() {
                          if (quantity > 0) {
                            quantity--;
                            widget.decreaseQuantity(widget.material);
                          }
                        });
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
                      color: Palette.accentBackground,
                      onPressed: () {
                        setState(() {
                          quantity++;
                          widget.increaseQuantity(widget.material);
                        });
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
