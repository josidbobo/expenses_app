import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar({
    Key? key,
    required this.label,
    required this.spendingAmount,
    required this.spendingPctOfTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
         SizedBox(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text('\$${spendingAmount.toStringAsFixed(0)}'))
                    ),
          SizedBox(
            height: constraints.maxHeight * 0.03,
          ),
           SizedBox(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                spendingPctOfTotal.isNaN
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          color: const Color.fromRGBO(220, 220, 220, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    : FractionallySizedBox(
                        heightFactor: spendingPctOfTotal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.03),
          SizedBox(
            height: constraints.maxHeight * 0.13,
            child: FittedBox(child: Text(label)),
            ),
        ],
      );
    });
  }
}
