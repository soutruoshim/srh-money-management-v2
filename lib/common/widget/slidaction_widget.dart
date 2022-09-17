import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monsey/common/constant/colors.dart';
import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/constant/styles.dart';

class SlidactionWidget extends StatelessWidget {
  const SlidactionWidget(
      {Key? key,
      required this.child,
      this.showLabel = true,
      this.extentRatio,
      this.editFunc,
      this.removeFunc})
      : super(key: key);
  final Widget child;
  final bool showLabel;
  final double? extentRatio;
  final Function()? editFunc;
  final Function()? removeFunc;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: extentRatio ?? 0.65,
        children: [
          CustomSlidableAction(
            padding: const EdgeInsets.symmetric(vertical: 0),
            onPressed: (context) {
              editFunc!();
            },
            backgroundColor: naplesYellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icNote, width: 24, height: 24, color: black),
                const SizedBox(height: 8),
                if (showLabel) ...[
                  Text(
                    'Edit',
                    style: headline(context: context, fontWeight: '700'),
                  )
                ]
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (context) {
              removeFunc!();
            },
            backgroundColor: redCrayola,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_outline_rounded,
                    size: 24, color: white),
                const SizedBox(height: 8),
                if (showLabel) ...[
                  Text(
                    'Remove',
                    style: headline(color: white, fontWeight: '700'),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
